package DAO;

import DB.DBConnection;
import Models.Tag;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TagDao {

    public Tag createTag(Tag tag) throws SQLException {
        String sql = "INSERT INTO tags (tag_name) VALUES (?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, tag.getTagName());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating tag failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    tag.setTagId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating tag failed, no ID obtained.");
                }
            }
        }

        return tag;
    }

    public Tag getTagById(long tagId) throws SQLException {
        String sql = "SELECT * FROM tags WHERE tag_id = ?";
        Tag tag = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, tagId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    tag = new Tag(rs.getLong("tag_id"), rs.getString("tag_name"));
                }
            }
        }

        return tag;
    }

    public Tag getTagByName(String tagName) throws SQLException {
        String sql = "SELECT * FROM tags WHERE tag_name = ?";
        Tag tag = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tagName);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    tag = new Tag(rs.getLong("tag_id"), rs.getString("tag_name"));
                }
            }
        }

        return tag;
    }

    public List<Tag> getAllTags() throws SQLException {
        String sql = "SELECT * FROM tags";
        List<Tag> tags = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                tags.add(new Tag(rs.getLong("tag_id"), rs.getString("tag_name")));
            }
        }

        return tags;
    }

    public boolean deleteTag(long tagId) throws SQLException {
        String sql = "DELETE FROM tags WHERE tag_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, tagId);

            return stmt.executeUpdate() > 0;
        }
    }
}
