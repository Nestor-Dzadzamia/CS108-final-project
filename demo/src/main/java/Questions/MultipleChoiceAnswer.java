package Questions;

import java.util.List;
import java.util.Set;

/**
 * Represents a multiple-choice question where only one answer is correct.
 * Inherits from the abstract Question class.
 */
public class MultipleChoiceAnswer extends Question {
    private final List<String> possibleAnswers;
    private final int correctAnswerIndex;

    /**
     * Constructs a MultipleChoiceAnswer with the specified question details and answers.
     * Adjusts the correct answer index to be zero-based.
     *
     * @param id                 unique identifier for the question
     * @param question_type_id   identifier for the type of question
     * @param question           the text content of the question
     * @param possibleAnswers    a list of possible answer options
     * @param correctAnswerIndex the index (1-based) of the correct answer in the list
     */
    public MultipleChoiceAnswer(int id, int question_type_id, String question, List<String> possibleAnswers, int correctAnswerIndex) {
        super(id, question_type_id, question);
        this.possibleAnswers = possibleAnswers;
        this.correctAnswerIndex = correctAnswerIndex - 1;
    }

    /**
     * This method is not supported for single-answer questions.
     *
     * @throws IllegalCallerException always thrown to indicate unsupported operation
     */
    @Override
    public Set<String> getCorrectAnswers() {
        throw new IllegalCallerException("There is only one correct answer in the question, use getCorrectAnswer()");
    }

    /**
     * Returns the correct answer from the list of possible answers.
     *
     * @return the correct answer string
     */
    public String getCorrectAnswer() {
        return possibleAnswers.get(correctAnswerIndex);
    }

    /**
     * This method is not supported because the expected parameter should be an index, not a string.
     *
     * @param answer the answer as a string (invalid for this question type)
     * @throws IllegalArgumentException always thrown to indicate wrong parameter type
     */
    @Override
    public int getScore(String answer) {
        throw new IllegalArgumentException("Parameter should be index of answer starting from 1 (like 1, 2 or etc.)");
    }

    /**
     * Returns 1 if the selected answer index (1-based) is correct, otherwise returns 0.
     *
     * @param selectedIndex the selected answer index (1-based)
     * @return 1 if correct, 0 otherwise
     */
    public int getScore(int selectedIndex) {
        return selectedIndex - 1 == correctAnswerIndex ? 1 : 0;
    }
}
