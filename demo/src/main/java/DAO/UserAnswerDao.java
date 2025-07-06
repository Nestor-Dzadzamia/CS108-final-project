package DAO;

import DB.DBConnection;
import Models.UserAnswer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAnswerDao {

    public UserAnswer createUserAnswer(UserAnswer userAnswer) throws SQLException {
        String sql = "INSERT INTO user_answers (submission_id, question_id, answer_text, is_correct) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, userAnswer.getSubmissionId());
            stmt.setLong(2, userAnswer.getQuestionId());
            stmt.setString(3, userAnswer.getAnswerText());
            stmt.setBoolean(4, userAnswer.isCorrect());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating user answer failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    userAnswer.setUserAnswerId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating user answer failed, no ID obtained.");
                }
            }
        }

        return userAnswer;
    }

    public List<UserAnswer> getUserAnswersBySubmission(long submissionId) throws SQLException {
        String sql = "SELECT * FROM user_answers WHERE submission_id = ? ORDER BY answered_at ASC";
        List<UserAnswer> userAnswers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, submissionId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    userAnswers.add(mapResultSetToUserAnswer(rs));
                }
            }
        }

        return userAnswers;
    }

    private UserAnswer mapResultSetToUserAnswer(ResultSet rs) throws SQLException {
        UserAnswer ua = new UserAnswer();
        ua.setUserAnswerId(rs.getLong("user_answer_id"));
        ua.setSubmissionId(rs.getLong("submission_id"));
        ua.setQuestionId(rs.getLong("question_id"));
        ua.setAnswerText(rs.getString("answer_text"));
        ua.setCorrect(rs.getBoolean("is_correct"));
        ua.setAnsweredAt(rs.getTimestamp("answered_at"));
        return ua;
    }
}
