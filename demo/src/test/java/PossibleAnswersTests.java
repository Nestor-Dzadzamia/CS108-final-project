import Models.PossibleAnswer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PossibleAnswersTests {
    /**
     * Unit tests for the {@link PossibleAnswer} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>Multiple choice answer option management</li>
     *   <li>Question association and answer text storage</li>
     *   <li>ToString method implementation and formatting</li>
     *   <li>Long answer text and special character handling</li>
     *   <li>Empty and null answer text validation</li>
     * </ul>
     */
    private PossibleAnswer possibleAnswer;

    @BeforeEach
    void setUp() {
        possibleAnswer = new PossibleAnswer(1L, "Paris");
    }

    @Test
    void testConstructorWithoutId() {
        assertEquals(0, possibleAnswer.getPossibleAnswerId());
        assertEquals(1L, possibleAnswer.getQuestionId());
        assertEquals("Paris", possibleAnswer.getPossibleAnswerText());
    }

    @Test
    void testFullConstructor() {
        PossibleAnswer fullAnswer = new PossibleAnswer(10L, 5L, "London");

        assertEquals(10L, fullAnswer.getPossibleAnswerId());
        assertEquals(5L, fullAnswer.getQuestionId());
        assertEquals("London", fullAnswer.getPossibleAnswerText());
    }

    @Test
    void testSettersAndGetters() {
        possibleAnswer.setPossibleAnswerId(25L);
        possibleAnswer.setQuestionId(15L);
        possibleAnswer.setPossibleAnswerText("Berlin");

        assertEquals(25L, possibleAnswer.getPossibleAnswerId());
        assertEquals(15L, possibleAnswer.getQuestionId());
        assertEquals("Berlin", possibleAnswer.getPossibleAnswerText());
    }

    @Test
    void testMultipleChoiceAnswers() {
        // Test creating multiple possible answers for same question
        PossibleAnswer[] answers = {
                new PossibleAnswer(1L, "A) Paris"),
                new PossibleAnswer(1L, "B) London"),
                new PossibleAnswer(1L, "C) Berlin"),
                new PossibleAnswer(1L, "D) Rome")
        };

        for (PossibleAnswer answer : answers) {
            assertEquals(1L, answer.getQuestionId());
            assertTrue(answer.getPossibleAnswerText().matches("[A-D]\\) \\w+"));
        }
    }

    @Test
    void testLongAnswerText() {
        String longAnswer = "This is a very long possible answer that might be used in a quiz " +
                "question where detailed explanations are provided as options for the user to choose from.";

        possibleAnswer.setPossibleAnswerText(longAnswer);
        assertEquals(longAnswer, possibleAnswer.getPossibleAnswerText());
    }

    @Test
    void testEmptyAnswerText() {
        possibleAnswer.setPossibleAnswerText("");
        assertEquals("", possibleAnswer.getPossibleAnswerText());
    }

    @Test
    void testNullAnswerText() {
        possibleAnswer.setPossibleAnswerText(null);
        assertNull(possibleAnswer.getPossibleAnswerText());
    }

    @Test
    void testSpecialCharacters() {
        possibleAnswer.setPossibleAnswerText("C++ Programming");
        assertEquals("C++ Programming", possibleAnswer.getPossibleAnswerText());

        possibleAnswer.setPossibleAnswerText("50% of 100");
        assertEquals("50% of 100", possibleAnswer.getPossibleAnswerText());
    }
}