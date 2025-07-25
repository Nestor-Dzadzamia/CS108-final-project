package Servlets;

import DAO.MessageDao;
import DAO.QuizDao;
import DAO.UserDao;
import Models.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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
    private Gson gson;

    @Override
    public void init() {
        messageDao = new MessageDao();
        userDao = new UserDao();
        quizDao = new QuizDao();
        gson = new GsonBuilder()
                .excludeFieldsWithoutExposeAnnotation()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
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

        // --- Get selected friend for pre-selecting in form ---
        String selectedFriendIdParam = request.getParameter("to");
        Long selectedFriendId = null;
        if (selectedFriendIdParam != null && !selectedFriendIdParam.isEmpty()) {
            try {
                selectedFriendId = Long.parseLong(selectedFriendIdParam);
            } catch (NumberFormatException ignore) {}
        }

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

            if (selectedFriendId != null) {
                request.setAttribute("selectedFriendId", selectedFriendId);
            }
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

                    Message latest = messageDao.getLatestMessageBySenderReceiver(currentUser.getId(), receiverId);
                    if (isValidMessage(latest)) {
                        String json = gson.toJson(latest);
                        System.out.println("WS SENDING: " + json);
                        MessageWebSocketEndpoint.sendMessageToUser(receiverId, json);
                    }

                    request.setAttribute("success", "Challenge sent successfully!");
                }
            } else if ("sendNote".equals(action)) {
                String content = request.getParameter("content");
                if (content != null && !content.trim().isEmpty()) {
                    messageDao.sendNote(currentUser.getId(), receiverId, content.trim());

                    Message latest = messageDao.getLatestMessageBySenderReceiver(currentUser.getId(), receiverId);
                    if (isValidMessage(latest)) {
                        String json = gson.toJson(latest);
                        System.out.println("WS SENDING: " + json);
                        MessageWebSocketEndpoint.sendMessageToUser(receiverId, json);
                    }

                    request.setAttribute("success", "Note sent successfully!");
                }
            }

        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
            return;
        }

        response.sendRedirect("message");
    }

    private boolean isValidMessage(Message m) {
        return m != null && m.getContent() != null && !m.getContent().trim().isEmpty()
                && m.getSenderName() != null && m.getMessageType() != null;
    }
}
