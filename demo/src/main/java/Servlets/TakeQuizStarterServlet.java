package Servlets;

import DAO.AnswerDao;
import DAO.PossibleAnswerDao;
import DAO.QuestionDao;
import DAO.QuizDao;

import Models.Answer;
import Models.PossibleAnswer;
import Models.Questions.Question;
import Models.Quiz;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/take-quiz-starter")
public class TakeQuizStarterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String quizIdStr = req.getParameter("id");

        if (quizIdStr == null) {
            resp.sendRedirect("error.jsp?msg=Missing quiz ID");
            return;
        }

        long quizId;
        try {
            quizId = Long.parseLong(quizIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("error.jsp?msg=Invalid quiz ID");
            return;
        }

        try {
            QuizDao quizDao = new QuizDao();
            Quiz quiz = quizDao.getQuizById(quizId);

            if (quiz == null) {
                resp.sendRedirect("error.jsp?msg=Quiz not found");
                return;
            }

            QuestionDao questionDao = new QuestionDao();
            AnswerDao answerDao = new AnswerDao();
            PossibleAnswerDao possibleAnswerDao = new PossibleAnswerDao();

            List<Question> questions = questionDao.getQuestionsByQuizId(quizId);
            Map<Long, List<Answer>> correctAnswers = new HashMap<>();
            Map<Long, List<PossibleAnswer>> possibleAnswers = new HashMap<>();

            for (Question q : questions) {
                List<Answer> correct = answerDao.getCorrectAnswersByQuestionId(q.getQuestionId());
                //System.out.println(correct.size());
                correctAnswers.put(q.getQuestionId(), correct);

                if (q.getQuestionType().equals("multiple-choice") || q.getQuestionType().equals("multiple-multiple-choice")) {
                    List<PossibleAnswer> possible = possibleAnswerDao.getPossibleAnswersByQuestionId(q.getQuestionId());
                    possibleAnswers.put(q.getQuestionId(), possible);
                }
            }

            HttpSession session = req.getSession();
            // Store all retrieved data in the session
            //quiz.setTotalTimeLimit(1); for debugging
            session.setAttribute("quiz", quiz);
            session.setAttribute("questions", questions);
            session.setAttribute("correctAnswers", correctAnswers);
            session.setAttribute("possibleAnswers", possibleAnswers);

            //if user starts but does not submit quiz this boolean
            //tells us to renew timer
            boolean quizInProcess = true;
            session.setAttribute("quizInProcess", quizInProcess);

            Question currentQuestion = questions.get(0); //very first question for single page
            session.setAttribute("currentQuestion", currentQuestion);
            session.setAttribute("index", 0);

            //for simplier timer implementation
            Long quizStartTime = (Long) session.getAttribute("quizStartTime");
            Long remainingTime;
            if (quizStartTime == null || quizInProcess) {
                // First time loading this quiz - start the timer
                quizStartTime = System.currentTimeMillis();
                session.setAttribute("quizStartTime", quizStartTime);
                remainingTime = quiz.getTotalTimeLimit() * 60L;

            } else {
                // Quiz was already started (page refresh) - calculate remaining time
                long elapsedMillis = System.currentTimeMillis() - quizStartTime;
                long elapsedSeconds = elapsedMillis / 1000;
                long totalTimeSeconds = quiz.getTotalTimeLimit() * 60L;
                remainingTime = Math.max(0, totalTimeSeconds - elapsedSeconds);


            }
            session.setAttribute("remainingTime", remainingTime);

            //for saving answers from multiple page quiz
            Map<Long, List<String>> providedAnswers = new HashMap<>();
            session.setAttribute("providedAnswers", providedAnswers);

            // Forward to the appropriate JSP
            if (quiz.isMultiplePage()) {
                req.getRequestDispatcher("takeQuizMultiplePage.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("takeQuizSinglePage.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("error.jsp?msg=Database error: " + e.getMessage());
        }
    }
}