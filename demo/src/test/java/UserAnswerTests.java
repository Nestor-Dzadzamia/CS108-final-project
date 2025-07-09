import Models.UserAnswer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class UserAnswerTests {
    private UserAnswer userAnswer;
    private Timestamp answeredAt;

    @BeforeEach
    void setUp() {
        userAnswer = new UserAnswer();
        answeredAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, userAnswer.getUserAnswerId());
        assertEquals(0, userAnswer.getSubmissionId());
        assertEquals(0, userAnswer.getQuestionId());
        assertNull(userAnswer.getAnswerText());
        assertFalse(userAnswer.isCorrect());
    }

    @Test
    void testParameterizedConstructor() {
        UserAnswer fullAnswer = new UserAnswer(1L, 5L, 10L, "Paris", true, answeredAt);

        assertEquals(1L, fullAnswer.getUserAnswerId());
        assertEquals(5L, fullAnswer.getSubmissionId());
        assertEquals(10L, fullAnswer.getQuestionId());
        assertEquals("Paris", fullAnswer.getAnswerText());
        assertTrue(fullAnswer.isCorrect());
        assertEquals(answeredAt, fullAnswer.getAnsweredAt());
    }

    @Test
    void testSettersAndGetters() {
        userAnswer.setUserAnswerId(100L);
        userAnswer.setSubmissionId(50L);
        userAnswer.setQuestionId(25L);
        userAnswer.setAnswerText("The capital of France");
        userAnswer.setCorrect(true);
        userAnswer.setAnsweredAt(answeredAt);

        assertEquals(100L, userAnswer.getUserAnswerId());
        assertEquals(50L, userAnswer.getSubmissionId());
        assertEquals(25L, userAnswer.getQuestionId());
        assertEquals("The capital of France", userAnswer.getAnswerText());
        assertTrue(userAnswer.isCorrect());
        assertEquals(answeredAt, userAnswer.getAnsweredAt());
    }

    @Test
    void testIncorrectAnswer() {
        userAnswer.setAnswerText("Berlin");
        userAnswer.setCorrect(false);

        assertEquals("Berlin", userAnswer.getAnswerText());
        assertFalse(userAnswer.isCorrect());
    }

    @Test
    void testEmptyAnswer() {
        userAnswer.setAnswerText("");
        userAnswer.setCorrect(false);

        assertEquals("", userAnswer.getAnswerText());
        assertFalse(userAnswer.isCorrect());
    }

    @Test
    void testNullAnswer() {
        userAnswer.setAnswerText(null);
        userAnswer.setCorrect(false);

        assertNull(userAnswer.getAnswerText());
        assertFalse(userAnswer.isCorrect());
    }
}