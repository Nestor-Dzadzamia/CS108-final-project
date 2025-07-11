package DAO;

import DB.DBConnection;

import java.sql.*;

public class FriendshipDao {

    public boolean addFriendship(long userId1, long userId2) throws SQLException {
        if (userId1 == userId2) {
            throw new IllegalArgumentException("Cannot be friends with oneself.");
        }
        long lower = Math.min(userId1, userId2);
        long higher = Math.max(userId1, userId2);

        String sql = "INSERT INTO friendships (user_id1, user_id2) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, lower);
            stmt.setLong(2, higher);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean removeFriendship(long userId1, long userId2) throws SQLException {
        long lower = Math.min(userId1, userId2);
        long higher = Math.max(userId1, userId2);

        String sql = "DELETE FROM friendships WHERE user_id1 = ? AND user_id2 = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, lower);
            stmt.setLong(2, higher);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean areFriends(long userId1, long userId2) throws SQLException {
        long lower = Math.min(userId1, userId2);
        long higher = Math.max(userId1, userId2);

        String sql = "SELECT COUNT(*) FROM friendships WHERE user_id1 = ? AND user_id2 = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, lower);
            stmt.setLong(2, higher);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }
}
