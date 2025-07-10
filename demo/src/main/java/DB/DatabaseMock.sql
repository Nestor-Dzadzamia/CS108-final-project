-- Enhanced Mock Data for Quiz Application
-- USERS
INSERT INTO users (username, email, hashed_password, salt_password, num_quizzes_created) VALUES
     ('Nestor_Dzadzamia', 'Nestor@gmail.com', '452928968d7f7fdc3ccadcb7219bf4c8ccfbd12c', '', 2),
     ('Sandro_Mamamtavrishvili', 'Sandro@gmail.com', '64bc56ddc1b256138a1e36319a3da09ebbb31f70', '', 2),
     ('Saba_Delibashvili', 'Saba@gmail.com', '3402f1109751882581c2b3a68a0af205e0d49e46', '', 1),
     ('Giorgi_Urtmelidze', 'Giorgi@gmail.com', '1d65c13a970a22a4cceb4ffc82fac7abb8e73194', '', 1),
     ('TechGuru_Alex', 'alex.tech@gmail.com', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'salt123', 3),
     ('BookWorm_Maria', 'maria.books@gmail.com', 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0a1', 'salt456', 2),
     ('SpaceExplorer_John', 'john.space@gmail.com', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0a1b2', 'salt789', 2),
     ('ChefMaster_Emma', 'emma.chef@gmail.com', 'd4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0a1b2c3', 'salt101', 1),
     ('admin', 'admin@gmail.com', 'e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0a1b2c3d4', 'adminsalt', 0);

-- CATEGORIES
INSERT INTO categories (category_name) VALUES
   ('Sports'),
   ('History'),
   ('Math'),
   ('Biology'),
   ('Music'),
   ('Movies'),
   ('Technology'),
   ('Literature'),
   ('Geography'),
   ('Space & Astronomy'),
   ('Gaming'),
   ('Culinary Arts');

-- QUIZZES
INSERT INTO quizzes (quiz_title, description, created_by, randomized, is_multiple_page, immediate_correction, allow_practice, quiz_category, total_time_limit) VALUES
   ('Guess Georgian athletes', 'Show how well you know Georgian sportsmen', 1, FALSE, FALSE, FALSE, FALSE, 1, 20),
   ('History of Georgia', 'Show your knowledge of Georgian history', 2, TRUE, TRUE, TRUE, TRUE, 2, 20),
   ('Math Genius', 'Test your skills with challenging math problems!', 3, TRUE, FALSE, TRUE, TRUE, 3, 25),
   ('Biology Facts', 'Explore the wonders of life science with this quiz.', 4, FALSE, TRUE, FALSE, TRUE, 4, 15),
   ('Music Legends', 'See how much you know about world-famous musicians and bands.', 1, TRUE, FALSE, FALSE, TRUE, 5, 20),
   ('Famous Movies', 'Guess the movie from its plot and quotes!', 2, TRUE, TRUE, FALSE, FALSE, 6, 20),
   ('Programming Fundamentals', 'Test your knowledge of programming languages, algorithms, and software development', 5, FALSE, FALSE, TRUE, TRUE, 7, 30),
   ('Tech Giants & Innovation', 'Explore the world of technology companies and groundbreaking innovations', 5, TRUE, FALSE, FALSE, TRUE, 7, 25),
   ('World Literature Classics', 'Journey through the greatest works of literature from around the globe', 6, FALSE, TRUE, TRUE, TRUE, 8, 35),
   ('Modern Poetry & Authors', 'Discover contemporary literature and influential modern writers', 6, TRUE, FALSE, FALSE, TRUE, 8, 20),
   -- Quiz 17: General Knowledge Mix (new quiz with unordered questions)
   ('General Knowledge Mix', 'Test your knowledge across various topics - order doesn\'t matter!', 5, FALSE, FALSE, TRUE, TRUE, 1, 20);

-- QUESTIONS(questions 37-60, 97-102)
-- Question types: question-response, fill-blank, multiple-choice, picture-response, multi-answer, multiple-multiple-choice, matching

-- Programming Fundamentals (quiz_id = 7, questions 37-42)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (7, 'fill-blank', 'Python is a _ programming language known for its simplicity.', NULL, 60, 1),
     (7, 'question-response', 'What does HTML stand for?', NULL, 60, 2),
     (7, 'multiple-choice', 'Which of these is NOT a programming language?', NULL, 60, 3),
     (7, 'picture-response', 'Identify the programming language logo shown in the image.', 'https://upload.wikimedia.org/wikipedia/commons/c/c3/Python-logo-notext.svg', 60, 4),
     (7, 'multi-answer', 'List three popular web development frameworks.', NULL, 60, 5),
     (7, 'multiple-multiple-choice', 'Select all object-oriented programming languages.', NULL, 60, 6);

-- Tech Giants & Innovation (quiz_id = 8, questions 43-48)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (8, 'matching', 'Match each tech company to its founder.', NULL, 90, 1),
     (8, 'multi-answer', 'Name the first three versions of the iPhone operating system.', NULL, 90, 2),
     (8, 'multiple-choice', 'Which company developed the first commercial microprocessor?', NULL, 90, 3),
     (8, 'picture-response', 'Which tech company logo is shown in this image?', 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg', 90, 4),
     (8, 'question-response', 'What year was Google founded?', NULL, 90, 5),
     (8, 'fill-blank', 'The World Wide Web was invented by _ at CERN.', NULL, 90, 6);

-- World Literature Classics (quiz_id = 9, questions 49-54)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (9, 'matching', 'Match each classic novel to its author.', NULL, 120, 1),
     (9, 'question-response', 'In which Shakespeare play does the character Hamlet appear?', NULL, 120, 2),
     (9, 'multiple-choice', 'Which novel begins with "It was the best of times, it was the worst of times"?', NULL, 120, 3),
     (9, 'picture-response', 'Who is the author shown in this portrait?', 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Charles_Dickens_-_Project_Gutenberg_eText_13103.jpg', 120, 4),
     (9, 'fill-blank', 'George Orwell wrote the dystopian novel "_" published in 1949.', NULL, 120, 5),
     (9, 'multiple-multiple-choice', 'Select all novels written by Jane Austen.', NULL, 120, 6);

-- Modern Poetry & Authors (quiz_id = 10, questions 55-60)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (10, 'question-response', 'Who wrote the poem "The Road Not Taken"?', NULL, 90, 1),
     (10, 'fill-blank', 'Maya Angelou is famous for her autobiography "I Know Why the _ Bird Sings".', NULL, 90, 2),
     (10, 'multiple-choice', 'Which poet is known as the "Bard of Avon"?', NULL, 90, 3),
     (10, 'matching', 'Match each poet to their most famous work.', NULL, 90, 4),
     (10, 'multi-answer', 'Name three Beat Generation poets.', NULL, 90, 5),
     (10, 'picture-response', 'Which famous poet is shown in this photograph?', 'https://upload.wikimedia.org/wikipedia/commons/0/05/Langston_Hughes_by_Carl_Van_Vechten_1936.jpg', 90, 6);

-- Add unordered multi-answer questions to Quiz 17 (questions 97-102)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (17, 'multi-answer', 'Name any 4 planets in our solar system.', NULL, 90, 1),
     (17, 'multi-answer', 'List any 3 programming languages you know.', NULL, 90, 2),
     (17, 'multi-answer', 'Name any 5 European countries.', NULL, 90, 3),
     (17, 'multi-answer', 'List any 3 colors of the rainbow.', NULL, 90, 4),
     (17, 'multi-answer', 'Name any 4 types of cuisine.', NULL, 90, 5),
     (17, 'question-response', 'What is the capital of France?', NULL, 90, 6);


-- CORRECT ANSWERS

-- Programming Fundamentals (questions 37-42)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q37: Fill in the blank
    (37, 'high-level', -1),
    (37, 'interpreted', -1),
    (37, 'object-oriented', -1),
    -- Q38: Question response
    (38, 'HyperText Markup Language', -1),
    (38, 'Hypertext Markup Language', -1),
    -- Q39: Multiple choice
    (39, 'Photoshop', -1),
    -- Q40: Picture response
    (40, 'Python', -1),
    -- Q41: Multi-answer
    (41, 'React', 1),
    (41, 'Django', 2),
    (41, 'Vue.js', 3),
    (41, 'Angular', 4),
    (41, 'Laravel', 5),
    -- Q42: Multi-select
    (42, 'Java', -1),
    (42, 'Python', -1),
    (42, 'C++', -1),
    (42, 'C#', -1);

-- Tech Giants & Innovation (questions 43-48)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q43: Matching
    (43, 'Apple-Steve Jobs', -1),
    (43, 'Microsoft-Bill Gates', -1),
    (43, 'Facebook-Mark Zuckerberg', -1),
    (43, 'Amazon-Jeff Bezos', -1),
    -- Q44: Multi-answer
    (44, 'iPhone OS 1.0', 1),
    (44, 'iPhone OS 2.0', 2),
    (44, 'iPhone OS 3.0', 3),
    -- Q45: Multiple choice
    (45, 'Intel', -1),
    -- Q46: Picture response
    (46, 'Apple', -1),
    -- Q47: Question response
    (47, '1998', -1),
    -- Q48: Fill in the blank
    (48, 'Tim Berners-Lee', -1);

-- World Literature Classics (questions 49-54)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q49: Matching
    (49, 'Pride and Prejudice-Jane Austen', -1),
    (49, '1984-George Orwell', -1),
    (49, 'To Kill a Mockingbird-Harper Lee', -1),
    (49, 'The Great Gatsby-F. Scott Fitzgerald', -1),
    -- Q50: Question response
    (50, 'Hamlet', -1),
    -- Q51: Multiple choice
    (51, 'A Tale of Two Cities', -1),
    -- Q52: Picture response
    (52, 'Charles Dickens', -1),
    -- Q53: Fill in the blank
    (53, '1984', -1),
    (53, 'Nineteen Eighty-Four', -1),
    -- Q54: Multi-select
    (54, 'Pride and Prejudice', -1),
    (54, 'Emma', -1),
    (54, 'Sense and Sensibility', -1);

-- Modern Poetry & Authors (questions 55-60)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q55: Question response
    (55, 'Robert Frost', -1),
    -- Q56: Fill in the blank
    (56, 'Caged', -1),
    -- Q57: Multiple choice
    (57, 'William Shakespeare', -1),
    -- Q58: Matching
    (58, 'Robert Frost-The Road Not Taken', -1),
    (58, 'Maya Angelou-I Know Why the Caged Bird Sings', -1),
    (58, 'Langston Hughes-The Negro Speaks of Rivers', -1),
    -- Q59: Multi-answer
    (59, 'Jack Kerouac', 1),
    (59, 'Allen Ginsberg', 2),
    (59, 'William S. Burroughs', 3),
    -- Q60: Picture response
    (60, 'Langston Hughes', -1);

-- UNORDERED correct answers (match_order = -1 means any order is acceptable)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q97: Any 4 planets (order doesn't matter)
    (97, 'Mercury', -1),
    (97, 'Venus', -1),
    (97, 'Earth', -1),
    (97, 'Mars', -1),
    (97, 'Jupiter', -1),
    (97, 'Saturn', -1),
    (97, 'Uranus', -1),
    (97, 'Neptune', -1),

    -- Q98: Any 3 programming languages (order doesn't matter)
    (98, 'JavaScript', -1),
    (98, 'Python', -1),
    (98, 'Java', -1),
    (98, 'C++', -1),
    (98, 'C#', -1),
    (98, 'PHP', -1),
    (98, 'Ruby', -1),
    (98, 'Go', -1),
    (98, 'Swift', -1),
    (98, 'Kotlin', -1),

    -- Q99: Any 5 European countries (order doesn't matter)
    (99, 'France', -1),
    (99, 'Germany', -1),
    (99, 'Italy', -1),
    (99, 'Spain', -1),
    (99, 'United Kingdom', -1),
    (99, 'Netherlands', -1),
    (99, 'Belgium', -1),
    (99, 'Switzerland', -1),
    (99, 'Austria', -1),
    (99, 'Poland', -1),
    (99, 'Greece', -1),
    (99, 'Portugal', -1),
    (99, 'Sweden', -1),
    (99, 'Norway', -1),
    (99, 'Denmark', -1),

    -- Q100: Any 3 colors of the rainbow (order doesn't matter)
    (100, 'Red', -1),
    (100, 'Orange', -1),
    (100, 'Yellow', -1),
    (100, 'Green', -1),
    (100, 'Blue', -1),
    (100, 'Indigo', -1),
    (100, 'Violet', -1),
    (100, 'Purple', -1),

    -- Q101: Any 4 types of cuisine (order doesn't matter)
    (101, 'Italian', -1),
    (101, 'Chinese', -1),
    (101, 'Mexican', -1),
    (101, 'Indian', -1),
    (101, 'French', -1),
    (101, 'Japanese', -1),
    (101, 'Thai', -1),
    (101, 'Greek', -1),
    (101, 'Spanish', -1),
    (101, 'Korean', -1),
    (101, 'Vietnamese', -1),
    (101, 'Lebanese', -1),

    -- Q102: Simple question-response
    (102, 'Paris', -1);


-- POSSIBLE ANSWERS for multiple choice questions

-- Programming Fundamentals Q39
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (39, 'Java'),
     (39, 'Python'),
     (39, 'JavaScript'),
     (39, 'Photoshop');

-- Tech Giants & Innovation Q45
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (45, 'Intel'),
     (45, 'AMD'),
     (45, 'IBM'),
     (45, 'Motorola');

-- World Literature Q51
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (51, 'A Tale of Two Cities'),
     (51, 'Great Expectations'),
     (51, 'Pride and Prejudice'),
     (51, 'Jane Eyre');

-- Modern Poetry Q57
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (57, 'William Shakespeare'),
     (57, 'Robert Frost'),
     (57, 'Emily Dickinson'),
     (57, 'Walt Whitman');

-- TAGS
INSERT INTO tags (tag_name) VALUES
    ('Olympic'),
    ('Modern History'),
    ('Logic'),
    ('Animals'),
    ('Rock'),
    ('Animated'),
    ('Classic'),
    ('Champions'),
    ('Beginner'),
    ('Advanced'),
    ('Programming'),
    ('Web Development'),
    ('Innovation'),
    ('Contemporary'),
    ('Geography'),
    ('Space'),
    ('Retro Gaming'),
    ('International'),
    ('Educational'),
    ('Interactive');

-- QUIZ TAGS
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    -- Programming Fundamentals
    (7, 11), (7, 12), (7, 9),
    -- Tech Giants & Innovation
    (8, 13), (8, 10), (8, 19),
    -- World Literature Classics
    (9, 7), (9, 19), (9, 10),
    -- Modern Poetry & Authors
    (10, 14), (10, 19), (10, 9);

-- ACHIEVEMENTS
INSERT INTO achievements (achievement_name, achievement_description, icon_url) VALUES
   ('Amateur Author', 'Created your first quiz!', 'icons/amateur_author.png'),
   ('Prolific Author', 'Created 5 quizzes!', 'icons/prolific_author.png'),
   ('Quiz Machine', 'Taken 10 quizzes!', 'icons/quiz_machine.png'),
   ('Practice Makes Perfect', 'Completed 3 practice quizzes!', 'icons/practice.png'),
   ('Perfect Score', 'Achieved 100% on any quiz!', 'icons/perfect_score.png'),
   ('Speed Demon', 'Completed a quiz in under 2 minutes!', 'icons/speed_demon.png'),
   ('Knowledge Seeker', 'Taken quizzes in 5 different categories!', 'icons/knowledge_seeker.png'),
   ('Social Butterfly', 'Added 10 friends!', 'icons/social_butterfly.png'),
   ('Challenge Master', 'Sent 5 quiz challenges to friends!', 'icons/challenge_master.png'),
   ('Consistent Learner', 'Taken a quiz every day for a week!', 'icons/consistent_learner.png');

-- USER ACHIEVEMENTS
INSERT INTO user_achievements (user_id, achievement_id) VALUES
    -- Nestor
    (1, 1), (1, 3), (1, 5),
    -- Sandro
    (2, 1), (2, 7),
    -- Saba
    (3, 1), (3, 4), (3, 6),
    -- Giorgi
    (4, 1), (4, 8),
    -- Alex (tech guru)
    (5, 1), (5, 2), (5, 5), (5, 7),
    -- Maria (book worm)
    (6, 1), (6, 3), (6, 10),
    -- John (space explorer)
    (7, 1), (7, 6), (7, 9),
    -- Emma (chef)
    (8, 1), (8, 4);

-- FRIEND REQUESTS
INSERT INTO friend_requests (sender_id, receiver_id, status) VALUES
     (1, 2, 'accepted'),
     (3, 4, 'accepted'),
     (5, 6, 'pending'),
     (7, 8, 'accepted'),
     (2, 5, 'pending'),
     (6, 7, 'rejected'),
     (1, 5, 'accepted'),
     (3, 6, 'accepted');

-- FRIENDSHIPS
INSERT INTO friendships (user_id1, user_id2) VALUES
     (1, 2), -- Nestor & Sandro
     (3, 4), -- Saba & Giorgi
     (7, 8), -- John & Emma
     (1, 5), -- Nestor & Alex
     (3, 6), -- Saba & Maria
     (2, 3), -- Sandro & Saba
     (5, 7), -- Alex & John
     (6, 8); -- Maria & Emma

-- SAMPLE SUBMISSIONS
INSERT INTO submissions (user_id, quiz_id, num_correct_answers, num_total_answers, score, time_spent) VALUES
  -- Various users taking different quizzes with realistic scores
  (1, 7, 5, 6, 83, 420),  -- Nestor: Programming quiz
  (2, 9, 4, 6, 67, 680),  -- Sandro: Literature quiz
  (5, 7, 6, 6, 100, 380),  -- Alex: Programming quiz (perfect score)
  (5, 8, 5, 6, 83, 450),   -- Alex: Tech Giants quiz
  (6, 9, 5, 6, 83, 720),   -- Maria: Literature quiz
  (6, 10, 4, 6, 67, 610),  -- Maria: Poetry quiz
  (1, 1, 5, 6, 83, 450),   -- Nestor: Georgian athletes
  (2, 2, 4, 6, 67, 620);   -- Sandro: Georgian history

-- SAMPLE USER ANSWERS
INSERT INTO user_answers (submission_id, question_id, answer_text, is_correct) VALUES
   -- Sample answers for some submissions
   (1, 37, 'high-level', TRUE),
   (1, 38, 'HyperText Markup Language', TRUE),
   (1, 39, 'Java', FALSE),
   (1, 40, 'Python', TRUE),
   (1, 41, 'React, Django, Vue.js', TRUE),
   (1, 42, 'Java,Python,C++', FALSE);

-- MESSAGES
INSERT INTO messages (sender_id, receiver_id, message_type, content, quiz_id, is_read) VALUES
   (1, 2, 'challenge', 'challenged you to take "Programming Fundamentals"! My best score: 83', 7, FALSE),
   (5, 1, 'note', 'Great job on the programming quiz! You really know your stuff.', NULL, TRUE),
   (6, 3, 'challenge', 'challenged you to take "World Literature Classics"! My best score: 83', 9, FALSE),
   (7, 8, 'note', 'Hey Emma, hope you are doing well!', NULL, TRUE),
   (8, 7, 'note', 'Thanks for checking in! Hope to see you soon.', NULL, TRUE);