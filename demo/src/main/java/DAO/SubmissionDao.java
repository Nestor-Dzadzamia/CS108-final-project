package DAO;

import DB.DBConnection;
import Models.Submission;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubmissionDao {

    public Submission createSubmission(Submission submission) throws SQLException {
        String sql = "INSERT INTO submissions (user_id, quiz_id, num_correct_answers, num_total_answers, score, time_spent) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, submission.getUserId());
            stmt.setLong(2, submission.getQuizId());
            stmt.setLong(3, submission.getNumCorrectAnswers());
            stmt.setLong(4, submission.getNumTotalAnswers());
            stmt.setLong(5, submission.getScore());
            stmt.setLong(6, submission.getTimeSpent());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating submission failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    submission.setSubmissionId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating submission failed, no ID obtained.");
                }
            }
        }

        return submission;
    }

    public Submission getSubmissionById(long submissionId) throws SQLException {
        String sql = "SELECT * FROM submissions WHERE submission_id = ?";
        Submission submission = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, submissionId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    submission = mapResultSetToSubmission(rs);
                }
            }
        }

        return submission;
    }

    public List<Submission> getSubmissionsByUser(long userId) throws SQLException {
        String sql = "SELECT * FROM submissions WHERE user_id = ? ORDER BY submitted_at DESC";
        List<Submission> submissions = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    submissions.add(mapResultSetToSubmission(rs));
                }
            }
        }

        return submissions;
    }

    private Submission mapResultSetToSubmission(ResultSet rs) throws SQLException {
        Submission submission = new Submission();
        submission.setSubmissionId(rs.getLong("submission_id"));
        submission.setUserId(rs.getLong("user_id"));
        submission.setQuizId(rs.getLong("quiz_id"));
        submission.setNumCorrectAnswers(rs.getLong("num_correct_answers"));
        submission.setNumTotalAnswers(rs.getLong("num_total_answers"));
        submission.setScore(rs.getLong("score"));
        submission.setTimeSpent(rs.getLong("time_spent"));
        submission.setSubmittedAt(rs.getTimestamp("submitted_at"));
        return submission;
    }
}
