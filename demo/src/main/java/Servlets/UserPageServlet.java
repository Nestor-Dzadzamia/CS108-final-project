package Servlets;

import Models.Quiz;
import Models.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/user")
public class UserPageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get logged-in user from session
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        QuizDao quizDao = new QuizDao();
        List<Quiz> myQuizzes = null;
        try {
            myQuizzes = quizDao.getQuizzesByUser(user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        request.setAttribute("myQuizzes", myQuizzes);
        request.getRequestDispatcher("user.jsp").forward(request, response);
    }
}
