package Servlets;

import DAO.*;
import Models.*;
import Models.Questions.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.*;

@WebServlet("/takeQuiz")
public class TakeQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String quizIdParam = request.getParameter("quizId");
        String pageParam = request.getParameter("page");

        if (quizIdParam == null || quizIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Quiz ID is required.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        try {
            long quizId = Long.parseLong(quizIdParam);
            int currentPage = 1;

            if (pageParam != null && !pageParam.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }

            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.getQuizById(quizId);

            if (quiz == null) {
                request.setAttribute("error", "Quiz not found.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Get questions for the quiz
            QuestionDao questionDao = new QuestionDao();
            List<Question> questions = questionDao.getQuestionsByQuizId(quizId, quiz.isRandomized());

            if (questions.isEmpty()) {
                request.setAttribute("error", "This quiz has no questions.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Get possible answers and correct answers for each question
            PossibleAnswerDao possibleAnswerDao = new PossibleAnswerDao();
            CorrectAnswerDao correctAnswerDao = new CorrectAnswerDao();

            Map<Long, List<PossibleAnswer>> possibleAnswersMap = new HashMap<>();
            Map<Long, List<CorrectAnswer>> correctAnswersMap = new HashMap<>();

            for (Question question : questions) {
                List<PossibleAnswer> possibleAnswers = possibleAnswerDao.getPossibleAnswersByQuestion(question.getId());
                List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(question.getId());

                possibleAnswersMap.put((long) question.getId(), possibleAnswers);
                correctAnswersMap.put((long) question.getId(), correctAnswers);
            }

            // Initialize or retrieve quiz session data
            String sessionKey = "quiz_" + quizId + "_data";
            Map<String, Object> quizSessionData = (Map<String, Object>) request.getSession().getAttribute(sessionKey);

            if (quizSessionData == null) {
                quizSessionData = new HashMap<>();
                quizSessionData.put("startTime", System.currentTimeMillis());
                quizSessionData.put("userAnswers", new HashMap<String, String>());
                quizSessionData.put("questionsOrder", questions);
                request.getSession().setAttribute(sessionKey, quizSessionData);
            }

            // For multi-page quizzes, determine questions for current page
            List<Question> currentPageQuestions = questions;
            int totalPages = 1;

            if (quiz.isMultiplePage()) {
                int questionsPerPage = 1; // One question per page for multi-page mode
                totalPages = questions.size();

                if (currentPage < 1) currentPage = 1;
                if (currentPage > totalPages) currentPage = totalPages;

                int startIndex = (currentPage - 1) * questionsPerPage;
                int endIndex = Math.min(startIndex + questionsPerPage, questions.size());
                currentPageQuestions = questions.subList(startIndex, endIndex);
            }

            // Set attributes for JSP
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", currentPageQuestions);
            request.setAttribute("allQuestions", questions);
            request.setAttribute("possibleAnswersMap", possibleAnswersMap);
            request.setAttribute("correctAnswersMap", correctAnswersMap);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("userAnswers", quizSessionData.get("userAnswers"));

            // Forward to quiz taking page
            request.getRequestDispatcher("takeQuiz.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid parameters.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String quizIdParam = request.getParameter("quizId");
        String action = request.getParameter("action");

        if (quizIdParam == null || quizIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Quiz ID is required.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        try {
            long quizId = Long.parseLong(quizIdParam);
            String sessionKey = "quiz_" + quizId + "_data";
            Map<String, Object> quizSessionData = (Map<String, Object>) request.getSession().getAttribute(sessionKey);

            if (quizSessionData == null) {
                response.sendRedirect("takeQuiz?quizId=" + quizId);
                return;
            }

            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.getQuizById(quizId);

            // Save current page answers to session
            Map<String, String> userAnswers = (Map<String, String>) quizSessionData.get("userAnswers");
            saveCurrentPageAnswers(request, userAnswers);
            quizSessionData.put("userAnswers", userAnswers);

            // Handle different actions
            if ("next".equals(action) || "previous".equals(action)) {
                // Navigate between pages
                String pageParam = request.getParameter("page");
                int currentPage = pageParam != null ? Integer.parseInt(pageParam) : 1;

                if ("next".equals(action)) {
                    currentPage++;
                } else {
                    currentPage--;
                }

                response.sendRedirect("takeQuiz?quizId=" + quizId + "&page=" + currentPage);
                return;

            } else if ("submit".equals(action)) {
                // Submit the entire quiz
                processQuizSubmission(request, response, quiz, quizSessionData, user);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid parameters.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    private void saveCurrentPageAnswers(HttpServletRequest request, Map<String, String> userAnswers) {
        Enumeration<String> paramNames = request.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();

            if (paramName.startsWith("question_")) {
                String[] values = request.getParameterValues(paramName);

                if (values != null && values.length > 0) {
                    // Handle multiple values (checkboxes, matching)
                    if (values.length == 1) {
                        userAnswers.put(paramName, values[0]);
                    } else {
                        userAnswers.put(paramName, String.join(";", values));
                    }
                }
            }
        }
    }

    private void processQuizSubmission(HttpServletRequest request, HttpServletResponse response,
                                       Quiz quiz, Map<String, Object> quizSessionData, User user)
            throws SQLException, IOException {

        // Calculate time spent
        Long startTime = (Long) quizSessionData.get("startTime");
        long timeSpent = startTime != null ? (System.currentTimeMillis() - startTime) / 1000 : 0;

        // Get all questions
        List<Question> questions = (List<Question>) quizSessionData.get("questionsOrder");
        Map<String, String> userAnswers = (Map<String, String>) quizSessionData.get("userAnswers");

        // Get correct answers for validation
        CorrectAnswerDao correctAnswerDao = new CorrectAnswerDao();
        Map<Long, List<CorrectAnswer>> correctAnswersMap = new HashMap<>();

        for (Question question : questions) {
            List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(question.getId());
            correctAnswersMap.put((long) question.getId(), correctAnswers);
        }

        // Process user answers and calculate score with partial credit
        List<UserAnswer> userAnswersList = new ArrayList<>();
        double totalScore = 0.0;
        int totalQuestions = questions.size();

        for (Question question : questions) {
            String userAnswerText = userAnswers.get("question_" + question.getId());
            if (userAnswerText == null) userAnswerText = "";

            double questionScore = calculateQuestionScore(question, userAnswerText,
                    correctAnswersMap.get((long) question.getId()));
            totalScore += questionScore;

            // Create UserAnswer object
            UserAnswer userAnswer = new UserAnswer();
            userAnswer.setQuestionId(question.getId());
            userAnswer.setAnswerText(userAnswerText);
            userAnswer.setCorrect(questionScore >= 1.0); // Full credit = correct
            userAnswersList.add(userAnswer);
        }

        // Calculate final score as percentage
        double correctCount = totalScore;
        long finalScore = totalQuestions > 0 ? Math.round((totalScore / totalQuestions) * 100) : 0;

        // Create and save submission
        Submission submission = new Submission();
        submission.setUserId(user.getId());
        submission.setQuizId(quiz.getQuizId());
        submission.setNumCorrectAnswers(Math.round((float) correctCount));
        submission.setNumTotalAnswers(totalQuestions);
        submission.setScore(finalScore);
        submission.setTimeSpent(timeSpent);
        submission.setSubmittedAt(new Timestamp(System.currentTimeMillis()));

        SubmissionDao submissionDao = new SubmissionDao();
        submission = submissionDao.createSubmission(submission);

        // Save user answers
        UserAnswerDao userAnswerDao = new UserAnswerDao();
        for (UserAnswer userAnswer : userAnswersList) {
            userAnswer.setSubmissionId(submission.getSubmissionId());
            userAnswerDao.createUserAnswer(userAnswer);
        }

        // Clear quiz session data
        String sessionKey = "quiz_" + quiz.getQuizId() + "_data";
        request.getSession().removeAttribute(sessionKey);

        // Redirect to results page
        response.sendRedirect("quizResults?submissionId=" + submission.getSubmissionId());
    }

    private double calculateQuestionScore(Question question, String userAnswer, List<CorrectAnswer> correctAnswers) {
        if (userAnswer == null || userAnswer.trim().isEmpty() || correctAnswers == null || correctAnswers.isEmpty()) {
            return 0.0;
        }

        userAnswer = userAnswer.trim();

        // Use the question's built-in scoring methods where possible
        if (question instanceof MultipleChoiceAnswer) {
            MultipleChoiceAnswer mcq = (MultipleChoiceAnswer) question;
            try {
                // Find the index of the selected answer (1-based)
                String correctAnswer = mcq.getCorrectAnswer();
                return correctAnswer.equalsIgnoreCase(userAnswer) ? 1.0 : 0.0;
            } catch (Exception e) {
                return 0.0;
            }
        } else if (question instanceof QuestionResponse) {
            QuestionResponse qr = (QuestionResponse) question;
            return qr.getScore(userAnswer);
        } else if (question instanceof PictureResponse) {
            PictureResponse pr = (PictureResponse) question;
            return pr.getScore(userAnswer);
        } else if (question instanceof FillInTheBlank) {
            FillInTheBlank fib = (FillInTheBlank) question;
            return fib.getScore(userAnswer);
        } else if (question instanceof MatchingQuestion) {
            MatchingQuestion mq = (MatchingQuestion) question;
            // Parse user answer into map format
            Map<String, String> userMatches = new HashMap<>();
            String[] matches = userAnswer.split(";");
            for (String match : matches) {
                if (match.contains(" - ")) {
                    String[] parts = match.split(" - ", 2);
                    if (parts.length == 2) {
                        userMatches.put(parts[0].trim(), parts[1].trim());
                    }
                }
            }
            return mq.getScore(userMatches);
        } else if (question instanceof MultiSelectQuestion) {
            MultiSelectQuestion msq = (MultiSelectQuestion) question;
            // Parse user answer into set format
            Set<String> userSelections = new HashSet<>();
            String[] selections = userAnswer.split(";");
            for (String selection : selections) {
                if (!selection.trim().isEmpty()) {
                    userSelections.add(selection.trim());
                }
            }
            return msq.getScore(userSelections);
        } else if (question instanceof MultiAnswer) {
            MultiAnswer ma = (MultiAnswer) question;
            // Parse user answer into list format
            List<String> userAnswersList = new ArrayList<>();
            String[] answers = userAnswer.split(";");
            for (String ans : answers) {
                if (!ans.trim().isEmpty()) {
                    userAnswersList.add(ans.trim());
                }
            }
            return ma.getScoreMultiple(userAnswersList);
        } else {
            // Fallback: compare with correct answers directly
            for (CorrectAnswer correct : correctAnswers) {
                if (correct.getAnswerText().trim().equalsIgnoreCase(userAnswer)) {
                    return 1.0;
                }
            }
            return 0.0;
        }
    }
}