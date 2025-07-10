package DAO;

import DB.DBConnection;
import Models.Answer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnswerDao {
    private final Connection conn;

    public AnswerDao() throws SQLException {
        this.conn = DBConnection.getConnection();  // Replace with your connection provider
    }

    /**
     * Inserts a correct answer into the correct_answers table.
     * @param questionId The ID of the question.
     * @param ans The correct answer text.
     * @param order The answer order (or -1 if order doesn't matter).
     */
    public void insertCorrectAnswer(long questionId, String ans, int order) throws SQLException {
        String sql = "INSERT INTO correct_answers (question_id, answer_text, match_order) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, questionId);
            stmt.setString(2, ans);
            stmt.setLong(3, order); // Use -1 when order doesn't matter
            stmt.executeUpdate();
        }
    }

    /**
     * Inserts a possible answer into the possible_answers table.
     * @param questionId The ID of the question.
     * @param optionText The possible answer text.
     */
    public void insertPossibleAnswer(long questionId, String optionText) throws SQLException {
        String sql = "INSERT INTO possible_answers (question_id, possible_answer_text) VALUES (?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, questionId);
            stmt.setString(2, optionText);
            stmt.executeUpdate();
        }
    }

    // Get correct answers for a specific question
    public List<Answer> getCorrectAnswersByQuestionId(long questionId) throws SQLException {
        List<Answer> answers = new ArrayList<>();
        String query = "SELECT * FROM correct_answers WHERE question_id = ? ORDER BY match_order ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setLong(1, questionId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Answer answer = new Answer();
                answer.setAnswerId(rs.getLong("answer_id"));
                answer.setQuestionId(rs.getLong("question_id"));
                answer.setAnswerText(rs.getString("answer_text"));
                answer.setMatchOrder(rs.getLong("match_order"));
                answers.add(answer);
            }
        }

        return answers;
    }
}
