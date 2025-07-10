-- Create the database and switch to it
CREATE DATABASE IF NOT EXISTS quiz_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quiz_app;

-- USERS
CREATE TABLE users (
                       user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       hashed_password TEXT NOT NULL,
                       salt_password VARCHAR(50) NOT NULL,
                       time_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       num_quizzes_created BIGINT DEFAULT 0,
                       num_quizzes_taken BIGINT DEFAULT 0,
                       was_top1 BOOLEAN DEFAULT FALSE,
                       taken_practice BOOLEAN DEFAULT FALSE,
                       role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
                       CHECK (email LIKE '%@gmail.com')
);

-- CATEGORIES
CREATE TABLE categories (
                            category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            category_name VARCHAR(100) UNIQUE NOT NULL
);

-- QUIZZES
CREATE TABLE quizzes (
                         quiz_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         quiz_title VARCHAR(100) NOT NULL,
                         description TEXT,
                         created_by BIGINT,
                         randomized BOOLEAN DEFAULT FALSE,
                         is_multiple_page BOOLEAN DEFAULT FALSE,
                         immediate_correction BOOLEAN DEFAULT FALSE,
                         allow_practice BOOLEAN DEFAULT FALSE,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         quiz_category BIGINT,
                         total_time_limit BIGINT,
                         submissions_number BIGINT DEFAULT 0,
                         FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE ,
                         FOREIGN KEY (quiz_category) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- QUESTIONS
CREATE TABLE questions (
                           question_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           quiz_id BIGINT,
                           question_type VARCHAR(50) NOT NULL,
                           question_text TEXT,
                           image_url TEXT,
                           time_limit BIGINT,
                           question_order INT,
                           FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE
);

-- CORRECT ANSWERS
CREATE TABLE correct_answers (
                                 answer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 question_id BIGINT,
                                 answer_text TEXT,
                                 match_order BIGINT,
                                 FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

--  SUBMISSIONS
CREATE TABLE submissions (
                             submission_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             user_id BIGINT,
                             quiz_id BIGINT,
                             num_correct_answers BIGINT,
                             num_total_answers BIGINT,
                             score BIGINT,
                             time_spent BIGINT,
                             submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                             FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE
);

-- USER ANSWERS
CREATE TABLE user_answers (
                              user_answer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                              submission_id BIGINT,
                              question_id BIGINT,
                              answer_text TEXT,
                              is_correct BOOLEAN,
                              answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (submission_id) REFERENCES submissions(submission_id) ON DELETE CASCADE,
                              FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

-- TAGS
CREATE TABLE tags (
                      tag_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      tag_name VARCHAR(100) UNIQUE NOT NULL
);

-- QUIZ_TAGS
CREATE TABLE quiz_tags (
                           quiz_id BIGINT,
                           tag_id BIGINT,
                           PRIMARY KEY (quiz_id, tag_id),
                           FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
                           FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- ACHIEVEMENTS
CREATE TABLE achievements (
                              achievement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                              achievement_name VARCHAR(100) NOT NULL,
                              achievement_description TEXT,
                              icon_url TEXT
);

-- USER_ACHIEVEMENTS
CREATE TABLE user_achievements (
                                   user_id BIGINT,
                                   achievement_id BIGINT,
                                   awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   PRIMARY KEY (user_id, achievement_id),
                                   FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                   FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE
);

-- FRIEND REQUESTS
CREATE TABLE friend_requests (
                                 request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 sender_id BIGINT,
                                 receiver_id BIGINT,
                                 status VARCHAR(20) CHECK (status IN ('pending', 'accepted', 'rejected')),
                                 sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                 FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE friendships (
                             user_id1 BIGINT,
                             user_id2 BIGINT,
                             friends_since TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (user_id1, user_id2),
                             FOREIGN KEY (user_id1) REFERENCES users(user_id) ON DELETE CASCADE,
                             FOREIGN KEY (user_id2) REFERENCES users(user_id) ON DELETE CASCADE,
                             CHECK (user_id1 < user_id2)  -- Enforces consistent order
);


-- MESSAGES
CREATE TABLE messages (
                          message_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          sender_id BIGINT,
                          receiver_id BIGINT,
                          message_type VARCHAR(50) CHECK (message_type IN ('friend_request', 'challenge', 'note')),
                          content TEXT,
                          quiz_id BIGINT,
                          friend_request_id BIGINT,
                          sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          is_read BOOLEAN DEFAULT FALSE,
                          FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
                          FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE,
                          FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
                          FOREIGN KEY (friend_request_id) REFERENCES friend_requests(request_id) ON DELETE CASCADE
);

CREATE TABLE possible_answers (
                                  possible_answer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                  question_id BIGINT NOT NULL,
                                  possible_answer_text TEXT NOT NULL,
                                  FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

CREATE TABLE announcements (
                               announcement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                               title VARCHAR(200) NOT NULL,
                               message TEXT NOT NULL,
                               created_by BIGINT,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               is_active BOOLEAN DEFAULT TRUE,
                               FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- VIEWS --

--  Top 10 most popular quizzes
CREATE VIEW view_popular_quizzes AS
SELECT
    q.quiz_id,
    q.quiz_title,
    q.description,
    q.submissions_number,
    u.username AS creator
FROM quizzes q
         JOIN users u ON q.created_by = u.user_id
ORDER BY q.submissions_number DESC
    LIMIT 10;

--  Top 10 recently created quizzes
CREATE VIEW view_recent_quizzes AS
SELECT
    q.quiz_id,
    q.quiz_title,
    q.description,
    q.created_at,
    u.username AS creator
FROM quizzes q
         JOIN users u ON q.created_by = u.user_id
ORDER BY q.created_at DESC
    LIMIT 10;

--  Shows quizzes the user has recently taken or created
CREATE VIEW view_user_recent_activity AS
SELECT
    u.user_id,
    u.username,
    s.quiz_id,
    q.quiz_title,
    s.submitted_at AS activity_time,
    'taken' AS activity_type
FROM submissions s
         JOIN users u ON s.user_id = u.user_id
         JOIN quizzes q ON s.quiz_id = q.quiz_id
UNION ALL
SELECT
    u.user_id,
    u.username,
    q.quiz_id,
    q.quiz_title,
    q.created_at AS activity_time,
    'created' AS activity_type
FROM quizzes q
         JOIN users u ON q.created_by = u.user_id;

--  Shows achievements earned by a user
CREATE VIEW view_user_achievements AS
SELECT
    ua.user_id,
    u.username,
    a.achievement_name,
    a.icon_url,
    ua.awarded_at
FROM user_achievements ua
         JOIN users u ON ua.user_id = u.user_id
         JOIN achievements a ON ua.achievement_id = a.achievement_id;

--  Recent unread messages with type info
CREATE VIEW view_unread_messages_summary AS
SELECT
    m.message_id,
    m.receiver_id,
    u.username AS sender,
    m.message_type,
    m.sent_at,
    m.is_read
FROM messages m
         JOIN users u ON m.sender_id = u.user_id
WHERE m.is_read = FALSE
ORDER BY m.sent_at DESC;

--  Friends’ recent quiz or achievement activity
CREATE VIEW view_friends_recent_activity AS
SELECT
    f.user_id1 AS viewer_id,
    u.user_id AS friend_id,
    u.username,
    q.quiz_id,
    q.quiz_title,
    q.created_at AS activity_time,
    'created_quiz' AS activity_type
FROM friendships f
         JOIN users u ON f.user_id2 = u.user_id
         JOIN quizzes q ON q.created_by = u.user_id
UNION ALL
SELECT
    f.user_id1,
    u.user_id,
    u.username,
    s.quiz_id,
    q.quiz_title,
    s.submitted_at,
    'taken_quiz'
FROM friendships f
         JOIN users u ON f.user_id2 = u.user_id
         JOIN submissions s ON s.user_id = u.user_id
         JOIN quizzes q ON q.quiz_id = s.quiz_id
UNION ALL
SELECT
    f.user_id1,
    u.user_id,
    u.username,
    NULL AS quiz_id,
    NULL AS quiz_title,
    ua.awarded_at,
    'earned_achievement'
FROM friendships f
         JOIN users u ON f.user_id2 = u.user_id
         JOIN user_achievements ua ON ua.user_id = u.user_id;

--  Top 10 scores on a specific quiz
CREATE VIEW view_quiz_leaderboard AS
SELECT
    s.quiz_id,
    s.user_id,
    u.username,
    MAX(s.score) AS top_score,
    MIN(s.time_spent) AS best_time
FROM submissions s
         JOIN users u ON s.user_id = u.user_id
GROUP BY s.quiz_id, s.user_id
ORDER BY top_score DESC, best_time ASC
    LIMIT 10;

--  Shows a user’s history on one quiz, sortable by time, score, or accuracy
CREATE VIEW view_user_quiz_performance AS
SELECT
    s.user_id,
    u.username,
    s.quiz_id,
    q.quiz_title,
    s.score,
    s.time_spent,
    s.num_correct_answers,
    s.num_total_answers,
    s.submitted_at
FROM submissions s
         JOIN users u ON s.user_id = u.user_id
         JOIN quizzes q ON s.quiz_id = q.quiz_id;

-- Friend list for each user (bidirectional)
CREATE VIEW friend_list AS
SELECT user_id1 AS user_id, user_id2 AS friend_id, friends_since FROM friendships
UNION
SELECT user_id2 AS user_id, user_id1 AS friend_id, friends_since FROM friendships;


-- View of pending friend requests
CREATE VIEW friend_requests_pending AS
SELECT request_id, sender_id, receiver_id, sent_at
FROM friend_requests
WHERE status = 'pending';

-- View of quiz challenges with challenge score info
CREATE VIEW quiz_challenges AS
SELECT
    m.message_id,
    m.sender_id,
    m.receiver_id,
    m.quiz_id,
    m.sent_at,
    m.is_read,
    s.score AS challenger_score
FROM messages m
         LEFT JOIN submissions s
                   ON m.sender_id = s.user_id AND m.quiz_id = s.quiz_id
WHERE m.message_type = 'challenge';

-- quiz summary stats per quiz
CREATE VIEW view_quiz_summary AS
SELECT
    q.quiz_id,
    q.quiz_title,
    q.description,
    u.username AS creator,
    COUNT(s.submission_id) AS times_taken,
    ROUND(AVG(s.score), 2) AS avg_score,
    ROUND(AVG(s.time_spent), 2) AS avg_time
FROM quizzes q
         LEFT JOIN users u ON q.created_by = u.user_id
         LEFT JOIN submissions s ON s.quiz_id = q.quiz_id
GROUP BY q.quiz_id;
