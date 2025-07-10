package DAO;

import DB.DBConnection;
import Models.PossibleAnswer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PossibleAnswerDao {

    // Get possible answers (e.g. for multiple choice questions)
    public List<PossibleAnswer> getPossibleAnswersByQuestionId(long questionId) throws SQLException {
        List<PossibleAnswer> answers = new ArrayList<>();
        String query = "SELECT * FROM possible_answers WHERE question_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setLong(1, questionId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                PossibleAnswer answer = new PossibleAnswer();
                answer.setPossibleAnswerId(rs.getLong("possible_answer_id"));
                answer.setQuestionId(rs.getLong("question_id"));
                answer.setPossibleAnswerText(rs.getString("possible_answer_text"));
                answers.add(answer);
            }
        }

        return answers;
    }
}
