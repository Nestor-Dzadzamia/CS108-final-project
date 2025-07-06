package DAO;

import DB.DBConnection;
import Models.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDao {

    public Message createMessage(Message message) throws SQLException {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message_type, content, quiz_id, friend_request_id, is_read) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, message.getSenderId());
            stmt.setLong(2, message.getReceiverId());
            stmt.setString(3, message.getMessageType());
            stmt.setString(4, message.getContent());
            if (message.getQuizId() != null) {
                stmt.setLong(5, message.getQuizId());
            } else {
                stmt.setNull(5, Types.BIGINT);
            }
            if (message.getFriendRequestId() != null) {
                stmt.setLong(6, message.getFriendRequestId());
            } else {
                stmt.setNull(6, Types.BIGINT);
            }
            stmt.setBoolean(7, message.isRead());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating message failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    message.setMessageId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating message failed, no ID obtained.");
                }
            }
        }

        return message;
    }

    public Message getMessageById(long messageId) throws SQLException {
        String sql = "SELECT * FROM messages WHERE message_id = ?";
        Message message = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, messageId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    message = mapResultSetToMessage(rs);
                }
            }
        }

        return message;
    }

    public List<Message> getMessagesForReceiver(long receiverId) throws SQLException {
        String sql = "SELECT * FROM messages WHERE receiver_id = ? ORDER BY sent_at DESC";
        List<Message> messages = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, receiverId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapResultSetToMessage(rs));
                }
            }
        }

        return messages;
    }

    public boolean markMessageAsRead(long messageId) throws SQLException {
        String sql = "UPDATE messages SET is_read = TRUE WHERE message_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, messageId);

            return stmt.executeUpdate() > 0;
        }
    }

    private Message mapResultSetToMessage(ResultSet rs) throws SQLException {
        Message msg = new Message();
        msg.setMessageId(rs.getLong("message_id"));
        msg.setSenderId(rs.getLong("sender_id"));
        msg.setReceiverId(rs.getLong("receiver_id"));
        msg.setMessageType(rs.getString("message_type"));
        msg.setContent(rs.getString("content"));
        long quizId = rs.getLong("quiz_id");
        if (rs.wasNull()) quizId = -1;
        msg.setQuizId(quizId == -1 ? null : quizId);

        long friendRequestId = rs.getLong("friend_request_id");
        if (rs.wasNull()) friendRequestId = -1;
        msg.setFriendRequestId(friendRequestId == -1 ? null : friendRequestId);

        msg.setSentAt(rs.getTimestamp("sent_at"));
        msg.setRead(rs.getBoolean("is_read"));
        return msg;
    }
}
