package Questions;

import java.util.List;
import java.util.Set;

/**
 * Represents a multiple-answer question where users must provide several responses.
 * Each response may have multiple acceptable variations (e.g., synonyms).
 * Scoring behavior can depend on whether the answers must be in a specific order.
 *
 * <p>
 * Each expected answer slot is represented as a Set of valid answers.
 * For unordered questions, more valid answers may exist than the number of required answers.
 * All comparisons are case-insensitive and ignore leading/trailing whitespace.
 * </p>
 */
public class MultiAnswer extends Question {

    private final List<Set<String>> correctAnswers;
    private final boolean isSorted;

    /**
     * Constructs a MultiAnswer question with the specified attributes.
     *
     * @param id               the unique identifier for the question
     * @param question_type_id the identifier representing the question type
     * @param question         the textual content of the question
     * @param sorted           true if the answers must appear in a specific order, false if order is irrelevant
     * @param correctAnswers   a list of acceptable answers; each position is a set of valid synonyms
     *                         (must be lowercased and trimmed prior to being passed in)
     * @throws IllegalArgumentException if correctAnswers is null or empty
     */
    public MultiAnswer(int id, int question_type_id, String question, boolean sorted, List<Set<String>> correctAnswers) {
        super(id, question_type_id, question);
        if (correctAnswers == null || correctAnswers.isEmpty()) {
            throw new IllegalArgumentException("Correct answers must not be null or empty.");
        }
        this.correctAnswers = correctAnswers;
        this.isSorted = sorted;
    }

    /**
     * Unsupported for MultiAnswer questions.
     * Use {@link #getCorrectAnswersMultiple()} instead.
     *
     * @throws UnsupportedOperationException always
     */
    @Override
    public Set<String> getCorrectAnswers() {
        throw new UnsupportedOperationException("Use getCorrectAnswersMultiple() for multi-answer questions.");
    }

    /**
     * Unsupported for MultiAnswer questions.
     * Use {@link #getScoreMultiple(List)} instead.
     *
     * @throws UnsupportedOperationException always
     */
    @Override
    public int getScore(String answer) {
        throw new UnsupportedOperationException("Use getScoreMultiple() for multi-answer questions.");
    }

    /**
     * Returns the list of valid answers for this question.
     * Each list index corresponds to one expected answer slot,
     * and each set contains acceptable answer variations.
     *
     * @return a list of sets containing valid answers
     */
    public List<Set<String>> getCorrectAnswersMultiple() {
        return correctAnswers;
    }

    /**
     * Calculates the score based on a list of user-provided answers.
     * Comparison is case-insensitive and ignores extra whitespace.
     *
     * <ul>
     *   <li>If {@code isSorted} is true, answers are matched positionally.</li>
     *   <li>If {@code isSorted} is false, answers are matched in any order, with each correct slot matched at most once.</li>
     * </ul>
     *
     * @param answers the list of user-submitted answers
     * @return the total number of correct matches (between 0 and correctAnswers.size())
     */
    public int getScoreMultiple(List<String> answers) {
        if(answers.size() > correctAnswers.size()) {throw new IllegalArgumentException("User cannot provide more answers than actual correct answers.");}
        int result = 0;
        if(isSorted) {
            for(int i = 0; i < answers.size(); i++) {
                if(correctAnswers.get(i).contains(answers.get(i).trim().toLowerCase())) result++;
            }
        } else {
            boolean[] used = new boolean[correctAnswers.size()];
            for(int i = 0; i < answers.size(); i++) {
                for(int j = 0; j < correctAnswers.size(); j++) {
                    if(!used[j] && correctAnswers.get(j).contains(answers.get(i).trim().toLowerCase())) {
                        result++;
                        used[j] = true;
                    }
                }
            }
        }
        return result;
    }
}