package DAO;

import DB.DBConnection;
import Models.Questions.*;
import Models.CorrectAnswer;
import Models.PossibleAnswer;

import java.sql.*;
import java.util.*;

public class QuestionDao {

    // Question type constants mapping
    private static final String TYPE_QUESTION_RESPONSE = "1";
    private static final String TYPE_FILL_IN_THE_BLANK = "2";
    private static final String TYPE_MULTIPLE_CHOICE = "3";
    private static final String TYPE_PICTURE_RESPONSE = "4";
    private static final String TYPE_MULTI_ANSWER = "5";
    private static final String TYPE_MULTI_SELECT = "6";
    private static final String TYPE_MATCHING = "7";

    private CorrectAnswerDao correctAnswerDao;
    private PossibleAnswerDao possibleAnswerDao;

    private Connection conn;

    public QuestionDao() throws SQLException {
        this.correctAnswerDao = new CorrectAnswerDao();
        this.possibleAnswerDao = new PossibleAnswerDao();
        this.conn = DBConnection.getConnection();
    }

    public List<Question> getQuestionsByQuizId(long quizId) throws SQLException {
        String sql = "SELECT * FROM questions WHERE quiz_id = ? ORDER BY question_order ASC";
        List<Question> questions = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, quizId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Question question = mapResultSetToQuestion(rs);
                    if (question != null) {
                        questions.add(question);
                    }
                }
            }
        }

        return questions;
    }

    public List<Question> getQuestionsByQuizId(long quizId, boolean randomized) throws SQLException {
        List<Question> questions = getQuestionsByQuizId(quizId);

        if (randomized) {
            Collections.shuffle(questions);
        }

        return questions;
    }

    public Question getQuestionById(long questionId) throws SQLException {
        String sql = "SELECT * FROM questions WHERE question_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, questionId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToQuestion(rs);
                }
            }
        }

        return null;
    }

    private Question mapResultSetToQuestion(ResultSet rs) throws SQLException {
        long questionId = rs.getLong("question_id");
        long quizId = rs.getLong("quiz_id");
        String questionType = rs.getString("question_type");
        String questionText = rs.getString("question_text");
        String imageUrl = rs.getString("image_url");
        Long timeLimit = rs.getObject("time_limit", Long.class);
        int questionOrder = rs.getInt("question_order");

        // Convert to int for constructors that expect int
        int id = (int) questionId;
        int typeId = Integer.parseInt(questionType); // Parse the numeric type ID

        try {
            switch (questionType) {
                case TYPE_MULTIPLE_CHOICE:
                    return createMultipleChoiceAnswer(id, typeId, questionText, questionId);

                case TYPE_QUESTION_RESPONSE:
                    return createQuestionResponse(id, typeId, questionText, questionId);

                case TYPE_PICTURE_RESPONSE:
                    return createPictureResponse(id, typeId, questionText, questionId, imageUrl);

                case TYPE_FILL_IN_THE_BLANK:
                    return createFillInTheBlank(id, typeId, questionText, questionId);

                case TYPE_MATCHING:
                    return createMatchingQuestion(id, typeId, questionText, questionId);

                case TYPE_MULTI_SELECT:
                    return createMultiSelectQuestion(id, typeId, questionText, questionId);

                case TYPE_MULTI_ANSWER:
                    return createMultiAnswer(id, typeId, questionText, questionId);

                default:
                    // Fallback to QuestionResponse for unknown types
                    return createQuestionResponse(id, 2, questionText, questionId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Return null if we can't create the specific question type
            return null;
        }
    }

    private MultipleChoiceAnswer createMultipleChoiceAnswer(int id, int typeId, String questionText, long questionId) throws SQLException {
        List<PossibleAnswer> possibleAnswers = possibleAnswerDao.getPossibleAnswersByQuestion(questionId);
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        List<String> answerOptions = new ArrayList<>();
        for (PossibleAnswer pa : possibleAnswers) {
            answerOptions.add(pa.getPossibleAnswerText());
        }

        // Find the correct answer index (1-based)
        int correctIndex = 1; // Default
        if (!correctAnswers.isEmpty() && !answerOptions.isEmpty()) {
            String correctAnswerText = correctAnswers.get(0).getAnswerText();
            for (int i = 0; i < answerOptions.size(); i++) {
                if (answerOptions.get(i).equalsIgnoreCase(correctAnswerText)) {
                    correctIndex = i + 1; // 1-based
                    break;
                }
            }
        }

        return new MultipleChoiceAnswer(id, typeId, questionText, answerOptions, correctIndex);
    }

    private PictureResponse createPictureResponse(int id, int typeId, String questionText, long questionId, String imageUrl) throws SQLException {
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        Set<String> correctAnswerSet = new HashSet<>();
        for (CorrectAnswer ca : correctAnswers) {
            correctAnswerSet.add(ca.getAnswerText());
        }

        // Ensure we have at least one correct answer and a valid image URL
        if (correctAnswerSet.isEmpty()) {
            correctAnswerSet.add("default answer");
        }
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "default.jpg";
        }

        return new PictureResponse(id, typeId, questionText, correctAnswerSet, imageUrl);
    }

    private QuestionResponse createQuestionResponse(int id, int typeId, String questionText, long questionId) throws SQLException {
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        Set<String> correctAnswerSet = new HashSet<>();
        for (CorrectAnswer ca : correctAnswers) {
            correctAnswerSet.add(ca.getAnswerText());
        }

        return new QuestionResponse(id, typeId, questionText, correctAnswerSet, 1); // maxScore = 1
    }

    private FillInTheBlank createFillInTheBlank(int id, int typeId, String questionText, long questionId) throws SQLException {
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        Set<String> correctAnswerSet = new HashSet<>();
        for (CorrectAnswer ca : correctAnswers) {
            correctAnswerSet.add(ca.getAnswerText());
        }

        // Ensure question has blanks
        if (!questionText.contains("_")) {
            questionText += " _____";
        }

        return new FillInTheBlank(id, typeId, questionText, correctAnswerSet, 1); // maxScore = 1
    }

    private MatchingQuestion createMatchingQuestion(int id, int typeId, String questionText, long questionId) throws SQLException {
        List<PossibleAnswer> possibleAnswers = possibleAnswerDao.getPossibleAnswersByQuestion(questionId);
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        List<String> leftItems = new ArrayList<>();
        List<String> rightItems = new ArrayList<>();
        Map<String, String> correctMatches = new HashMap<>();

        // Parse possible answers to create left and right items
        for (PossibleAnswer pa : possibleAnswers) {
            String text = pa.getPossibleAnswerText();
            if (leftItems.size() < possibleAnswers.size() / 2) {
                leftItems.add(text);
            } else {
                rightItems.add(text);
            }
        }

        // Parse correct answers to create matches
        for (CorrectAnswer ca : correctAnswers) {
            String match = ca.getAnswerText();
            if (match.contains(" - ")) {
                String[] parts = match.split(" - ", 2);
                if (parts.length == 2) {
                    correctMatches.put(parts[0].trim(), parts[1].trim());
                }
            }
        }

        return new MatchingQuestion(id, typeId, questionText, leftItems, rightItems, correctMatches);
    }

    private MultiSelectQuestion createMultiSelectQuestion(int id, int typeId, String questionText, long questionId) throws SQLException {
        List<PossibleAnswer> possibleAnswers = possibleAnswerDao.getPossibleAnswersByQuestion(questionId);
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        List<String> answerOptions = new ArrayList<>();
        for (PossibleAnswer pa : possibleAnswers) {
            answerOptions.add(pa.getPossibleAnswerText());
        }

        Set<String> correctAnswerSet = new HashSet<>();
        for (CorrectAnswer ca : correctAnswers) {
            correctAnswerSet.add(ca.getAnswerText());
        }

        return new MultiSelectQuestion(id, typeId, questionText, answerOptions, correctAnswerSet);
    }

    private MultiAnswer createMultiAnswer(int id, int typeId, String questionText, long questionId) throws SQLException {
        List<CorrectAnswer> correctAnswers = correctAnswerDao.getCorrectAnswersByQuestion(questionId);

        List<Set<String>> correctAnswersList = new ArrayList<>();

        // Group correct answers by match_order
        Map<Long, Set<String>> groupedAnswers = new HashMap<>();
        for (CorrectAnswer ca : correctAnswers) {
            Long order = ca.getMatchOrder() != null ? ca.getMatchOrder() : 1L;
            groupedAnswers.computeIfAbsent(order, k -> new HashSet<>()).add(ca.getAnswerText());
        }

        // Convert to list maintaining order
        for (long i = 1; i <= groupedAnswers.size(); i++) {
            Set<String> answerSet = groupedAnswers.get(i);
            if (answerSet != null) {
                correctAnswersList.add(answerSet);
            }
        }

        // If no grouped answers, create at least one set
        if (correctAnswersList.isEmpty()) {
            Set<String> defaultSet = new HashSet<>();
            for (CorrectAnswer ca : correctAnswers) {
                defaultSet.add(ca.getAnswerText());
            }
            correctAnswersList.add(defaultSet);
        }

        return new MultiAnswer(id, typeId, questionText, false, correctAnswersList); // sorted = false
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