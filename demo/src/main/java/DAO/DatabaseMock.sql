-- USERS
INSERT INTO users (username, email, hashed_password, salt_password, num_quizzes_created) VALUES
    ('Nestor_Dzadzamia', 'Nestor@gmail.com', '452928968d7f7fdc3ccadcb7219bf4c8ccfbd12c', '', 2),
    ('Sandro_Mamamtavrishvili', 'Sandro@gmail.com', '64bc56ddc1b256138a1e36319a3da09ebbb31f70', '', 2),
    ('Saba_Delibashvili', 'Saba@gmail.com', '3402f1109751882581c2b3a68a0af205e0d49e46', '', 1),
    ('Giorgi_Urtmelidze', 'Giorgi@gmail.com', '1d65c13a970a22a4cceb4ffc82fac7abb8e73194', '', 1);


-- CATEGORIES
INSERT INTO categories (category_name) VALUES 
	('Sports'), 
    ('History'),
    ('Math'),
    ('Biology'),
    ('Music'),
    ('Movies');


-- QUIZZES
INSERT INTO quizzes (quiz_title, description, created_by, randomized, is_multiple_page, immediate_correction, allow_practice, quiz_category, total_time_limit) VALUES 
	('Guess Georgian athletes', 'Show how well you know Georgian sportsmans', 1, FALSE, FALSE, FALSE, FALSE, 1, 20),
	('History of Georgia', 'Show your knowledge of Georgian history', 2, TRUE, TRUE, TRUE, TRUE, 2, 20),
    ('Math Genius', 'Test your skills with challenging math problems!', 3, TRUE, FALSE, TRUE, TRUE, 3, 25),
    ('Biology Facts', 'Explore the wonders of life science with this quiz.', 4, FALSE, TRUE, FALSE, TRUE, 4, 15),
    ('Music Legends', 'See how much you know about world-famous musicians and bands.', 1, TRUE, FALSE, FALSE, TRUE, 5, 20),
    ('Famous Movies', 'Guess the movie from its plot and quotes!', 2, TRUE, TRUE, FALSE, FALSE, 6, 20);
    
    
-- QUESTIONS
    
-- Guess Georgian athletes (quiz_id = 1)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
    (1, 'MatchingQuestion', 'Match each athlete to their sport.', NULL, 120, 1),
    (1, 'MultiAnswer', 'List all current Georgian Olympic gold medalists.', NULL, 120, 2),
    (1, 'MultipleChoiceAnswer', 'Who is the most decorated Georgian judo champion?', NULL, 120, 3),
    (1, 'MultiSelectQeustion', 'Select all Georgian athletes who have competed at the Olympics.', NULL, 120, 4),
    (1, 'PictureResponse', 'Name the athlete shown in this picture.', 'georgian_athlete.jpg', 120, 5),
    (1, 'QuestionResponse', 'Who was the first Georgian to win an Olympic gold medal?', NULL, 120, 6);

-- History of Georgia (quiz_id = 2)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
    (2, 'MatchingQuestion', 'Match each king to their reign period.', NULL, 120, 1),
    (2, 'MultiAnswer', 'Name all capitals Georgia has had throughout history.', NULL, 120, 2),
    (2, 'MultipleChoiceAnswer', 'Who was Georgia\'s first president?', NULL, 120, 3),
    (2, 'MultiSelectQeustion', 'Select all correct statements about the Georgian Golden Age.', NULL, 120, 4),
    (2, 'PictureResponse', 'Name the historic monument in the image.', 'georgia_monument.jpg', 120, 5),
    (2, 'QuestionResponse', 'When did Georgia declare independence from the Soviet Union?', NULL, 120, 6);

-- Math Genius (quiz_id = 3)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
    (3, 'MatchingQuestion', 'Match each formula to the correct name.', NULL, 120, 1),
    (3, 'MultiAnswer', 'List all prime numbers between 1 and 20.', NULL, 120, 2),
    (3, 'MultipleChoiceAnswer', 'What is the value of π (pi) up to two decimal places?', NULL, 120, 3),
    (3, 'MultiSelectQeustion', 'Select all statements that are always true for even numbers.', NULL, 120, 4),
    (3, 'PictureResponse', 'What geometric shape is shown?', 'triangle.png', 120, 5),
    (3, 'QuestionResponse', 'Solve for x: 2x + 3 = 11.', NULL, 120, 6);

