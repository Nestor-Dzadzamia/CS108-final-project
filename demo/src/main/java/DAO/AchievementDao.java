package DAO;

import DB.DBConnection;
import Models.Achievement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AchievementDao {

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

}
