package Servlets;

import DAO.QuizDao;
import Models.Quiz;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/quiz-summary")
public class QuizSummaryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String quizIdStr = request.getParameter("quizId");
        if (quizIdStr == null) {
            request.setAttribute("errorMsg", "No quiz id provided.");
            request.getRequestDispatcher("quiz-summary.jsp").forward(request, response);
            return;
        }

        long quizId;
        try {
            quizId = Long.parseLong(quizIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Invalid quiz id.");
            request.getRequestDispatcher("quiz-summary.jsp").forward(request, response);
            return;
        }

        QuizDao quizDao = new QuizDao();

        try {
            Quiz quiz = quizDao.getQuizById(quizId);
            if (quiz == null) {
                request.setAttribute("errorMsg", "Quiz not found.");
            } else {
                int numQuestions = quizDao.getQuestionsCount(quizId);
                request.setAttribute("quiz", quiz);
                request.setAttribute("numQuestions", numQuestions);
            }
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Error loading quiz summary: " + e.getMessage());
        }

        request.getRequestDispatcher("quiz-summary.jsp").forward(request, response);
    }
}
