import Models.Quiz;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class QuizTest {
    /**
     * Unit tests for the {@link Quiz} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>Quiz creation with title, description, and metadata</li>
     *   <li>Boolean configuration flags (randomized, multiple page, etc.)</li>
     *   <li>Time limits and category associations</li>
     *   <li>Submission tracking and creator information</li>
     *   <li>Default values and constructor variations</li>
     * </ul>
     */
    private Quiz quiz;
    private Timestamp createdAt;

    @BeforeEach
    void setUp() {
        quiz = new Quiz();
        createdAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertNull(quiz.getQuizTitle());
        assertNull(quiz.getDescription());
        assertEquals(0, quiz.getCreatedBy());
        assertFalse(quiz.isRandomized());
        assertFalse(quiz.isMultiplePage());
    }

    @Test
    void testParameterizedConstructor() {
        Quiz fullQuiz = new Quiz(1L, "Java Basics", "Test your Java knowledge",
                5L, true, false, true, false, createdAt, 2L, 30L, 150L);

        assertEquals(1L, fullQuiz.getQuizId());
        assertEquals("Java Basics", fullQuiz.getQuizTitle());
        assertEquals("Test your Java knowledge", fullQuiz.getDescription());
        assertEquals(5L, fullQuiz.getCreatedBy());
        assertTrue(fullQuiz.isRandomized());
        assertFalse(fullQuiz.isMultiplePage());
        assertTrue(fullQuiz.isImmediateCorrection());
        assertFalse(fullQuiz.isAllowPractice());
        assertEquals(createdAt, fullQuiz.getCreatedAt());
        assertEquals(2L, fullQuiz.getQuizCategory());
        assertEquals(30L, fullQuiz.getTotalTimeLimit());
        assertEquals(150L, fullQuiz.getSubmissionsNumber());
    }

    @Test
    void testSettersAndGetters() {
        quiz.setQuizId(10L);
        quiz.setQuizTitle("Python Fundamentals");
        quiz.setDescription("Learn Python basics");
        quiz.setCreatedBy(3L);
        quiz.setRandomized(true);
        quiz.setMultiplePage(true);
        quiz.setImmediateCorrection(false);
        quiz.setAllowPractice(true);
        quiz.setCreatedAt(createdAt);
        quiz.setQuizCategory(1L);
        quiz.setTotalTimeLimit(45L);
        quiz.setSubmissionsNumber(89L);

        assertEquals(10L, quiz.getQuizId());
        assertEquals("Python Fundamentals", quiz.getQuizTitle());
        assertEquals("Learn Python basics", quiz.getDescription());
        assertEquals(3L, quiz.getCreatedBy());
        assertTrue(quiz.isRandomized());
        assertTrue(quiz.isMultiplePage());
        assertFalse(quiz.isImmediateCorrection());
        assertTrue(quiz.isAllowPractice());
        assertEquals(createdAt, quiz.getCreatedAt());
        assertEquals(1L, quiz.getQuizCategory());
        assertEquals(45L, quiz.getTotalTimeLimit());
        assertEquals(89L, quiz.getSubmissionsNumber());
    }

    @Test
    void testBooleanDefaults() {
        // Test boolean setters with explicit values
        quiz.setRandomized(false);
        quiz.setMultiplePage(false);
        quiz.setImmediateCorrection(false);
        quiz.setAllowPractice(false);

        assertFalse(quiz.isRandomized());
        assertFalse(quiz.isMultiplePage());
        assertFalse(quiz.isImmediateCorrection());
        assertFalse(quiz.isAllowPractice());
    }

    @Test
    void testLongValues() {
        quiz.setQuizId(999999L);
        quiz.setCreatedBy(0L);
        quiz.setQuizCategory(0L);
        quiz.setTotalTimeLimit(0L);
        quiz.setSubmissionsNumber(0L);

        assertEquals(999999L, quiz.getQuizId());
        assertEquals(0L, quiz.getCreatedBy());
        assertEquals(0L, quiz.getQuizCategory());
        assertEquals(0L, quiz.getTotalTimeLimit());
        assertEquals(0L, quiz.getSubmissionsNumber());
    }
}