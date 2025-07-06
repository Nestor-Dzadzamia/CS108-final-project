package DAO;

import DB.DBConnection;
import Models.CorrectAnswer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CorrectAnswerDao {

    public List<CorrectAnswer> getCorrectAnswersByQuestion(long questionId) throws SQLException {
        String sql = "SELECT * FROM correct_answers WHERE question_id = ?";
        List<CorrectAnswer> answers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, questionId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CorrectAnswer ca = new CorrectAnswer(
                            rs.getLong("answer_id"),
                            rs.getLong("question_id"),
                            rs.getString("answer_text"),
                            rs.getObject("match_order") == null ? null : rs.getLong("match_order")
                    );
                    answers.add(ca);
                }
            }
        }
        return answers;
    }

    public void createCorrectAnswer(CorrectAnswer answer) throws SQLException {
        String sql = "INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, answer.getQuestionId());
            stmt.setString(2, answer.getAnswerText());

            if (answer.getMatchOrder() != null) {
                stmt.setLong(3, answer.getMatchOrder());
            } else {
                stmt.setNull(3, Types.BIGINT);
            }

            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    answer.setAnswerId(keys.getLong(1));
                }
            }
        }
    }

    public void deleteCorrectAnswer(long answerId) throws SQLException {
        String sql = "DELETE FROM correct_answers WHERE answer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, answerId);
            stmt.executeUpdate();
        }
    }
}
