package DAO;

import DB.DBConnection;
import Models.QuizTag;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizTagDao {

    public boolean addTagToQuiz(long quizId, long tagId) throws SQLException {
        String sql = "INSERT INTO quiz_tags (quiz_id, tag_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, quizId);
            stmt.setLong(2, tagId);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean removeTagFromQuiz(long quizId, long tagId) throws SQLException {
        String sql = "DELETE FROM quiz_tags WHERE quiz_id = ? AND tag_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, quizId);
            stmt.setLong(2, tagId);

            return stmt.executeUpdate() > 0;
        }
    }

    public List<Long> getTagIdsForQuiz(long quizId) throws SQLException {
        String sql = "SELECT tag_id FROM quiz_tags WHERE quiz_id = ?";
        List<Long> tagIds = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, quizId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tagIds.add(rs.getLong("tag_id"));
                }
            }
        }

        return tagIds;
    }

    public List<Long> getQuizIdsForTag(long tagId) throws SQLException {
        String sql = "SELECT quiz_id FROM quiz_tags WHERE tag_id = ?";
        List<Long> quizIds = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, tagId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    quizIds.add(rs.getLong("quiz_id"));
                }
            }
        }

        return quizIds;
    }
}
