package DAO;

import DB.DBConnection;
import Models.Quiz;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class QuizDao {

    // Your teammate's method (preserved)
    public long insertQuiz(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO quizzes (quiz_title, description, created_by, randomized, is_multiple_page, " +
                "immediate_correction, allow_practice, quiz_category, total_time_limit) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, quiz.getQuizTitle());
            stmt.setString(2, quiz.getDescription());
            if (quiz.getCreatedBy() != 0 && quiz.getCreatedBy() != 0) {
                stmt.setLong(3, quiz.getCreatedBy());
            } else {
                stmt.setNull(3, Types.BIGINT);
            }
            stmt.setBoolean(4, quiz.isRandomized());
            stmt.setBoolean(5, quiz.isMultiplePage());
            stmt.setBoolean(6, quiz.isImmediateCorrection());
            stmt.setBoolean(7, quiz.isAllowPractice());

            if (quiz.getQuizCategory() != 0 && quiz.getQuizCategory() != 0) {
                stmt.setLong(8, quiz.getQuizCategory());
            } else {
                stmt.setNull(8, Types.BIGINT);
            }

            if (quiz.getTotalTimeLimit() != 0 && quiz.getTotalTimeLimit() != 0) {
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

    // The robust, merged mapRow
    private Quiz mapRow(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();

        // Always present:
        quiz.setQuizId(rs.getLong("quiz_id"));
        quiz.setQuizTitle(rs.getString("quiz_title"));
        quiz.setDescription(rs.getString("description"));

        // Only set if column exists:
        if (hasColumn(rs, "created_by")) {
            long createdBy = rs.getLong("created_by");
            quiz.setCreatedBy(rs.wasNull() ? null : createdBy);
        }
        if (hasColumn(rs, "randomized")) {
            quiz.setRandomized(rs.getBoolean("randomized"));
        }
        if (hasColumn(rs, "is_multiple_page")) {
            quiz.setMultiplePage(rs.getBoolean("is_multiple_page"));
        }
        if (hasColumn(rs, "immediate_correction")) {
            quiz.setImmediateCorrection(rs.getBoolean("immediate_correction"));
        }
        if (hasColumn(rs, "allow_practice")) {
            quiz.setAllowPractice(rs.getBoolean("allow_practice"));
        }
        if (hasColumn(rs, "created_at")) {
            quiz.setCreatedAt(rs.getTimestamp("created_at"));
        }
        if (hasColumn(rs, "quiz_category")) {
            Long quizCategory = rs.getLong("quiz_category");
            quiz.setQuizCategory(rs.wasNull() ? null : quizCategory);
        }
        if (hasColumn(rs, "total_time_limit")) {
            Long totalTimeLimit = rs.getLong("total_time_limit");
            quiz.setTotalTimeLimit(rs.wasNull() ? null : totalTimeLimit);
        }
        if (hasColumn(rs, "submissions_number"))
            quiz.setSubmissionsNumber(rs.getLong("submissions_number"));
        else if (hasColumn(rs, "submissions"))
            quiz.setSubmissionsNumber(rs.getLong("submissions"));

        return quiz;
    }

    private boolean hasColumn(ResultSet rs, String column) {
        try {
            rs.findColumn(column);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    public String getCreatorUsernameByQuizId(long quizId) throws SQLException {
        String sql = "SELECT u.username FROM quizzes q JOIN users u ON q.created_by = u.user_id WHERE q.quiz_id = ?";
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
    public List<Quiz> getAllQuizzes() throws SQLException {
        String sql = "SELECT quiz_id, quiz_title FROM quizzes ORDER BY quiz_title";
        List<Quiz> quizzes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setQuizId(rs.getLong("quiz_id"));
                quiz.setQuizTitle(rs.getString("quiz_title"));
                quizzes.add(quiz);
            }
        }
        return quizzes;
    }

    public long getBestScore(long userId, long quizId) throws SQLException {
        String sql = "SELECT MAX(score) FROM submissions WHERE user_id = ? AND quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setLong(2, quizId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getLong(1) : 0;
        }
    }

    public String getQuizTitle(long quizId) throws SQLException {
        String sql = "SELECT quiz_title FROM quizzes WHERE quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quizId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString("quiz_title") : "Unknown Quiz";
        }
    }

    public boolean deleteQuiz(long quizId) throws SQLException {
        String sql = "DELETE FROM quizzes WHERE quiz_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, quizId);
            int affected = stmt.executeUpdate();
            return affected > 0;
        }
    }


    public List<Map<String, Object>> getAllQuizzesWithDetails() throws SQLException {
        String sql = "SELECT " +
                "q.quiz_id, q.quiz_title, q.description, q.created_at, q.submissions_number, " +
                "COALESCE(u.username, 'Unknown') AS creator_name, " +
                "COALESCE(c.category_name, 'Uncategorized') AS category_name " +
                "FROM quizzes q " +
                "LEFT JOIN users u ON q.created_by = u.user_id " +
                "LEFT JOIN categories c ON q.quiz_category = c.category_id";
        List<Map<String, Object>> quizzes = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();
            while (rs.next()) {
                Map<String, Object> quiz = new HashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    quiz.put(meta.getColumnLabel(i), rs.getObject(i));
                }
                quizzes.add(quiz);
            }
        }
        return quizzes;
    }

    public List<Map<String, Object>> getRecentQuizzesTakenByUser(long userId, int limit) throws SQLException {
        String sql = """
        SELECT s.submission_id, s.quiz_id, s.score, s.time_spent, s.num_correct_answers, s.num_total_answers, s.submitted_at, 
               q.quiz_title
        FROM submissions s
        JOIN quizzes q ON s.quiz_id = q.quiz_id
        WHERE s.user_id = ?
        ORDER BY s.submitted_at DESC
        LIMIT ?
        """;
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                int colCount = meta.getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= colCount; i++) {
                        row.put(meta.getColumnLabel(i), rs.getObject(i));
                    }
                    list.add(row);
                }
            }
        }
        return list;
    }



}