-- Biology Facts (quiz_id = 4)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
    (4, 'MatchingQuestion', 'Match each animal to its correct habitat.', NULL, 120, 1),
    (4, 'MultiAnswer', 'Name all parts of the plant cell.', NULL, 120, 2),
    (4, 'MultipleChoiceAnswer', 'What is the powerhouse of the cell?', NULL, 120, 3),
    (4, 'MultiSelectQeustion', 'Select all mammals from the following list.', NULL, 120, 4),
    (4, 'PictureResponse', 'Identify the organ shown in the picture.', 'heart.png', 120, 5),
    (4, 'QuestionResponse', 'What is the process by which plants make their own food?', NULL, 120, 6);

-- Music Legends (quiz_id = 5)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
    (5, 'MatchingQuestion', 'Match each musician to their band.', NULL, 120, 1),
    (5, 'MultiAnswer', 'List all instruments in a standard rock band.', NULL, 120, 2),
    (5, 'MultipleChoiceAnswer', 'Who is known as the "Queen of Soul"?', NULL, 120, 3),
    (5, 'MultiSelectQeustion', 'Select all Grammy-winning artists from the list.', NULL, 120, 4),
    (5, 'PictureResponse', 'Name the artist in the image.', 'beatles.jpg', 120, 5),
    (5, 'QuestionResponse', 'Who composed the "Fur Elise"?', NULL, 120, 6);

-- Famous Movies (quiz_id = 6)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
    (6, 'MatchingQuestion', 'Match each movie to its director.', NULL, 120, 1),
    (6, 'MultiAnswer', 'List all movies directed by Christopher Nolan.', NULL, 120, 2),
    (6, 'MultipleChoiceAnswer', 'Which movie won the Oscar for Best Picture in 1994?', NULL, 120, 3),
    (6, 'MultiSelectQeustion', 'Select all animated movies from the list.', NULL, 120, 4),
    (6, 'PictureResponse', 'Name the movie shown in this picture.', 'inception.jpg', 120, 5),
    (6, 'QuestionResponse', 'Who played the main character in "Forrest Gump"?', NULL, 120, 6);



-- Quiz 1: Guess Georgian athletes
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q1: Matching (Athlete - Sport)
    (1, 'Lasha Talakhadze - Weightlifting', 1),
    (1, 'Varlam Liparteliani - Judo', 2),
    (1, 'Zurab Datunashvili - Wrestling', 3),
    (1, 'Nino Salukvadze - Shooting', 4),
    -- Q2: MultiAnswer (Gold medalists)
    (2, 'Lasha Talakhadze', 1),
    (2, 'Varlam Liparteliani', 2),
    (2, 'Zurab Datunashvili', 3),
    -- Q3: MultipleChoiceAnswer
    (3, 'Varlam Liparteliani', 1),
    -- Q4: MultiSelectQeustion
    (4, 'Lasha Talakhadze', 1),
    (4, 'Zurab Datunashvili', 2),
    (4, 'Nino Salukvadze', 3),
    -- Q5: PictureResponse
    (5, 'Lasha Talakhadze', 1),
    -- Q6: QuestionResponse
    (6, 'Kakhi Kakhiashvili', 1);

-- Quiz 2: History of Georgia
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q7: Matching (King - Reign period)
    (7, 'David IV - 1089-1125', 1),
    (7, 'Queen Tamar - 1184-1213', 2),
    (7, 'Vakhtang Gorgasali - 447-522', 3),
    -- Q8: MultiAnswer (Capitals)
    (8, 'Mtskheta', 1),
    (8, 'Tbilisi', 2),
    (8, 'Kutaisi', 3),
    -- Q9: MultipleChoiceAnswer
    (9, 'Zviad Gamsakhurdia', 1),
    -- Q10: MultiSelectQeustion
    (10, 'Queen Tamar reigned during the Golden Age.', 1),
    (10, 'Georgia expanded its borders in the 12th century.', 2),
    -- Q11: PictureResponse
    (11, 'Svetitskhoveli Cathedral', 1),
    -- Q12: QuestionResponse
    (12, '1991', 1);

