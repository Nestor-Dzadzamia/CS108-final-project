package Servlets;

import DAO.AnswerDao;
import DAO.QuestionDao;
import DAO.QuizDao;
import Models.Questions.Question;
import Models.Questions.QuestionSaver;
import Models.Quiz;
import Models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/save-quiz")
public class SaveQuizServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // Retrieve data from session with proper casting
        String title = (String) session.getAttribute("quiz_title");
        String description = (String) session.getAttribute("description");

        // Cast to wrapper objects, then unbox to primitive long
        long totalTime = ((Long) session.getAttribute("total_time_limit")).longValue();
        long categoryId = ((Long) session.getAttribute("quiz_category")).longValue();

        boolean randomized = ((Boolean) session.getAttribute("randomized")).booleanValue();
        boolean multiplePage = ((Boolean) session.getAttribute("is_multiple_page")).booleanValue();
        boolean immediateCorrection = ((Boolean) session.getAttribute("immediate_correction")).booleanValue();
        boolean allowPractice = ((Boolean) session.getAttribute("allow_practice")).booleanValue();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        long createdBy = user.getId();

        try {
            // Create a Quiz model and set values
            Quiz quiz = new Quiz();
            quiz.setQuizTitle(title);
            quiz.setDescription(description);
            quiz.setTotalTimeLimit(totalTime);
            quiz.setQuizCategory(categoryId);
            quiz.setRandomized(randomized);
            quiz.setMultiplePage(multiplePage);
            quiz.setImmediateCorrection(immediateCorrection);
            quiz.setAllowPractice(allowPractice);
            quiz.setCreatedBy(createdBy);

            // Save quiz using DAO
            QuizDao quizDao = new QuizDao();
            long quizId = quizDao.insertQuiz(quiz);

            // Retrieve question metadata from session
            Map<Integer, String> questionTypes = (Map<Integer, String>) session.getAttribute("question_types");
            Map<Integer, Integer> correctCounts = (Map<Integer, Integer>) session.getAttribute("correct_counts");
            Map<Integer, Integer> totalAnswersMap = (Map<Integer, Integer>) session.getAttribute("total_answers");

            QuestionDao questionDao = new QuestionDao();
            AnswerDao answerDao = new AnswerDao();

            for (Map.Entry<Integer, String> entry : questionTypes.entrySet()) {
                int index = entry.getKey();
                String type = entry.getValue();

                String questionText = req.getParameter("question_" + index + "_text");
                String imageUrl = req.getParameter("question_" + index + "_image");
                //String orderedFlag = req.getParameter("question_" + index + "_ordered");

                QuestionSaver question = new QuestionSaver();
                question.setQuizId(quizId);
                question.setQuestionType(type);
                question.setQuestionText(questionText);
                question.setImageUrl(imageUrl);
                question.setTimeLimit(0L);  // You can add this later
                question.setQuestionOrder(index);

                long questionId = questionDao.insertQuestion(question);

                // Handle correct answers
                switch (type) {
                    case "multi-answer" -> {
                        boolean isOrdered = "on".equals(req.getParameter("question_" + index + "_ordered"));
                        int count = correctCounts.getOrDefault(index, 1);
                        for (int i = 1; i <= count; i++) {
                            String ans = req.getParameter("question_" + index + "_answer_" + i);
                            if (ans != null && !ans.trim().isEmpty()) {
                                int order = isOrdered ? i : -1;
                                answerDao.insertCorrectAnswer(questionId, ans, order);
                            }
                        }

                    }
                    case "question-response", "fill-blank", "picture-response" -> {
                        int count = correctCounts.getOrDefault(index, 1);
                        for (int i = 1; i <= count; i++) {
                            String ans = req.getParameter("question_" + index + "_answer_" + i);
                            if (ans != null && !ans.trim().isEmpty()) {
                                answerDao.insertCorrectAnswer(questionId, ans, -1); // Always unordered
                            }
                        }
                    }
                    case "matching" -> {
                        int pairCount = correctCounts.getOrDefault(index, 1);
                        for (int i = 1; i <= pairCount; i++) {
                            String left = req.getParameter("question_" + index + "_match_left_" + i);
                            String right = req.getParameter("question_" + index + "_match_right_" + i);
                            if (left != null && right != null) {
                                answerDao.insertCorrectAnswer(questionId, left + "-" + right, -1);
                            }
                        }
                    }
                    case "multiple-choice" -> {
                        int optionCount = totalAnswersMap.getOrDefault(index, 4);
                        for (int i = 0; i < optionCount; i++) {
                            char label = (char) ('A' + i);
                            String optionText = req.getParameter("question_" + index + "_option_" + label);
                            if (optionText != null) {
                                answerDao.insertPossibleAnswer(questionId, optionText);
                            }

                            String correct = req.getParameter("question_" + index + "_correct_choice");
                            if (correct != null && correct.equals(String.valueOf(label))) {
                                answerDao.insertCorrectAnswer(questionId, optionText, -1);
                            }
                        }

                    }
                    case "multiple-multiple-choice" -> {
                        int optionCount = totalAnswersMap.getOrDefault(index, 4);
                        for (int i = 0; i < optionCount; i++) {
                            char label = (char) ('A' + i);
                            String optionText = req.getParameter("question_" + index + "_option_" + label);
                            if (optionText != null) {
                                answerDao.insertPossibleAnswer(questionId, optionText);
                            }

                            String correct = req.getParameter("question_" + index + "_correct_choice_" + label);
                            if (correct != null && correct.equals(String.valueOf(label))) {
                                answerDao.insertCorrectAnswer(questionId, optionText, -1);
                            }
                        }
                    }
                }
            }

            resp.sendRedirect("homepage.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error saving quiz: " + e.getMessage());
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }


    }
}

