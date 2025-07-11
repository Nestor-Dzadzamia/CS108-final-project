package Servlets;

import DAO.AchievementDao;
import DAO.QuizDao;
import DAO.UserDao;
import Models.Achievement;
import Models.Quiz;
import Models.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/user")
public class UserPageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDao userDao = new UserDao();
        User user;
        try {
            // Always fetch latest user data from DB for fresh stats!
            user = userDao.getUserById(sessionUser.getId());
            request.getSession().setAttribute("user", user); // keep session in sync
            request.setAttribute("user", user);

            QuizDao quizDao = new QuizDao();
            List<Quiz> myQuizzes = quizDao.getQuizzesByUser(user.getId());
            request.setAttribute("myQuizzes", myQuizzes);

            AchievementDao achievementDao = new AchievementDao();
            List<Achievement> allAchievements = achievementDao.getAllAchievements();
            request.setAttribute("allAchievements", allAchievements);

            List<Achievement> userAchievements = achievementDao.getAchievementsByUserId(user.getId());
            request.setAttribute("userAchievements", userAchievements);

            Set<Long> earnedIds = new HashSet<>();
            for (Achievement a : userAchievements) {
                earnedIds.add(a.getAchievementId());
            }
            request.setAttribute("earnedIds", earnedIds);

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("user.jsp").forward(request, response);
    }
}