-- Quiz 3: Math Genius
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q13: Matching (Formula - Name)
    (13, 'a^2 + b^2 = c^2 - Pythagorean theorem', 1),
    (13, 'πr^2 - Area of a circle', 2),
    (13, 'V = lwh - Volume of a rectangular prism', 3),
    -- Q14: MultiAnswer (Primes)
    (14, '2', 1),
    (14, '3', 2),
    (14, '5', 3),
    (14, '7', 4),
    (14, '11', 5),
    (14, '13', 6),
    (14, '17', 7),
    (14, '19', 8),
    -- Q15: MultipleChoiceAnswer
    (15, '3.14', 1),
    -- Q16: MultiSelectQeustion
    (16, 'Even numbers are divisible by 2.', 1),
    (16, 'Sum of two even numbers is even.', 2),
    -- Q17: PictureResponse
    (17, 'Triangle', 1),
    -- Q18: QuestionResponse
    (18, '4', 1);

-- Quiz 4: Biology Facts
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q19: Matching (Animal - Habitat)
    (19, 'Camel - Desert', 1),
    (19, 'Polar Bear - Arctic', 2),
    (19, 'Dolphin - Ocean', 3),
    -- Q20: MultiAnswer (Plant cell parts)
    (20, 'Nucleus', 1),
    (20, 'Chloroplast', 2),
    (20, 'Cell wall', 3),
    (20, 'Mitochondria', 4),
    -- Q21: MultipleChoiceAnswer
    (21, 'Mitochondria', 1),
    -- Q22: MultiSelectQeustion
    (22, 'Elephant', 1),
    (22, 'Bat', 2),
    (22, 'Whale', 3),
    -- Q23: PictureResponse
    (23, 'Heart', 1),
    -- Q24: QuestionResponse
    (24, 'Photosynthesis', 1);

-- Quiz 5: Music Legends
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q25: Matching (Musician - Band)
    (25, 'Freddie Mercury - Queen', 1),
    (25, 'John Lennon - The Beatles', 2),
    (25, 'David Gilmour - Pink Floyd', 3),
    -- Q26: MultiAnswer (Rock band instruments)
    (26, 'Guitar', 1),
    (26, 'Bass', 2),
    (26, 'Drums', 3),
    (26, 'Keyboard', 4),
    -- Q27: MultipleChoiceAnswer
    (27, 'Aretha Franklin', 1),
    -- Q28: MultiSelectQeustion
    (28, 'Adele', 1),
    (28, 'Beyoncé', 2),
    (28, 'Elton John', 3),
    -- Q29: PictureResponse
    (29, 'The Beatles', 1),
    -- Q30: QuestionResponse
    (30, 'Beethoven', 1);

-- Quiz 6: Famous Movies
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q31: Matching (Movie - Director)
    (31, 'Inception - Christopher Nolan', 1),
    (31, 'Jurassic Park - Steven Spielberg', 2),
    (31, 'Titanic - James Cameron', 3),
    -- Q32: MultiAnswer (Nolan movies)
    (32, 'Inception', 1),
    (32, 'The Dark Knight', 2),
    (32, 'Interstellar', 3),
    -- Q33: MultipleChoiceAnswer
    (33, 'Forrest Gump', 1),
    -- Q34: MultiSelectQeustion
    (34, 'Toy Story', 1),
    (34, 'Shrek', 2),
    (34, 'Finding Nemo', 3),
    -- Q35: PictureResponse
    (35, 'Inception', 1),
    -- Q36: QuestionResponse
    (36, 'Tom Hanks', 1);


-- Quiz 1: Guess Georgian athletes (question_id 1-6)
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
-- Q1 Matching: Athletes + Sports (left + right)
(1, 'Lasha Talakhadze'),
(1, 'Varlam Liparteliani'),
(1, 'Zurab Datunashvili'),
(1, 'Nino Salukvadze'),
(1, 'Weightlifting'),
(1, 'Judo'),
(1, 'Wrestling'),
(1, 'Shooting'),
-- Q2 MultiAnswer: gold medalists + distractor
(2, 'Lasha Talakhadze'),
(2, 'Varlam Liparteliani'),
(2, 'Zurab Datunashvili'),
(2, 'Nino Salukvadze'),
-- Q3 MultipleChoice: judo champion
(3, 'Varlam Liparteliani'),
(3, 'Avtandil Tchrikishvili'),
(3, 'Shota Chochishvili'),
(3, 'Lasha Shavdatuashvili'),
-- Q4 MultiSelect: olympians + one non-olympian
(4, 'Lasha Talakhadze'),
(4, 'Zurab Datunashvili'),
(4, 'Nino Salukvadze'),
(4, 'Cristiano Ronaldo'),
-- Q5 PictureResponse: athletes
(5, 'Lasha Talakhadze'),
(5, 'Irakli Turmanidze'),
(5, 'Avtandil Chrikishvili'),
-- Q6 QuestionResponse: Olympic gold
(6, 'Kakhi Kakhiashvili'),
(6, 'Nino Salukvadze'),
(6, 'Lasha Talakhadze');


