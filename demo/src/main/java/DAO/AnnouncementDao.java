package DAO;

import DB.DBConnection;
import Models.Announcement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDao {

    // Get all announcements (latest first)
    public List<Announcement> getAllAnnouncements() throws SQLException {
        String sql = "SELECT * FROM announcements ORDER BY created_at DESC";
        List<Announcement> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // Add an announcement
    public void addAnnouncement(String title, String message, Long createdBy) throws SQLException {
        String sql = "INSERT INTO announcements (title, message, created_by) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, message);
            if (createdBy != null) stmt.setLong(3, createdBy);
            else stmt.setNull(3, Types.BIGINT);
            stmt.executeUpdate();
        }
    }

    // Remove (delete) an announcement
    public void removeAnnouncement(long announcementId) throws SQLException {
        String sql = "DELETE FROM announcements WHERE announcement_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, announcementId);
            stmt.executeUpdate();
        }
    }

    // Helper: Convert ResultSet row to Announcement
    private Announcement mapRow(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setAnnouncementId(rs.getLong("announcement_id"));
        a.setTitle(rs.getString("title"));
        a.setMessage(rs.getString("message"));
        a.setCreatedBy(rs.getLong("created_by"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setIsActive(rs.getBoolean("is_active"));
        return a;
    }
}
