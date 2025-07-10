-- Enhanced Mock Data for Quiz Application - COMPLETE VERSION

-- Clear existing data first to avoid duplicates
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE user_answers;
TRUNCATE TABLE submissions;
TRUNCATE TABLE messages;
TRUNCATE TABLE friendships;
TRUNCATE TABLE friend_requests;
TRUNCATE TABLE user_achievements;
TRUNCATE TABLE quiz_tags;
TRUNCATE TABLE possible_answers;
TRUNCATE TABLE correct_answers;
TRUNCATE TABLE questions;
TRUNCATE TABLE quizzes;
TRUNCATE TABLE achievements;
TRUNCATE TABLE tags;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

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
   ('General Knowledge Mix', 'Test your knowledge across various topics - order doesn\'t matter!', 5, FALSE, FALSE, TRUE, TRUE, 1, 20);

-- QUESTIONS

-- Guess Georgian athletes (quiz_id = 1)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (1, 'multiple-choice', 'Which Georgian wrestler won Olympic gold in 2012?', NULL, 60, 1),
     (1, 'question-response', 'What sport is Nino Salukvadze famous for?', NULL, 60, 2),
     (1, 'picture-response', 'Which Georgian athlete is shown in this image?', 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Mamuka_Gorgodze.jpg', 60, 3),
     (1, 'fill-blank', 'Kakha _ is a famous Georgian footballer who played for Dinamo Tbilisi.', NULL, 60, 4),
     (1, 'multiple-multiple-choice', 'Select all Georgian sports where the country has won Olympic medals.', NULL, 60, 5),
     (1, 'multi-answer', 'Name three Georgian rugby players who played internationally.', NULL, 60, 6);

-- History of Georgia (quiz_id = 2)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (2, 'question-response', 'Who was the first king of unified Georgia?', NULL, 90, 1),
     (2, 'multiple-choice', 'In which year did Georgia regain independence from the Soviet Union?', NULL, 90, 2),
     (2, 'fill-blank', 'Queen _ ruled Georgia during its Golden Age in the 12th-13th centuries.', NULL, 90, 3),
     (2, 'matching', 'Match each historical period to its corresponding ruler.', NULL, 90, 4),
     (2, 'picture-response', 'Which historical Georgian monument is shown in this image?', 'https://upload.wikimedia.org/wikipedia/commons/6/61/Svetitskhoveli_Cathedral_in_Georgia%2C_Europe.jpg', 90, 5),
     (2, 'multi-answer', 'Name the three main regions that formed historical Georgia.', NULL, 90, 6);

-- Math Genius (quiz_id = 3)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (3, 'question-response', 'What is the square root of 144?', NULL, 60, 1),
     (3, 'multiple-choice', 'What is 15% of 200?', NULL, 60, 2),
     (3, 'fill-blank', 'The value of π is approximately _.', NULL, 60, 3),
     (3, 'question-response', 'Solve: 2x + 5 = 15. What is x?', NULL, 60, 4),
     (3, 'multiple-choice', 'What is the area of a circle with radius 3?', NULL, 60, 5),
     (3, 'multi-answer', 'List three prime numbers between 10 and 20.', NULL, 60, 6);

-- Biology Facts (quiz_id = 4)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (4, 'multiple-choice', 'What is the powerhouse of the cell?', NULL, 60, 1),
     (4, 'question-response', 'What gas do plants absorb during photosynthesis?', NULL, 60, 2),
     (4, 'fill-blank', 'DNA stands for _ acid.', NULL, 60, 3),
     (4, 'multiple-multiple-choice', 'Select all parts of a plant cell.', NULL, 60, 4),
     (4, 'picture-response', 'What type of animal is shown in this image?', 'https://upload.wikimedia.org/wikipedia/commons/1/10/Tursiops_truncatus_01.jpg', 60, 5),
     (4, 'matching', 'Match each organ system to its primary function.', NULL, 60, 6);

-- Music Legends (quiz_id = 5)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (5, 'question-response', 'Which band released the album "Abbey Road"?', NULL, 60, 1),
     (5, 'multiple-choice', 'Who composed "The Four Seasons"?', NULL, 60, 2),
     (5, 'fill-blank', 'Elvis Presley was known as the "King of _".', NULL, 60, 3),
     (5, 'picture-response', 'Which famous musician is shown in this image?', 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Mozart_Portrait_Croce.jpg', 60, 4),
     (5, 'multiple-multiple-choice', 'Select all instruments that are part of a standard rock band.', NULL, 60, 5),
     (5, 'multi-answer', 'Name three famous female singers from the 1980s.', NULL, 60, 6);

-- Famous Movies (quiz_id = 6)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (6, 'multiple-choice', 'Who directed the movie "Titanic"?', NULL, 60, 1),
     (6, 'question-response', 'In which movie does the quote "May the Force be with you" appear?', NULL, 60, 2),
     (6, 'fill-blank', '"Here\'s looking at you, _" is a famous quote from Casablanca.', NULL, 60, 3),
     (6, 'picture-response', 'Which movie poster is shown in this image?', 'https://cdn.britannica.com/55/188355-050-D5E49258/Salvatore-Corsitto-The-Godfather-Marlon-Brando-Francis.jpg', 60, 4),
     (6, 'matching', 'Match each movie to its main actor.', NULL, 60, 5),
     (6, 'multiple-multiple-choice', 'Select all movies that won the Academy Award for Best Picture in the 1990s.', NULL, 60, 6);

-- Programming Fundamentals (quiz_id = 7)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (7, 'fill-blank', 'Python is a _ programming language known for its simplicity.', NULL, 60, 1),
     (7, 'question-response', 'What does HTML stand for?', NULL, 60, 2),
     (7, 'multiple-choice', 'Which of these is NOT a programming language?', NULL, 60, 3),
     (7, 'picture-response', 'Identify the programming language logo shown in the image.', 'https://upload.wikimedia.org/wikipedia/commons/c/c3/Python-logo-notext.svg', 60, 4),
     (7, 'multi-answer', 'List three popular web development frameworks.', NULL, 60, 5),
     (7, 'multiple-multiple-choice', 'Select all object-oriented programming languages.', NULL, 60, 6);

-- Tech Giants & Innovation (quiz_id = 8)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (8, 'matching', 'Match each tech company to its founder.', NULL, 90, 1),
     (8, 'multi-answer', 'Name the first three versions of the iPhone operating system.', NULL, 90, 2),
     (8, 'multiple-choice', 'Which company developed the first commercial microprocessor?', NULL, 90, 3),
     (8, 'picture-response', 'Which tech company logo is shown in this image?', 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg', 90, 4),
     (8, 'question-response', 'What year was Google founded?', NULL, 90, 5),
     (8, 'fill-blank', 'The World Wide Web was invented by _ at CERN.', NULL, 90, 6);

-- World Literature Classics (quiz_id = 9)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (9, 'matching', 'Match each classic novel to its author.', NULL, 120, 1),
     (9, 'question-response', 'In which Shakespeare play does the character Hamlet appear?', NULL, 120, 2),
     (9, 'multiple-choice', 'Which novel begins with "It was the best of times, it was the worst of times"?', NULL, 120, 3),
     (9, 'picture-response', 'Who is the author shown in this portrait?', 'https://upload.wikimedia.org/wikipedia/commons/a/aa/Dickens_Gurney_head.jpg', 120, 4),
     (9, 'fill-blank', 'George Orwell wrote the dystopian novel "_" published in 1949.', NULL, 120, 5),
     (9, 'multiple-multiple-choice', 'Select all novels written by Jane Austen.', NULL, 120, 6);

-- Modern Poetry & Authors (quiz_id = 10)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (10, 'question-response', 'Who wrote the poem "The Road Not Taken"?', NULL, 90, 1),
     (10, 'fill-blank', 'Maya Angelou is famous for her autobiography "I Know Why the _ Bird Sings".', NULL, 90, 2),
     (10, 'multiple-choice', 'Which poet is known as the "Bard of Avon"?', NULL, 90, 3),
     (10, 'matching', 'Match each poet to their most famous work.', NULL, 90, 4),
     (10, 'multi-answer', 'Name three Beat Generation poets.', NULL, 90, 5),
     (10, 'picture-response', 'Which famous poet is shown in this photograph?', 'https://upload.wikimedia.org/wikipedia/commons/c/ca/Langston_Hughes_by_Carl_Van_Vechten_%28cropped%29.jpg', 90, 6);

-- General Knowledge Mix (quiz_id = 11)
INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) VALUES
     (11, 'multi-answer', 'Name 8 planets in our solar system.', NULL, 90, 1),
     (11, 'multi-answer', 'List 10 programming languages you know.', NULL, 90, 2),
     (11, 'multi-answer', 'Name 15 European countries.', NULL, 90, 3),
     (11, 'multi-answer', 'List 8 colors of the rainbow.', NULL, 90, 4),
     (11, 'multi-answer', 'Name 12 types of cuisine.', NULL, 90, 5),
     (11, 'question-response', 'What is the capital of France?', NULL, 90, 6);

-- CORRECT ANSWERS

-- Guess Georgian athletes (questions 1-6)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q1: Multiple choice
    (1, 'Vladimer Khinchegashvili', -1),
    -- Q2: Question response
    (2, 'Shooting', -1),
    (2, 'Pistol shooting', -1),
    -- Q3: Picture response
    (3, 'Mamuka Gorgodze', -1),
    (3, 'Gorgodze', -1),
    -- Q4: Fill in the blank
    (4, 'Kaladze', -1),
    -- Q5: Multi-select
    (5, 'Wrestling', -1),
    (5, 'Shooting', -1),
    (5, 'Weightlifting', -1),
    (5, 'Boxing', -1),
    -- Q6: Multi-answer
    (6, 'Mamuka Gorgodze', 1),
    (6, 'Merab Kvirikashvili', 2),
    (6, 'Giorgi Chkhaidze', 3);

-- History of Georgia (questions 7-12)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q7: Question response
    (7, 'Bagrat III', -1),
    (7, 'King Bagrat III', -1),
    -- Q8: Multiple choice
    (8, '1991', -1),
    -- Q9: Fill in the blank
    (9, 'Tamar', -1),
    (9, 'Queen Tamar', -1),
    -- Q10: Matching
    (10, 'Golden Age-Queen Tamar', -1),
    (10, 'Unification-Bagrat III', -1),
    (10, 'Soviet Period-Eduard Shevardnadze', -1),
    -- Q11: Picture response
    (11, 'Svetitskhoveli Cathedral', -1),
    (11, 'Svetitskhoveli', -1),
    -- Q12: Multi-answer
    (12, 'Kartli', 1),
    (12, 'Kakheti', 2),
    (12, 'Samtskhe', 3);

-- Math Genius (questions 13-18)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q13: Question response
    (13, '12', -1),
    -- Q14: Multiple choice
    (14, '30', -1),
    -- Q15: Fill in the blank
    (15, '3.14', -1),
    (15, '3.141', -1),
    (15, '3.1415', -1),
    -- Q16: Question response
    (16, '5', -1),
    -- Q17: Multiple choice
    (17, '9pi', -1),
    (17, '28.27', -1),
    -- Q18: Multi-answer
    (18, '11', 1),
    (18, '13', 2),
    (18, '17', 3),
    (18, '19', 4);

-- Biology Facts (questions 19-24)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q19: Multiple choice
    (19, 'Mitochondria', -1),
    -- Q20: Question response
    (20, 'Carbon dioxide', -1),
    (20, 'CO2', -1),
    -- Q21: Fill in the blank
    (21, 'Deoxyribonucleic', -1),
    -- Q22: Multi-select
    (22, 'Cell wall', -1),
    (22, 'Chloroplasts', -1),
    (22, 'Vacuole', -1),
    (22, 'Nucleus', -1),
    -- Q23: Picture response
    (23, 'Dolphin', -1),
    (23, 'Mammal', -1),
    -- Q24: Matching
    (24, 'Circulatory System-Transport blood', -1),
    (24, 'Respiratory System-Exchange gases', -1),
    (24, 'Digestive System-Process food', -1);

-- Music Legends (questions 25-30)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q25: Question response
    (25, 'The Beatles', -1),
    (25, 'Beatles', -1),
    -- Q26: Multiple choice
    (26, 'Antonio Vivaldi', -1),
    -- Q27: Fill in the blank
    (27, 'Rock and Roll', -1),
    (27, 'Rock', -1),
    -- Q28: Picture response
    (28, 'Mozart', -1),
    (28, 'Wolfgang Amadeus Mozart', -1),
    -- Q29: Multi-select
    (29, 'Guitar', -1),
    (29, 'Bass', -1),
    (29, 'Drums', -1),
    (29, 'Microphone', -1),
    -- Q30: Multi-answer
    (30, 'Madonna', 1),
    (30, 'Whitney Houston', 2),
    (30, 'Cyndi Lauper', 3);

-- Famous Movies (questions 31-36)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q31: Multiple choice
    (31, 'James Cameron', -1),
    -- Q32: Question response
    (32, 'Star Wars', -1),
    -- Q33: Fill in the blank
    (33, 'kid', -1),
    -- Q34: Picture response
    (34, 'The Godfather', -1),
    (34, 'Godfather', -1),
    -- Q35: Matching
    (35, 'The Godfather-Marlon Brando', -1),
    (35, 'Titanic-Leonardo DiCaprio', -1),
    (35, 'Forrest Gump-Tom Hanks', -1),
    -- Q36: Multi-select
    (36, 'Forrest Gump', -1),
    (36, 'The Silence of the Lambs', -1),
    (36, 'Unforgiven', -1),
    (36, 'Schindler\'s List', -1);

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

-- General Knowledge Mix (questions 61-66)
INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES
    -- Q61: 8 planets (order doesn't matter)
    (61, 'Mercury', -1),
    (61, 'Venus', -1),
    (61, 'Earth', -1),
    (61, 'Mars', -1),
    (61, 'Jupiter', -1),
    (61, 'Saturn', -1),
    (61, 'Uranus', -1),
    (61, 'Neptune', -1),

    -- Q62: 10 programming languages (order doesn't matter)
    (62, 'JavaScript', -1),
    (62, 'Python', -1),
    (62, 'Java', -1),
    (62, 'C++', -1),
    (62, 'C#', -1),
    (62, 'PHP', -1),
    (62, 'Ruby', -1),
    (62, 'Go', -1),
    (62, 'Swift', -1),
    (62, 'Kotlin', -1),

    -- Q63: 15 European countries (order doesn't matter)
    (63, 'France', -1),
    (63, 'Germany', -1),
    (63, 'Italy', -1),
    (63, 'Spain', -1),
    (63, 'United Kingdom', -1),
    (63, 'Netherlands', -1),
    (63, 'Belgium', -1),
    (63, 'Switzerland', -1),
    (63, 'Austria', -1),
    (63, 'Poland', -1),
    (63, 'Greece', -1),
    (63, 'Portugal', -1),
    (63, 'Sweden', -1),
    (63, 'Norway', -1),
    (63, 'Denmark', -1),

    -- Q64: 8 colors of the rainbow (order doesn't matter)
    (64, 'Red', -1),
    (64, 'Orange', -1),
    (64, 'Yellow', -1),
    (64, 'Green', -1),
    (64, 'Blue', -1),
    (64, 'Indigo', -1),
    (64, 'Violet', -1),
    (64, 'Purple', -1),

    -- Q65: 12 types of cuisine (order doesn't matter)
    (65, 'Italian', -1),
    (65, 'Chinese', -1),
    (65, 'Mexican', -1),
    (65, 'Indian', -1),
    (65, 'French', -1),
    (65, 'Japanese', -1),
    (65, 'Thai', -1),
    (65, 'Greek', -1),
    (65, 'Spanish', -1),
    (65, 'Korean', -1),
    (65, 'Vietnamese', -1),
    (65, 'Lebanese', -1),

    -- Q66: Simple question-response
    (66, 'Paris', -1);

-- POSSIBLE ANSWERS for multiple choice questions

-- Guess Georgian athletes Q1
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (1, 'Vladimer Khinchegashvili'),
     (1, 'Lasha Talakhadze'),
     (1, 'Geno Petriashvili'),
     (1, 'Levan Tediashvili');

-- History of Georgia Q8
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (8, '1989'),
     (8, '1990'),
     (8, '1991'),
     (8, '1992');

-- Math Genius Q14
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (14, '25'),
     (14, '30'),
     (14, '35'),
     (14, '40');

-- Math Genius Q17
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (17, '9pi'),
     (17, '6pi'),
     (17, '3pi'),
     (17, '12pi');

-- Biology Facts Q19
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (19, 'Nucleus'),
     (19, 'Mitochondria'),
     (19, 'Ribosome'),
     (19, 'Cytoplasm');

-- Music Legends Q26
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (26, 'Johann Sebastian Bach'),
     (26, 'Wolfgang Amadeus Mozart'),
     (26, 'Antonio Vivaldi'),
     (26, 'Ludwig van Beethoven');

-- Famous Movies Q31
INSERT INTO possible_answers (question_id, possible_answer_text) VALUES
     (31, 'Steven Spielberg'),
     (31, 'James Cameron'),
     (31, 'Martin Scorsese'),
     (31, 'Christopher Nolan');

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
    ('Interactive'),
    ('Georgian Culture'),
    ('Mathematics'),
    ('Life Sciences'),
    ('Entertainment'),
    ('Cinema');

-- QUIZ TAGS
INSERT INTO quiz_tags (quiz_id, tag_id) VALUES
    -- Guess Georgian athletes
    (1, 1), (1, 8), (1, 21),
    -- History of Georgia
    (2, 2), (2, 21), (2, 19),
    -- Math Genius
    (3, 22), (3, 3), (3, 10),
    -- Biology Facts
    (4, 23), (4, 4), (4, 19),
    -- Music Legends
    (5, 7), (5, 5), (5, 24),
    -- Famous Movies
    (6, 25), (6, 24), (6, 7),
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
      (5, 7, 6, 6, 100, 380), -- Alex: Programming quiz (perfect score)
      (5, 8, 5, 6, 83, 450),  -- Alex: Tech Giants quiz
      (6, 9, 5, 6, 83, 720),  -- Maria: Literature quiz
      (6, 10, 4, 6, 67, 610), -- Maria: Poetry quiz
      (1, 1, 5, 6, 83, 450),  -- Nestor: Georgian athletes
      (2, 2, 4, 6, 67, 620),  -- Sandro: Georgian history
      (3, 3, 6, 6, 100, 380), -- Saba: Math quiz (perfect score)
      (4, 4, 5, 6, 83, 520),  -- Giorgi: Biology quiz
      (1, 5, 4, 6, 67, 480),  -- Nestor: Music quiz
      (2, 6, 5, 6, 83, 560);  -- Sandro: Movies quiz

-- SAMPLE USER ANSWERS
INSERT INTO user_answers (submission_id, question_id, answer_text, is_correct) VALUES
   -- Nestor's Programming quiz answers
   (1, 37, 'high-level', TRUE),
   (1, 38, 'HyperText Markup Language', TRUE),
   (1, 39, 'Java', FALSE),
   (1, 40, 'Python', TRUE),
   (1, 41, 'React, Django, Vue.js', TRUE),
   (1, 42, 'Java,Python,C++', FALSE),

   -- Nestor's Georgian athletes quiz answers
   (7, 1, 'Vladimer Khinchegashvili', TRUE),
   (7, 2, 'Shooting', TRUE),
   (7, 3, 'Gorgodze', TRUE),
   (7, 4, 'Kaladze', TRUE),
   (7, 5, 'Wrestling,Boxing,Weightlifting', TRUE),
   (7, 6, 'Mamuka Gorgodze, Giorgi Nemsadze', FALSE),

   -- Saba's Math quiz answers (perfect score)
   (9, 13, '12', TRUE),
   (9, 14, '30', TRUE),
   (9, 15, '3.14', TRUE),
   (9, 16, '5', TRUE),
   (9, 17, '9pi', TRUE),
   (9, 18, '11, 13, 17', TRUE);

-- MESSAGES
INSERT INTO messages (sender_id, receiver_id, message_type, content, quiz_id, is_read) VALUES
   (1, 2, 'challenge', 'challenged you to take "Programming Fundamentals"! My best score: 83', 7, FALSE),
   (5, 1, 'note', 'Great job on the programming quiz! You really know your stuff.', NULL, TRUE),
   (6, 3, 'challenge', 'challenged you to take "World Literature Classics"! My best score: 83', 9, FALSE),
   (7, 8, 'note', 'Hey Emma, hope you are doing well!', NULL, TRUE),
   (8, 7, 'note', 'Thanks for checking in! Hope to see you soon.', NULL, TRUE),
   (3, 1, 'challenge', 'challenged you to take "Math Genius"! My best score: 100', 3, FALSE),
   (2, 4, 'challenge', 'challenged you to take "History of Georgia"! My best score: 67', 2, FALSE),
   (1, 3, 'note', 'Wow, perfect score on the math quiz! Impressive!', NULL, TRUE);