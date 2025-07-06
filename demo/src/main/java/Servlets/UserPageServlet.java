package Servlets;

import DAO.AchievementDao;
import DAO.QuizDao;
import Models.Achievement;
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
        AchievementDao achievementDao = new AchievementDao();

        try {
            List<Quiz> myQuizzes = quizDao.getQuizzesByUser(user.getId());
            request.setAttribute("myQuizzes", myQuizzes);

            // Assuming you want to show user's earned achievements (with awardedAt)
            // You need a DAO method to get user achievements with awardedAt; here a simplified version:
            List<Achievement> userAchievements = getUserAchievements(user.getId());
            request.setAttribute("userAchievements", userAchievements);

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("user.jsp").forward(request, response);
    }

    // Helper method to get user achievements with awardedAt timestamp
    private List<Achievement> getUserAchievements(long userId) throws SQLException {
        // For simplicity, query user_achievements JOIN achievements here:

        List<Achievement> achievements = new java.util.ArrayList<>();

        String sql = "SELECT a.achievement_id, a.achievement_name, a.achievement_description, a.icon_url, ua.awarded_at " +
                "FROM user_achievements ua " +
                "JOIN achievements a ON ua.achievement_id = a.achievement_id " +
                "WHERE ua.user_id = ?";

        try (java.sql.Connection conn = DB.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            try (java.sql.ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    achievements.add(new Achievement(
                            rs.getLong("achievement_id"),
                            rs.getString("achievement_name"),
                            rs.getString("achievement_description"),
                            rs.getString("icon_url"),
                            rs.getTimestamp("awarded_at")
                    ));
                }
            }
        }

        return achievements;
    }
}
