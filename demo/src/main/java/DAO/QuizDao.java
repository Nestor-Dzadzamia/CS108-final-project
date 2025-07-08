package DAO;

import DB.DBConnection;
import Models.Quiz;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDao {

    public long insertQuiz(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO quizzes (quiz_title, description, created_by, randomized, is_multiple_page, " +
                "immediate_correction, allow_practice, quiz_category, total_time_limit) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, quiz.getQuizTitle());
            stmt.setString(2, quiz.getDescription());
            if (quiz.getCreatedBy() != 0) {
                stmt.setLong(3, quiz.getCreatedBy());
            } else {
                stmt.setNull(3, Types.BIGINT);
            }
            stmt.setBoolean(4, quiz.isRandomized());
            stmt.setBoolean(5, quiz.isMultiplePage());
            stmt.setBoolean(6, quiz.isImmediateCorrection());
            stmt.setBoolean(7, quiz.isAllowPractice());

            if (quiz.getQuizCategory() != 0) {
                stmt.setLong(8, quiz.getQuizCategory());
            } else {
                stmt.setNull(8, Types.BIGINT);
            }

            if (quiz.getTotalTimeLimit() != 0) {
                stmt.setLong(9, quiz.getTotalTimeLimit());
            } else {
                stmt.setNull(9, Types.BIGINT);
            }

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1); // return generated quiz_id
                }
            }
        }

        throw new SQLException("Quiz insertion failed — no ID returned.");
    }

    private Quiz mapRow(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setQuizId(rs.getLong("quiz_id"));
        quiz.setQuizTitle(rs.getString("quiz_title"));
        quiz.setDescription(rs.getString("description"));

        // Nullable long fields
        long createdBy = rs.getLong("created_by");
        quiz.setCreatedBy(rs.wasNull() ? null : createdBy);

        quiz.setRandomized(rs.getBoolean("randomized"));
        quiz.setMultiplePage(rs.getBoolean("is_multiple_page"));
        quiz.setImmediateCorrection(rs.getBoolean("immediate_correction"));
        quiz.setAllowPractice(rs.getBoolean("allow_practice"));
        quiz.setCreatedAt(rs.getTimestamp("created_at"));

        Long quizCategory = rs.getLong("quiz_category");
        quiz.setQuizCategory(rs.wasNull() ? null : quizCategory);

        Long totalTimeLimit = rs.getLong("total_time_limit");
        quiz.setTotalTimeLimit(rs.wasNull() ? null : totalTimeLimit);

        // For views or summary tables: try both names
        if (hasColumn(rs, "submissions_number"))
            quiz.setSubmissionsNumber(rs.getLong("submissions_number"));
        else if (hasColumn(rs, "submissions"))
            quiz.setSubmissionsNumber(rs.getLong("submissions"));

        return quiz;
    }

    // Helper to check if a column exists in the ResultSet
    private boolean hasColumn(ResultSet rs, String column) {
        try {
            rs.findColumn(column);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    public String getCreatorUsernameByQuizId(long quizId) throws SQLException {
        String sql = "SELECT u.username " +
                "FROM quizzes q " +
                "JOIN users u ON q.created_by = u.user_id " +
                "WHERE q.quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        }
        return null; // or "Unknown"
    }

    public String getQuizCategory(Quiz quiz) {
        if (quiz == null || quiz.getQuizCategory() == 0) return null;
        String sql = "SELECT category_name FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quiz.getQuizCategory());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("category_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Or use your logging
        }
        return null;
    }


    public Quiz getQuizById(long quizId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<Quiz> getAllQuizzes() throws SQLException {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                quizzes.add(mapRow(rs));
            }
        }
        return quizzes;
    }

    public List<Quiz> getQuizzesByUser(long userId) throws SQLException {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes WHERE created_by = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    quizzes.add(mapRow(rs));
                }
            }
        }
        return quizzes;
    }

    public List<Quiz> getRecentQuizzes() throws SQLException {
        String sql = "SELECT * FROM view_recent_quizzes";
        List<Quiz> quizzes = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                quizzes.add(mapRow(rs));
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
                quizzes.add(mapRow(rs));
            }
        }
        return quizzes;
    }

    public int getQuestionsCount(long quizId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM questions WHERE quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quizId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
