package DAO;

import DB.DBConnection;
import Models.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDao {

    public List<Message> getMessagesForUser(long userId) throws SQLException {
        String sql = "SELECT m.*, u.username as sender_name, q.quiz_title " +
                "FROM messages m " +
                "JOIN users u ON m.sender_id = u.user_id " +
                "LEFT JOIN quizzes q ON m.quiz_id = q.quiz_id " +
                "WHERE m.receiver_id = ? AND m.message_type IN ('challenge', 'note') " +
                "ORDER BY m.sent_at DESC";

        List<Message> messages = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageId(rs.getLong("message_id"));
                msg.setSenderId(rs.getLong("sender_id"));
                msg.setReceiverId(rs.getLong("receiver_id"));
                msg.setMessageType(rs.getString("message_type"));
                msg.setContent(rs.getString("content"));
                msg.setQuizId(rs.getLong("quiz_id"));
                msg.setSentAt(rs.getTimestamp("sent_at"));
                msg.setRead(rs.getBoolean("is_read"));
                msg.setSenderName(rs.getString("sender_name"));
                msg.setQuizTitle(rs.getString("quiz_title"));
                messages.add(msg);
            }
        }

        return messages;
    }

    public void sendNote(long senderId, long receiverId, String content) throws SQLException {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message_type, content, is_read) " +
                "VALUES (?, ?, 'note', ?, FALSE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, senderId);
            stmt.setLong(2, receiverId);
            stmt.setString(3, content);
            stmt.executeUpdate();
        }
    }

    public void sendChallenge(long senderId, long receiverId, String content, long quizId) throws SQLException {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message_type, content, quiz_id, is_read) " +
                "VALUES (?, ?, 'challenge', ?, ?, FALSE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, senderId);
            stmt.setLong(2, receiverId);
            stmt.setString(3, content);
            stmt.setLong(4, quizId);
            stmt.executeUpdate();
        }
    }

    public void markMessagesAsRead(long userId) throws SQLException {
        String sql = "UPDATE messages SET is_read = TRUE WHERE receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.executeUpdate();
        }
    }

    public int getUnreadMessageCount(long userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND is_read = FALSE AND message_type IN ('challenge', 'note')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

}
