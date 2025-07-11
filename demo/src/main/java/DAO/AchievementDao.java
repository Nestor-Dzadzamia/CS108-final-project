package DAO;

import DB.DBConnection;
import Models.Achievement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AchievementDao {

    // Create a new achievement (without awardedAt)
    public Achievement createAchievement(Achievement achievement) throws SQLException {
        String sql = "INSERT INTO achievements (achievement_name, achievement_description, icon_url) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, achievement.getAchievementName());
            stmt.setString(2, achievement.getAchievementDescription());
            stmt.setString(3, achievement.getIconUrl());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating achievement failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    achievement.setAchievementId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating achievement failed, no ID obtained.");
                }
            }
        }
        return achievement;
    }

    public List<Achievement> getAchievementsByUserId(long userId) throws SQLException {
        String sql = """
        SELECT a.achievement_id, a.achievement_name, a.achievement_description, a.icon_url, ua.awarded_at
        FROM user_achievements ua
        JOIN achievements a ON ua.achievement_id = a.achievement_id
        WHERE ua.user_id = ?
        ORDER BY ua.awarded_at DESC
    """;

        List<Achievement> achievements = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    achievements.add(new Achievement(
                            rs.getLong("achievement_id"),
                            rs.getString("achievement_name"),
                            rs.getString("achievement_description"),
                            rs.getString("icon_url"),
                            rs.getTimestamp("awarded_at")
                    ));
                }
            }
        }
        return achievements;
    }

    // Get all achievements (without awardedAt)
    public List<Achievement> getAllAchievements() throws SQLException {
        String sql = "SELECT * FROM achievements";
        List<Achievement> achievements = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                achievements.add(new Achievement(
                        rs.getLong("achievement_id"),
                        rs.getString("achievement_name"),
                        rs.getString("achievement_description"),
                        rs.getString("icon_url")
                ));
            }
        }
        return achievements;
    }

    // Delete achievement by ID
    public boolean deleteAchievement(long achievementId) throws SQLException {
        String sql = "DELETE FROM achievements WHERE achievement_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, achievementId);

            return stmt.executeUpdate() > 0;
        }
    }
}
