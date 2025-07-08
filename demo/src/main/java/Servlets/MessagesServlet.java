package Servlets;

import DAO.MessageDao;
import DAO.QuizDao;
import DAO.UserDao;
import Models.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/message")
public class MessagesServlet extends HttpServlet {

    private MessageDao messageDao;
    private UserDao userDao;
    private QuizDao quizDao;

    @Override
    public void init() {
        messageDao = new MessageDao();
        userDao = new UserDao();
        quizDao = new QuizDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            List<Message> messages = messageDao.getMessagesForUser(currentUser.getId());
            List<User> friends = userDao.getFriends(currentUser.getId());
            List<Quiz> quizzes = quizDao.getAllQuizzes();

            int unreadCount = messageDao.getUnreadMessageCount(currentUser.getId());

            messageDao.markMessagesAsRead(currentUser.getId());

            request.setAttribute("messages", messages);
            request.setAttribute("friends", friends);
            request.setAttribute("quizzes", quizzes);
            request.setAttribute("unreadCount", unreadCount);

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("/message.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        String receiverIdStr = request.getParameter("receiverId");

        if (receiverIdStr == null || receiverIdStr.isEmpty()) {
            response.sendRedirect("message");
            return;
        }

        try {
            long receiverId = Long.parseLong(receiverIdStr);

            if ("sendChallenge".equals(action)) {
                String quizIdStr = request.getParameter("quizId");
                if (quizIdStr != null && !quizIdStr.isEmpty()) {
                    long quizId = Long.parseLong(quizIdStr);

                    long bestScore = quizDao.getBestScore(currentUser.getId(), quizId);
                    String quizTitle = quizDao.getQuizTitle(quizId);
                    String content = "challenged you to take \"" + quizTitle + "\"! Their best score: " + bestScore;

                    messageDao.sendChallenge(currentUser.getId(), receiverId, content, quizId);
                }
            } else if ("sendNote".equals(action)) {
                String content = request.getParameter("content");
                if (content != null && !content.trim().isEmpty()) {
                    messageDao.sendNote(currentUser.getId(), receiverId, content.trim());
                }
            }

        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
            return;
        }

        response.sendRedirect("message");
    }
}
