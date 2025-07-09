package Servlets;

import DAO.AnnouncementDao;
import DAO.QuizDao;
import DAO.UserDao;
import Models.Announcement;
import Models.Quiz;
import Models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Security: Only allow admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Load announcements and quizzes
        AnnouncementDao announcementDao = new AnnouncementDao();
        QuizDao quizDao = new QuizDao();
        UserDao userDao = new UserDao();

        try {
            List<Announcement> announcements = announcementDao.getAllAnnouncements();
            List<Quiz> quizzes = quizDao.getAllQuizzes();
            request.setAttribute("announcements", announcements);
            request.setAttribute("quizzes", quizzes);
        } catch (SQLException e) {
            request.setAttribute("error", "Error loading announcements or quizzes.");
        }

        // User search
        String searchUsername = request.getParameter("searchUsername");
        if (searchUsername != null && !searchUsername.trim().isEmpty()) {
            try {
                List<User> foundUsers = userDao.searchUsers(searchUsername.trim(), 0L);
                if (foundUsers.isEmpty()) {
                    request.setAttribute("userSearchError", "No users found.");
                }
                request.setAttribute("foundUsers", foundUsers);
            } catch (SQLException e) {
                request.setAttribute("userSearchError", "Error during user search.");
            }
        }

        // Success/error message
        String error = (String) request.getSession().getAttribute("error");
        String success = (String) request.getSession().getAttribute("success");
        if (error != null) {
            request.setAttribute("error", error);
            request.getSession().removeAttribute("error");
        }
        if (success != null) {
            request.setAttribute("success", success);
            request.getSession().removeAttribute("success");
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Security: Only allow admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        AnnouncementDao announcementDao = new AnnouncementDao();
        QuizDao quizDao = new QuizDao();
        UserDao userDao = new UserDao();

        try {
            switch (action) {
                case "add-announcement": {
                    String title = request.getParameter("title");
                    String message = request.getParameter("message");
                    if (title != null && message != null && !title.isEmpty() && !message.isEmpty()) {
                        announcementDao.addAnnouncement(title, message, user.getId());
                        session.setAttribute("success", "Announcement added.");
                    } else {
                        session.setAttribute("error", "Title and message required.");
                    }
                    break;
                }
                case "remove-announcement": {
                    long id = Long.parseLong(request.getParameter("id"));
                    announcementDao.removeAnnouncement(id);
                    session.setAttribute("success", "Announcement removed.");
                    break;
                }
                case "remove-quiz": {
                    long id = Long.parseLong(request.getParameter("id"));
                    quizDao.deleteQuiz(id);
                    session.setAttribute("success", "Quiz removed.");
                    break;
                }
                case "remove-user": {
                    long id = Long.parseLong(request.getParameter("id"));
                    userDao.removeUser(id);
                    session.setAttribute("success", "User removed.");
                    break;
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Action failed: " + e.getMessage());
        }
        response.sendRedirect("admin");
    }
}
