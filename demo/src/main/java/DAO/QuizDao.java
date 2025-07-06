package DAO;

import DB.DBConnection;
import Models.Quiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDao {

    public List<Quiz> getRecentQuizzes() throws SQLException {
        String sql = "SELECT * FROM view_recent_quizzes";
        List<Quiz> quizzes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getLong("quiz_id"));
                quiz.setTitle(rs.getString("quiz_title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCreator(rs.getString("creator"));
                quiz.setCreatedAt(rs.getString("created_at"));
                quizzes.add(quiz);
            }
        }

        return quizzes;
    }

    public List<Quiz> getPopularQuizzes() throws SQLException {
        String sql = "SELECT * FROM view_popular_quizzes";
        List<Quiz> quizzes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getLong("quiz_id"));
                quiz.setTitle(rs.getString("quiz_title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCreator(rs.getString("creator"));
                quiz.setSubmissions(rs.getLong("submissions_number"));
                quizzes.add(quiz);
            }
        }

        return quizzes;
    }
    public List<Quiz> getQuizzesByUserId(long userId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE creator_id = ?";
        List<Quiz> quizzes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setId(rs.getLong("id"));
                    quiz.setTitle(rs.getString("title"));
                    quiz.setDescription(rs.getString("description"));
                    quiz.setCreatedAt(rs.getString("created_at"));
                    quizzes.add(quiz);
                }
            }
        }

        return quizzes;
    }
    public List<Quiz> getQuizzesByUser(long userId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE created_by = ?";
        List<Quiz> quizzes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getLong("quiz_id"));
                quiz.setTitle(rs.getString("quiz_title"));
                quiz.setDescription(rs.getString("description"));
                quiz.setCreatedAt(rs.getString("created_at"));
                quizzes.add(quiz);
            }
        }

        return quizzes;
    }


}
