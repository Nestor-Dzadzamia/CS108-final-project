import Models.CorrectAnswer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CorrectAnswersTests {
    private CorrectAnswer correctAnswer;

    @BeforeEach
    void setUp() {
        correctAnswer = new CorrectAnswer(1L, "Paris", 1L);
    }

    @Test
    void testConstructorWithoutId() {
        assertEquals(0, correctAnswer.getAnswerId());
        assertEquals(1L, correctAnswer.getQuestionId());
        assertEquals("Paris", correctAnswer.getAnswerText());
        assertEquals(1L, correctAnswer.getMatchOrder());
    }

    @Test
    void testFullConstructor() {
        CorrectAnswer fullAnswer = new CorrectAnswer(10L, 5L, "London", 2L);

        assertEquals(10L, fullAnswer.getAnswerId());
        assertEquals(5L, fullAnswer.getQuestionId());
        assertEquals("London", fullAnswer.getAnswerText());
        assertEquals(2L, fullAnswer.getMatchOrder());
    }

    @Test
    void testSettersAndGetters() {
        correctAnswer.setAnswerId(25L);
        correctAnswer.setQuestionId(15L);
        correctAnswer.setAnswerText("Berlin");
        correctAnswer.setMatchOrder(3L);

        assertEquals(25L, correctAnswer.getAnswerId());
        assertEquals(15L, correctAnswer.getQuestionId());
        assertEquals("Berlin", correctAnswer.getAnswerText());
        assertEquals(3L, correctAnswer.getMatchOrder());
    }

    @Test
    void testToString() {
        correctAnswer.setAnswerId(5L);
        correctAnswer.setQuestionId(10L);
        correctAnswer.setAnswerText("Rome");
        correctAnswer.setMatchOrder(1L);

        String expected = "CorrectAnswer{answerId=5, questionId=10, answerText='Rome', matchOrder=1}";
        assertEquals(expected, correctAnswer.toString());
    }

    @Test
    void testNullMatchOrder() {
        correctAnswer.setMatchOrder(null);
        assertNull(correctAnswer.getMatchOrder());
    }

    @Test
    void testMultipleCorrectAnswers() {
        // Test creating multiple correct answers for same question
        CorrectAnswer[] answers = {
                new CorrectAnswer(1L, "Paris", 1L),
                new CorrectAnswer(1L, "France", 2L),
                new CorrectAnswer(1L, "City of Light", 3L)
        };

        for (int i = 0; i < answers.length; i++) {
            assertEquals(1L, answers[i].getQuestionId());
            assertEquals((long) (i + 1), answers[i].getMatchOrder());
        }
    }

    @Test
    void testOrderlessAnswer() {
        // Test answer without specific order (for non-matching questions)
        CorrectAnswer orderless = new CorrectAnswer(1L, "Correct", null);

        assertEquals(1L, orderless.getQuestionId());
        assertEquals("Correct", orderless.getAnswerText());
        assertNull(orderless.getMatchOrder());
    }

    @Test
    void testCaseSensitiveAnswers() {
        correctAnswer.setAnswerText("JavaScript");
        assertEquals("JavaScript", correctAnswer.getAnswerText());

        correctAnswer.setAnswerText("javascript");
        assertEquals("javascript", correctAnswer.getAnswerText());
    }

    @Test
    void testNumericAnswers() {
        correctAnswer.setAnswerText("42");
        assertEquals("42", correctAnswer.getAnswerText());

        correctAnswer.setAnswerText("3.14159");
        assertEquals("3.14159", correctAnswer.getAnswerText());
    }
}