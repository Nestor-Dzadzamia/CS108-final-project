package Models.Questions;

import java.util.Set;

/**
 * This class shares the same methods and variables as QuestionResponse,
 * with the only difference being the way the question is formulated.
 */
public class FillInTheBlank extends QuestionResponse{

    /**
     * Constructs a new FillInTheBlank object.
     * Question must contain at least one blank (_) character
     *
     * @param id               the unique ID of the question
     * @param question_type_id the type ID indicating question format
     * @param question         the text of the question
     * @param correctAnswers   the set of acceptable correct answers
     * @param maxScore         the maximum score a user can earn for a correct answer
     * @throws IllegalArgumentException if the question does not contain at least one blank ('_')
     */
    public FillInTheBlank(int id, int question_type_id, String question, Set<String> correctAnswers, int maxScore) {
        super(id, question_type_id, validateQuestion(question), correctAnswers, maxScore);
    }

    private static String validateQuestion(String question) {
        if (question == null || !question.contains("_")) {
            throw new IllegalArgumentException("Question must contain at least one blank (_) character.");
        }
        return question;
    }
}
