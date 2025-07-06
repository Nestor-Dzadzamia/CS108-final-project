package DAO;

import DB.DBConnection;
import Models.PossibleAnswer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PossibleAnswerDao {

    public List<PossibleAnswer> getPossibleAnswersByQuestion(long questionId) throws SQLException {
        String sql = "SELECT * FROM possible_answers WHERE question_id = ?";
        List<PossibleAnswer> answers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, questionId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PossibleAnswer pa = new PossibleAnswer(
                            rs.getLong("possible_answer_id"),
                            rs.getLong("question_id"),
                            rs.getString("possible_answer_text")
                    );
                    answers.add(pa);
                }
            }
        }
        return answers;
    }

    public void createPossibleAnswer(PossibleAnswer answer) throws SQLException {
        String sql = "INSERT INTO possible_answers (question_id, possible_answer_text) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, answer.getQuestionId());
            stmt.setString(2, answer.getPossibleAnswerText());
            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    answer.setPossibleAnswerId(keys.getLong(1));
                }
            }
        }
    }

    public void deletePossibleAnswer(long possibleAnswerId) throws SQLException {
        String sql = "DELETE FROM possible_answers WHERE possible_answer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, possibleAnswerId);
            stmt.executeUpdate();
        }
    }
}
