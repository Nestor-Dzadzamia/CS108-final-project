package DAO;

import DB.DBConnection;
import Models.Questions.*;

import java.sql.*;
import java.util.*;

public class QuestionDao {

    private Connection conn;

    public QuestionDao() throws SQLException {
        this.conn = DBConnection.getConnection();
    }

    // Load all questions for a given quiz, ordered
    public List<Question> getQuestionsByQuizId(long quizId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String query = "SELECT * FROM questions WHERE quiz_id = ? ORDER BY question_order ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setLong(1, quizId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Question question = new Question();
                question.setQuestionId(rs.getLong("question_id"));
                question.setQuizId(rs.getLong("quiz_id"));
                question.setQuestionType(rs.getString("question_type"));
                question.setQuestionText(rs.getString("question_text"));
                question.setImageUrl(rs.getString("image_url"));
                question.setTimeLimit(rs.getLong("time_limit"));
                question.setQuestionOrder(rs.getInt("question_order"));
                questions.add(question);
            }
        }

        return questions;
    }

    public long insertQuestion(QuestionSaver question) throws SQLException {
        String sql = "INSERT INTO questions (quiz_id, question_type, question_text, image_url, time_limit, question_order) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, question.getQuizId());
            stmt.setString(2, question.getQuestionType());
            stmt.setString(3, question.getQuestionText());
            stmt.setString(4, question.getImageUrl());
            stmt.setLong(5, question.getTimeLimit());
            stmt.setInt(6, question.getQuestionOrder());

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted == 0) {
                throw new SQLException("Inserting question failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1); // Return generated question ID
                } else {
                    throw new SQLException("Inserting question failed, no ID obtained.");
                }
            }
        }
    }
}