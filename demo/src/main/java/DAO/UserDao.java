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

    //for updating user stats and achievemnts after creating quiz
    public List<String> incrementQuizzesCreatedAndCheckAchievements(long userId) throws SQLException {
        List<String> awardedAchievements = new ArrayList<>();

        String getSql = "SELECT num_quizzes_created FROM users WHERE user_id = ?";
        String updateSql = "UPDATE users SET num_quizzes_created = num_quizzes_created + 1 WHERE user_id = ?";
        String checkAchievementSql = "SELECT achievement_id FROM user_achievements WHERE user_id = ? AND achievement_id = ?";
        String insertAchievementSql = "INSERT INTO user_achievements (user_id, achievement_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);  // Start transaction

            long currentCount;
            try (PreparedStatement stmt = conn.prepareStatement(getSql)) {
                stmt.setLong(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (!rs.next()) return awardedAchievements;  // User not found
                currentCount = rs.getLong("num_quizzes_created");
            }

            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setLong(1, userId);
                stmt.executeUpdate();
            }

            long newCount = currentCount + 1;

            // Check and insert achievements based on new count
            if (currentCount < 1 && newCount >= 1) {
                if (!hasAchievement(conn, userId, 1)) { // Amateur Author
                    awardAchievement(conn, userId, 1);
                    awardedAchievements.add("Amateur Author");
                }
            }

            if (currentCount < 5 && newCount >= 5) {
                if (!hasAchievement(conn, userId, 2)) { // Prolific Author
                    awardAchievement(conn, userId, 2);
                    awardedAchievements.add("Prolific Author");
                }
            }

            conn.commit();  // All done
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;  // Let the caller handle rollback if needed
        }

        return awardedAchievements;
    }

    private boolean hasAchievement(Connection conn, long userId, long achievementId) throws SQLException {
        String sql = "SELECT 1 FROM user_achievements WHERE user_id = ? AND achievement_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, achievementId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

    private void awardAchievement(Connection conn, long userId, long achievementId) throws SQLException {
        String sql = "INSERT INTO user_achievements (user_id, achievement_id) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, achievementId);
            stmt.executeUpdate();
        }
    }

    public boolean recordSubmissionAndCheckAchievements(
            long userId, long quizId, long numCorrect, long numTotal, long score, long timeSpent
    ) throws SQLException {
        List<String> awardedAchievements = new ArrayList<>();

        String getUserStatsSql = "SELECT num_quizzes_taken FROM users WHERE user_id = ?";
        String updateUserSql = "UPDATE users SET num_quizzes_taken = num_quizzes_taken + 1 WHERE user_id = ?";
        String insertSubmissionSql = """
        INSERT INTO submissions (user_id, quiz_id, num_correct_answers, num_total_answers, score, time_spent)
        VALUES (?, ?, ?, ?, ?, ?)
    """;
        String checkAchievementSql = "SELECT 1 FROM user_achievements WHERE user_id = ? AND achievement_id = ?";
        String insertAchievementSql = "INSERT INTO user_achievements (user_id, achievement_id) VALUES (?, ?)";
        String updateQuizSql = "UPDATE quizzes SET submissions_number = submissions_number + 1 WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Begin transaction

            long currentTaken;
            try (PreparedStatement stmt = conn.prepareStatement(getUserStatsSql)) {
                stmt.setLong(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (!rs.next()) return false; // user doesn't exist
                currentTaken = rs.getLong("num_quizzes_taken");
            }

            try (PreparedStatement stmt = conn.prepareStatement(updateUserSql)) {
                stmt.setLong(1, userId);
                stmt.executeUpdate();
            }

            try (PreparedStatement stmt = conn.prepareStatement(insertSubmissionSql)) {
                stmt.setLong(1, userId);
                stmt.setLong(2, quizId);
                stmt.setLong(3, numCorrect);
                stmt.setLong(4, numTotal);
                stmt.setLong(5, score);
                stmt.setLong(6, timeSpent);
                stmt.executeUpdate();
            }

            try (PreparedStatement stmt = conn.prepareStatement(updateQuizSql)) {
                stmt.setLong(1, quizId);
                stmt.executeUpdate();
            }

            long newTaken = currentTaken + 1;

            if (currentTaken < 10 && newTaken >= 10) {
                try (PreparedStatement checkStmt = conn.prepareStatement(checkAchievementSql)) {
                    checkStmt.setLong(1, userId);
                    checkStmt.setLong(2, 3); // "Quiz Machine" achievement
                    ResultSet rs = checkStmt.executeQuery();

                    if (!rs.next()) {
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertAchievementSql)) {
                            insertStmt.setLong(1, userId);
                            insertStmt.setLong(2, 3);
                            insertStmt.executeUpdate();
                            awardedAchievements.add("Quiz Machine");
                        }
                    }
                }
            }

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return true;
    }

    public void handlePracticeAchievement(long userId) throws SQLException {
        Connection conn = null;
        PreparedStatement checkAchievement = null;
        PreparedStatement giveAchievement = null;
        PreparedStatement updateUser = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Set taken_practice = TRUE (even if it's already true, doesn't hurt)
            updateUser = conn.prepareStatement(
                    "UPDATE users SET taken_practice = TRUE WHERE user_id = ?"
            );
            updateUser.setLong(1, userId);
            updateUser.executeUpdate();

            // 2. Check if achievement already awarded
            checkAchievement = conn.prepareStatement(
                    "SELECT 1 FROM user_achievements WHERE user_id = ? AND achievement_id = 4"
            );
            checkAchievement.setLong(1, userId);
            ResultSet rs = checkAchievement.executeQuery();

            if (!rs.next()) {
                // 3. Award the achievement if not yet awarded
                giveAchievement = conn.prepareStatement(
                        "INSERT INTO user_achievements (user_id, achievement_id) VALUES (?, 4)"
                );
                giveAchievement.setLong(1, userId);
                giveAchievement.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (checkAchievement != null) checkAchievement.close();
            if (giveAchievement != null) giveAchievement.close();
            if (updateUser != null) updateUser.close();
            if (conn != null) conn.close();
        }
    }
    public long countUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getLong(1) : 0;
        }
    }

    public long countQuizzesTaken() throws SQLException {
        String sql = "SELECT SUM(num_quizzes_taken) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getLong(1) : 0;
        }
    }

    public boolean updateUserRole(long userId, String newRole) throws SQLException {
        String sql = "UPDATE users SET role = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setLong(2, userId);
            int affected = stmt.executeUpdate();
            return affected > 0;
        }
    }

    public List<User> getAdminUsers() throws SQLException {
        String sql = "SELECT * FROM users WHERE role = 'admin' ORDER BY username";
        List<User> admins = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                admins.add(mapUser(rs));
            }
        }
        return admins;
    }


}
