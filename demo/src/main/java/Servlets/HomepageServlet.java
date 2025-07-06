package Servlets;

import DAO.QuizDao;
import Models.Quiz;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class HomepageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        QuizDao quizDao = new QuizDao();
        try {
            List<Quiz> recentQuizzes = quizDao.getRecentQuizzes();
            request.setAttribute("recentQuizzes", recentQuizzes);

            request.getRequestDispatcher("homepage.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error loading quizzes", e);
        }
    }
}