-- Quiz 2: History of Georgia (question_id 7-12)
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
-- Q7 Matching: Kings + Reigns
(7, 'David IV'),
(7, 'Queen Tamar'),
(7, 'Vakhtang Gorgasali'),
(7, '1089-1125'),
(7, '1184-1213'),
(7, '447-522'),
-- Q8 MultiAnswer: capitals
(8, 'Mtskheta'),
(8, 'Tbilisi'),
(8, 'Kutaisi'),
(8, 'Batumi'),
-- Q9 MultipleChoice: president
(9, 'Zviad Gamsakhurdia'),
(9, 'Eduard Shevardnadze'),
(9, 'Mikheil Saakashvili'),
(9, 'Giorgi Margvelashvili'),
-- Q10 MultiSelect: golden age
(10, 'Queen Tamar reigned during the Golden Age.'),
(10, 'Georgia expanded its borders in the 12th century.'),
(10, 'Georgia was under Russian rule.'),
(10, 'David the Builder was a Georgian king.'),
-- Q11 PictureResponse: monuments
(11, 'Svetitskhoveli Cathedral'),
(11, 'Sameba Cathedral'),
(11, 'Jvari Monastery'),
-- Q12 QuestionResponse: year
(12, '1991'),
(12, '1921'),
(12, '2003');


-- Quiz 3: Math Genius (question_id 13-18)
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
-- Q13 Matching: formulas + names
(13, 'a^2 + b^2 = c^2'),
(13, 'πr^2'),
(13, 'V = lwh'),
(13, 'Pythagorean theorem'),
(13, 'Area of a circle'),
(13, 'Volume of a rectangular prism'),
-- Q14 MultiAnswer: primes (plus non-primes)
(14, '2'),
(14, '3'),
(14, '5'),
(14, '7'),
(14, '11'),
(14, '13'),
(14, '17'),
(14, '19'),
(14, '6'),
(14, '8'),
-- Q15 MultipleChoice: pi value
(15, '3.14'),
(15, '2.71'),
(15, '1.41'),
(15, '3.15'),
-- Q16 MultiSelect: even number properties
(16, 'Even numbers are divisible by 2.'),
(16, 'Sum of two even numbers is even.'),
(16, 'Product of two even numbers is odd.'),
(16, 'An even number plus an odd number is odd.'),
-- Q17 PictureResponse: shapes
(17, 'Triangle'),
(17, 'Square'),
(17, 'Circle'),
-- Q18 QuestionResponse: solution for x
(18, '4'),
(18, '5'),
(18, '3');


-- Quiz 4: Biology Facts (question_id 19-24)
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
-- Q19 Matching: animal + habitat
(19, 'Camel'),
(19, 'Polar Bear'),
(19, 'Dolphin'),
(19, 'Desert'),
(19, 'Arctic'),
(19, 'Ocean'),
-- Q20 MultiAnswer: plant cell parts + some animal cell parts
(20, 'Nucleus'),
(20, 'Chloroplast'),
(20, 'Cell wall'),
(20, 'Mitochondria'),
(20, 'Ribosome'),
-- Q21 MultipleChoice: powerhouse
(21, 'Mitochondria'),
(21, 'Nucleus'),
(21, 'Chloroplast'),
(21, 'Ribosome'),
-- Q22 MultiSelect: mammals + non-mammal
(22, 'Elephant'),
(22, 'Bat'),
(22, 'Whale'),
(22, 'Crocodile'),
-- Q23 PictureResponse: organs
(23, 'Heart'),
(23, 'Liver'),
(23, 'Lung'),
-- Q24 QuestionResponse: plant process
(24, 'Photosynthesis'),
(24, 'Respiration'),
(24, 'Transpiration');


