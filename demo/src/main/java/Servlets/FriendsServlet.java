package Servlets;

import DAO.*;
import Models.*;
import DB.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String userId = request.getParameter("userId");
        String search = request.getParameter("search");

        try {
            // Show user profile
            if ("profile".equals(action) && userId != null) {
                User profileUser = getUserById(Long.parseLong(userId));
                if (profileUser != null) {
                    boolean areFriends = areFriends(currentUser.getId(), profileUser.getId());
                    List<Quiz> userQuizzes = getQuizzesByUser(profileUser.getId());

                    request.setAttribute("profileUser", profileUser);
                    request.setAttribute("areFriends", areFriends);
                    request.setAttribute("userQuizzes", userQuizzes);
                    request.setAttribute("isOwnProfile", currentUser.getId().equals(profileUser.getId()));
                }
            }

            // Search users
            List<User> searchResults = new ArrayList<>();
            if (search != null && !search.trim().isEmpty()) {
                searchResults = searchUsers(search.trim(), currentUser.getId());
                request.setAttribute("searchQuery", search);
            }

            // Get friends and requests
            List<User> friends = getFriends(currentUser.getId());
            List<FriendRequest> pendingRequests = getPendingRequests(currentUser.getId());
            List<User> requestSenders = new ArrayList<>();
            for (FriendRequest req : pendingRequests) {
                User sender = getUserById(req.getSenderId());
                if (sender != null) requestSenders.add(sender);
            }

            request.setAttribute("searchResults", searchResults);
            request.setAttribute("friends", friends);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("requestSenders", requestSenders);

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("friends.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String targetUserId = request.getParameter("targetUserId");
        String requestId = request.getParameter("requestId");

        try {
            if ("send".equals(action) && targetUserId != null) {
                long targetId = Long.parseLong(targetUserId);
                if (!areFriends(currentUser.getId(), targetId)) {
                    sendFriendRequest(currentUser.getId(), targetId, currentUser.getUsername());
                    request.setAttribute("success", "Friend request sent!");
                }
            } else if ("accept".equals(action) && requestId != null) {
                long reqId = Long.parseLong(requestId);
                acceptFriendRequest(reqId, currentUser.getId());
                request.setAttribute("success", "Friend request accepted!");
            } else if ("reject".equals(action) && requestId != null) {
                long reqId = Long.parseLong(requestId);
                rejectFriendRequest(reqId, currentUser.getId());
                request.setAttribute("success", "Friend request rejected.");
            } else if ("remove".equals(action) && targetUserId != null) {
                long targetId = Long.parseLong(targetUserId);
                removeFriendship(currentUser.getId(), targetId);
                request.setAttribute("success", "Friend removed.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        response.sendRedirect("friends");
    }

    // Helper methods
    private List<User> searchUsers(String query, long currentUserId) throws SQLException {
        String sql = "SELECT * FROM users WHERE (username LIKE ? OR email LIKE ?) AND user_id != ? LIMIT 20";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + query + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setLong(3, currentUserId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }
        return users;
    }

    private User getUserById(long userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? mapUser(rs) : null;
        }
    }

    private List<User> getFriends(long userId) throws SQLException {
        String sql = "SELECT u.* FROM users u JOIN friendships f ON " +
                "(f.user_id1 = u.user_id AND f.user_id2 = ?) OR " +
                "(f.user_id2 = u.user_id AND f.user_id1 = ?)";
        List<User> friends = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                friends.add(mapUser(rs));
            }
        }
        return friends;
    }

    private List<FriendRequest> getPendingRequests(long userId) throws SQLException {
        String sql = "SELECT * FROM friend_requests WHERE receiver_id = ? AND status = 'pending'";
        List<FriendRequest> requests = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                FriendRequest req = new FriendRequest();
                req.setRequestId(rs.getLong("request_id"));
                req.setSenderId(rs.getLong("sender_id"));
                req.setReceiverId(rs.getLong("receiver_id"));
                req.setStatus(rs.getString("status"));
                req.setSentAt(rs.getTimestamp("sent_at"));
                requests.add(req);
            }
        }
        return requests;
    }

    private boolean areFriends(long userId1, long userId2) throws SQLException {
        String sql = "SELECT COUNT(*) FROM friendships WHERE " +
                "(user_id1 = ? AND user_id2 = ?) OR (user_id1 = ? AND user_id2 = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, Math.min(userId1, userId2));
            stmt.setLong(2, Math.max(userId1, userId2));
            stmt.setLong(3, Math.min(userId1, userId2));
            stmt.setLong(4, Math.max(userId1, userId2));

            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    private void sendFriendRequest(long senderId, long receiverId, String senderName) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            // Insert friend request
            String sql1 = "INSERT INTO friend_requests (sender_id, receiver_id, status) VALUES (?, ?, 'pending')";
            long requestId;
            try (PreparedStatement stmt = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setLong(1, senderId);
                stmt.setLong(2, receiverId);
                stmt.executeUpdate();

                ResultSet keys = stmt.getGeneratedKeys();
                requestId = keys.next() ? keys.getLong(1) : 0;
            }

            // Create message
            String sql2 = "INSERT INTO messages (sender_id, receiver_id, message_type, content, friend_request_id, is_read) VALUES (?, ?, 'friend_request', ?, ?, FALSE)";
            try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                stmt.setLong(1, senderId);
                stmt.setLong(2, receiverId);
                stmt.setString(3, senderName + " sent you a friend request.");
                stmt.setLong(4, requestId);
                stmt.executeUpdate();
            }
        }
    }

    private void acceptFriendRequest(long requestId, long currentUserId) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            // Get request details
            String sql1 = "SELECT sender_id, receiver_id FROM friend_requests WHERE request_id = ? AND receiver_id = ?";
            long senderId, receiverId;
            try (PreparedStatement stmt = conn.prepareStatement(sql1)) {
                stmt.setLong(1, requestId);
                stmt.setLong(2, currentUserId);
                ResultSet rs = stmt.executeQuery();
                if (!rs.next()) return;
                senderId = rs.getLong("sender_id");
                receiverId = rs.getLong("receiver_id");
            }

            // Update request status
            String sql2 = "UPDATE friend_requests SET status = 'accepted' WHERE request_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                stmt.setLong(1, requestId);
                stmt.executeUpdate();
            }

            // Create friendship
            String sql3 = "INSERT INTO friendships (user_id1, user_id2) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql3)) {
                stmt.setLong(1, Math.min(senderId, receiverId));
                stmt.setLong(2, Math.max(senderId, receiverId));
                stmt.executeUpdate();
            }
        }
    }

    private void rejectFriendRequest(long requestId, long currentUserId) throws SQLException {
        String sql = "UPDATE friend_requests SET status = 'rejected' WHERE request_id = ? AND receiver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, requestId);
            stmt.setLong(2, currentUserId);
            stmt.executeUpdate();
        }
    }

    private void removeFriendship(long userId1, long userId2) throws SQLException {
        String sql = "DELETE FROM friendships WHERE (user_id1 = ? AND user_id2 = ?) OR (user_id1 = ? AND user_id2 = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, Math.min(userId1, userId2));
            stmt.setLong(2, Math.max(userId1, userId2));
            stmt.setLong(3, Math.min(userId1, userId2));
            stmt.setLong(4, Math.max(userId1, userId2));
            stmt.executeUpdate();
        }
    }

    private List<Quiz> getQuizzesByUser(long userId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE created_by = ?";
        List<Quiz> quizzes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizId(rs.getLong("quiz_id"));
                quiz.setQuizTitle(rs.getString("quiz_title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCreatedAt(rs.getTimestamp("created_at"));
                quiz.setSubmissionsNumber(rs.getLong("submissions_number"));
                quizzes.add(quiz);
            }
        }
        return quizzes;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setTimeCreated(rs.getTimestamp("time_created"));
        user.setNumQuizzesCreated(rs.getLong("num_quizzes_created"));
        user.setNumQuizzesTaken(rs.getLong("num_quizzes_taken"));
        user.setWasTop1(rs.getBoolean("was_top1"));
        user.setTakenPractice(rs.getBoolean("taken_practice"));
        return user;
    }
}