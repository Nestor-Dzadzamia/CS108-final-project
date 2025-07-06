package DAO;

import DB.DBConnection;
import Models.UserAchievement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAchievementDao {

    public boolean awardAchievementToUser(UserAchievement ua) throws SQLException {
        String sql = "INSERT INTO user_achievements (user_id, achievement_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, ua.getUserId());
            stmt.setLong(2, ua.getAchievementId());

            return stmt.executeUpdate() > 0;
        }
    }

    public List<UserAchievement> getUserAchievements(long userId) throws SQLException {
        String sql = "SELECT * FROM user_achievements WHERE user_id = ?";
        List<UserAchievement> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new UserAchievement(
                            rs.getLong("user_id"),
                            rs.getLong("achievement_id"),
                            rs.getTimestamp("awarded_at")
                    ));
                }
            }
        }

        return list;
    }

    public boolean removeUserAchievement(long userId, long achievementId) throws SQLException {
        String sql = "DELETE FROM user_achievements WHERE user_id = ? AND achievement_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            stmt.setLong(2, achievementId);

            return stmt.executeUpdate() > 0;
        }
    }
}