-- Quiz 5: Music Legends (question_id 25-30)
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
-- Q25 Matching: musician + band
(25, 'Freddie Mercury'),
(25, 'John Lennon'),
(25, 'David Gilmour'),
(25, 'Queen'),
(25, 'The Beatles'),
(25, 'Pink Floyd'),
-- Q26 MultiAnswer: band instruments + one not typical
(26, 'Guitar'),
(26, 'Bass'),
(26, 'Drums'),
(26, 'Keyboard'),
(26, 'Violin'),
-- Q27 MultipleChoice: Queen of Soul
(27, 'Aretha Franklin'),
(27, 'Whitney Houston'),
(27, 'Beyoncé'),
(27, 'Adele'),
-- Q28 MultiSelect: Grammy winners
(28, 'Adele'),
(28, 'Beyoncé'),
(28, 'Elton John'),
(28, 'Elvis Presley'),
-- Q29 PictureResponse: bands
(29, 'The Beatles'),
(29, 'Rolling Stones'),
(29, 'Pink Floyd'),
-- Q30 QuestionResponse: Fur Elise composer
(30, 'Beethoven'),
(30, 'Mozart'),
(30, 'Chopin');


-- Quiz 6: Famous Movies (question_id 31-36)
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
-- Q31 Matching: movie + director
(31, 'Inception'),
(31, 'Jurassic Park'),
(31, 'Titanic'),
(31, 'Christopher Nolan'),
(31, 'Steven Spielberg'),
(31, 'James Cameron'),
-- Q32 MultiAnswer: Nolan movies + others
(32, 'Inception'),
(32, 'The Dark Knight'),
(32, 'Interstellar'),
(32, 'Forrest Gump'),
-- Q33 MultipleChoice: Best Picture 1994
(33, 'Forrest Gump'),
(33, 'Pulp Fiction'),
(33, 'The Shawshank Redemption'),
(33, 'Four Weddings and a Funeral'),
-- Q34 MultiSelect: animated movies + non-animated
(34, 'Toy Story'),
(34, 'Shrek'),
(34, 'Finding Nemo'),
(34, 'Titanic'),
-- Q35 PictureResponse: movies
(35, 'Inception'),
(35, 'Interstellar'),
(35, 'Memento'),
-- Q36 QuestionResponse: Forrest Gump actor
(36, 'Tom Hanks'),
(36, 'Robin Wright'),
(36, 'Gary Sinise');


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
    ('Advanced');


-- Quiz 1: Guess Georgian athletes
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    (1, 1),  -- Olympic
    (1, 8);  -- Champions

-- Quiz 2: History of Georgia
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    (2, 2),  -- Modern History
    (2, 7);  -- Classic

-- Quiz 3: Math Genius
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    (3, 3),  -- Logic
    (3, 10); -- Advanced

-- Quiz 4: Biology Facts
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    (4, 4),  -- Animals
    (4, 9);  -- Beginner

-- Quiz 5: Music Legends
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    (5, 5),  -- Rock
    (5, 7);  -- Classic

-- Quiz 6: Famous Movies
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    (6, 6),  -- Animated
    (6, 7);  -- Classic

INSERT INTO achievements (achievement_name, achievement_description, icon_url) VALUES
    ('Amateur Author', 'Created your first quiz!', 'icons/amateur_author.png'),
    ('Prolific Author', 'Created 5 quizzes!', 'icons/prolific_author.png'),
    ('Quiz Machine', 'Taken 10 quizzes!', 'icons/quiz_machine.png'),
    ('Practice Makes Perfect', 'Completed 3 practice quizzes!', 'icons/practice.png');

-- Nestor (user_id=1)
INSERT INTO user_achievements (user_id, achievement_id) VALUES
    (1, 1), -- Amateur Author
    (1, 3); -- Quiz Machine

-- Sandro (user_id=2)
INSERT INTO user_achievements (user_id, achievement_id) VALUES
    (2, 1); -- Amateur Author

-- Saba (user_id=3)
INSERT INTO user_achievements (user_id, achievement_id) VALUES
    (3, 1), -- Amateur Author
    (3, 4); -- Practice Makes Perfect

-- Giorgi (user_id=4)
INSERT INTO user_achievements (user_id, achievement_id) VALUES
    (4, 1); -- Amateur Author

INSERT INTO friend_requests (sender_id, receiver_id, status)
VALUES
    (1, 2, 'pending'),
    (2, 3, 'accepted'),
    (3, 4, 'rejected'),
    (4, 1, 'pending');

INSERT INTO friendships (user_id1, user_id2)
VALUES
    (1, 2),
    (2, 3),
    (3, 4),
    (1, 3);

