package Models.Questions;

import java.util.Set;

/**
 * Represents an abstract base class for different types of questions.
 * Each question has a unique identifier, a type identifier, and a question text.
 * Subclasses must implement methods to provide correct answers and scoring logic.
 */
public abstract class Question {
    private final int id;
    private final int question_type_id;
    private final String question;

    /**
     * Constructs a Question with the specified id, type, and text.
     * Validates that the ID and question type ID are positive integers,
     * and that the question text is not null or empty.
     *
     * @param id unique identifier for the question
     * @param question_type_id identifier for the type of question
     * @param question the text content of the question
     */
    public Question(int id, int question_type_id, String question) {
        if (question == null || question.trim().isEmpty()) {
            throw new IllegalArgumentException("Question text must not be null or empty.");
        }
        if (id <= 0) {
            throw new IllegalArgumentException("ID must be a positive integer.");
        }
        if (question_type_id <= 0) {
            throw new IllegalArgumentException("Question type ID must be a positive integer.");
        }
        this.question = question;
        this.id = id;
        this.question_type_id = question_type_id;
    }

    /**
     * Returns the text of the question.
     *
     * @return the question text
     */
    public String getQuestion() {
        return question;
    }

    /**
     * Returns a set of all acceptable correct answers for this question.
     *
     * @return a set containing correct answers as strings
     */
    public abstract Set<String> getCorrectAnswers();

    /**
     * Calculates the score awarded for a given answer.
     * The implementation defines how answers are evaluated and scored.
     *
     * @param answer the answer provided by a user
     * @return an integer score (e.g., 1 for correct, 0 for incorrect)
     */
    public abstract int getScore(String answer);

    /**
     * Returns the unique identifier of this question.
     *
     * @return the question ID
     */
    public int getId() {
        return id;
    }

    /**
     * Returns the type identifier of this question.
     *
     * @return the question type ID
     */
    public int getQuestionTypeId() {
        return question_type_id;
    }
}
