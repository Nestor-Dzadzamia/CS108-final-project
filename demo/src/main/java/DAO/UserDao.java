package DAO;

import DB.DBConnection;
import Models.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public User getUserById(long userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? mapUser(rs) : null;
        }
    }
    public List<User> searchUsers(String query, long currentUserId) throws SQLException {
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
        user.setRole(rs.getString("role"));
        return user;
    }

    public User findByUsername(String username) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setHashedPassword(rs.getString("hashed_password"));
                user.setSalt(rs.getString("salt_password"));
                user.setRole(rs.getString("role"));
                return user;
            }
        }
        return null;
    }

    public boolean insertUser(User user) throws SQLException {
        String query = "INSERT INTO users (username, email, hashed_password, salt_password) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getHashedPassword());
            stmt.setString(4, user.getSalt());
            return stmt.executeUpdate() > 0;
        }
    }

    // *** Added: Get friends of a user ***
    public List<User> getFriends(long userId) throws SQLException {
        String sql = "SELECT u.* FROM users u " +
                "JOIN friendships f ON " +
                "(f.user_id1 = u.user_id AND f.user_id2 = ?) OR " +
                "(f.user_id2 = u.user_id AND f.user_id1 = ?) " +
                "ORDER BY u.username";

        List<User> friends = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User friend = new User();
                friend.setId(rs.getLong("user_id"));
                friend.setUsername(rs.getString("username"));
                friends.add(friend);
            }
        }

        return friends;
    }

    public boolean removeUser(long userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            int affected = stmt.executeUpdate();
            return affected > 0;
        }
    }
}
