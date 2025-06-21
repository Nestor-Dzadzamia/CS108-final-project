package Questions;

import java.util.Collections;
import java.util.Set;

/**
 * Represents a free-response type question where users must type an answer,
 * and the system checks if it matches any of the acceptable answers.
 */
public class QuestionResponse extends Question {
    Set<String> correctAnswers;
    int maxScore;
    /**
     * Constructs a new QuestionResponse object.
     *
     * @param id               the unique ID of the question
     * @param question_type_id the type ID indicating question format
     * @param question         the text of the question
     * @param correctAnswers   the set of acceptable correct answers
     * @param maxScore         the maximum score a user can earn for a correct answer
     */

    public QuestionResponse(int id, int question_type_id, String question, Set<String> correctAnswers, int maxScore ){
        super(id,question_type_id,question);
        this.correctAnswers = correctAnswers;
        this.maxScore = maxScore;
    }

    /**
     * @return the set of correct answers, or {@code null} if none are defined
     */
    @Override
    public Set<String> getCorrectAnswers() {
        if(correctAnswers.isEmpty()) return null;
        return correctAnswers;
    }

    /**
     * Calculates and returns the score based on the given answer.
     * The comparison ignores case and non-alphanumeric characters.
     *
     * @param answer the user's submitted answer
     * @return the maximum score if the answer is correct, or 0 otherwise
     */
    @Override
    public int getScore(String answer) {
        String cleanedAnswer = normalize(answer);
        for (String correctAnswer : correctAnswers) {
            if (normalize(correctAnswer).equalsIgnoreCase(cleanedAnswer)) {
                return maxScore;
            }
        }
        return 0;
    }

    /**
     * Normalizes the input by removing non-alphanumeric characters and trimming whitespace
     *
     * @param input the input string
     * @return a normalized version of the string
     */
    private String normalize(String input) {
        if (input == null) return "";
        return input.replaceAll("[^a-zA-Z0-9]", "").trim();
    }
}

