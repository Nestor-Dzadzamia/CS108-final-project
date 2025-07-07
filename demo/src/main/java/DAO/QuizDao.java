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
    public Quiz getQuizById(long quizId) throws SQLException {
        String sql = """
    SELECT q.id AS quiz_id,
           q.quiz_title,
           q.description,
           u.username AS creator,
           q.created_at,
           COALESCE(s.submissions_count, 0) AS submissions
    FROM quizzes q
    JOIN users u ON q.created_by = u.id
    LEFT JOIN (
        SELECT quiz_id, COUNT(*) AS submissions_count
        FROM submissions
        GROUP BY quiz_id
    ) s ON q.id = s.quiz_id
    WHERE q.id = ?
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, quizId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setId(rs.getLong("quiz_id"));
                    quiz.setTitle(rs.getString("quiz_title"));
                    quiz.setDescription(rs.getString("description"));
                    quiz.setCreator(rs.getString("creator"));
                    quiz.setCreatedAt(rs.getString("created_at"));
                    quiz.setSubmissions(rs.getLong("submissions"));
                    return quiz;
                }
            }
        }
        return null;
    }



    public int getQuestionsCount(long quizId) throws SQLException {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        }

        return count;
    }



}
