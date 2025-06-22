import Questions.MultipleChoiceAnswer;
import junit.framework.TestCase;

import java.util.ArrayList;
import java.util.List;

public class MultipleChoiceAnswerTests extends TestCase {
    private MultipleChoiceAnswer mulChoiceQuestion;

    // Creates question with 5 possible answers: "Which symbol is A?" - 1) K  2)B  3)C  4)A  5)E.
    public void setUp() throws Exception {
        super.setUp();

        String question = "Which symbol is A?";

        List<String> answers = new ArrayList<>();
        answers.add("K");
        answers.add("B");
        answers.add("C");
        answers.add("A");
        answers.add("E");

        mulChoiceQuestion = new MultipleChoiceAnswer(1, 3, question, answers, 4);
    }

    // Test for checking selecting correct answer
    public void testSelectingCorrectAnswer() {
        int chosenIndex = 4;

        assertEquals(1, mulChoiceQuestion.getScore(chosenIndex));
    }

    // Test for checking selecting incorrect answer
    public void testSelectinginCorrectAnswer() {
        int chosenIndex = 2;

        assertEquals(0, mulChoiceQuestion.getScore(chosenIndex));
    }

    // Test for checking calling illegal function getCorrectAnswers() which returns set. it should return string
    public void testCallingIncorrectGetCorrectAnswersFunction() {
        try {
            mulChoiceQuestion.getCorrectAnswers();
            fail("Incorrect function calling, use getCorrectAnswer(), not getCorrectAnswers()");
        } catch (IllegalCallerException e) {
            // Test passes because exception was thrown
        }
    }

    // Test for checking getScore(String answer) where parameter must be an index
    public void testIncorrectParemeterInGetScore() {
        try {
            mulChoiceQuestion.getScore("A");
            fail("Parameter must be an integer");
        } catch (IllegalArgumentException e) {
            // Test passes because exception was thrown
        }
    }

    // This test checks if correct answer is returned right
    public void testCorrectAnswerReturned() {
        assertEquals("A", mulChoiceQuestion.getCorrectAnswer());
    }

}
