package Models.Questions;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * Represents a picture-response type question where the user
 * provides a text answer in response to an image.
 * The question includes a set of acceptable correct answers and a URL to the image.
 */
public class PictureResponse extends Question {

    private final Set<String> correctAnswers;
    private final String pictureUrl;

    /**
     * Constructs a PictureResponse question with specified id, type, question text,
     * a set of correct answers, and an absolute URL to the image.
     *
     * @param id unique identifier for the question
     * @param question_type_id identifier representing the type of question
     * @param question the question text to be displayed
     * @param correctAnswers set of valid correct answers (must not be null or empty)
     * @param pictureUrl absolute URL to the image associated with the question (must not be null or empty)
     * @throws IllegalArgumentException if correctAnswers is null or empty,
     *                                  or if pictureUrl is null or empty
     */
    public PictureResponse(int id, int question_type_id, String question, Set<String> correctAnswers, String pictureUrl) {
        super(id, question_type_id, question);
        if (correctAnswers == null || correctAnswers.isEmpty()) {
            throw new IllegalArgumentException("Correct answers must not be null or empty.");
        }
        if (pictureUrl == null || pictureUrl.isEmpty()) {
            throw new IllegalArgumentException("Picture URL must not be null or empty.");
        }
        this.correctAnswers = Collections.unmodifiableSet(new HashSet<>(correctAnswers));
        this.pictureUrl = pictureUrl;
    }

    /**
     * Returns an unmodifiable set of correct answers for this question.
     *
     * @return set of correct answers (case-insensitive)
     */
    @Override
    public Set<String> getCorrectAnswers() {
        return correctAnswers;
    }

    /**
     * Calculates the score for a given answer.
     * Compares the provided answer (case-insensitive, trimmed) against the correct answers.
     *
     * @param answer the user's answer to check
     * @return 1 if the answer matches any correct answer; 0 otherwise
     */
    @Override
    public int getScore(String answer) {
        if (answer == null) return 0;
        for (String correctAnswer : correctAnswers) {
            if (correctAnswer.equalsIgnoreCase(answer.trim())) {
                return 1;
            }
        }
        return 0;
    }

    /**
     * Returns the absolute URL of the image associated with this question.
     *
     * @return the picture URL string
     */
    public String getPictureUrl() {
        return pictureUrl;
    }
}
