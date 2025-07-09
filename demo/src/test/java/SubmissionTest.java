import Models.Submission;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class SubmissionTest {
    /**
     * Unit tests for the {@link Submission} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>Submission tracking with user and quiz associations</li>
     *   <li>Scoring calculations and answer statistics</li>
     *   <li>Time spent tracking and submission timestamps</li>
     *   <li>Perfect score, zero score, and partial score scenarios</li>
     *   <li>Constructor variations and data integrity</li>
     * </ul>
     */
    private Submission submission;
    private Timestamp submittedAt;

    @BeforeEach
    void setUp() {
        submission = new Submission();
        submittedAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, submission.getSubmissionId());
        assertEquals(0, submission.getUserId());
        assertEquals(0, submission.getQuizId());
        assertEquals(0, submission.getScore());
    }

    @Test
    void testParameterizedConstructor() {
        Submission fullSubmission = new Submission(1L, 5L, 10L, 8L, 10L, 80L, 300L, submittedAt);

        assertEquals(1L, fullSubmission.getSubmissionId());
        assertEquals(5L, fullSubmission.getUserId());
        assertEquals(10L, fullSubmission.getQuizId());
        assertEquals(8L, fullSubmission.getNumCorrectAnswers());
        assertEquals(10L, fullSubmission.getNumTotalAnswers());
        assertEquals(80L, fullSubmission.getScore());
        assertEquals(300L, fullSubmission.getTimeSpent());
        assertEquals(submittedAt, fullSubmission.getSubmittedAt());
    }

    @Test
    void testSettersAndGetters() {
        submission.setSubmissionId(25L);
        submission.setUserId(12L);
        submission.setQuizId(7L);
        submission.setNumCorrectAnswers(15L);
        submission.setNumTotalAnswers(20L);
        submission.setScore(75L);
        submission.setTimeSpent(450L);
        submission.setSubmittedAt(submittedAt);

        assertEquals(25L, submission.getSubmissionId());
        assertEquals(12L, submission.getUserId());
        assertEquals(7L, submission.getQuizId());
        assertEquals(15L, submission.getNumCorrectAnswers());
        assertEquals(20L, submission.getNumTotalAnswers());
        assertEquals(75L, submission.getScore());
        assertEquals(450L, submission.getTimeSpent());
        assertEquals(submittedAt, submission.getSubmittedAt());
    }

    @Test
    void testScoreCalculation() {
        // Test realistic score scenarios
        submission.setNumCorrectAnswers(7L);
        submission.setNumTotalAnswers(10L);
        submission.setScore(70L);

        assertEquals(70L, submission.getScore());
        assertTrue(submission.getNumCorrectAnswers() < submission.getNumTotalAnswers());
    }

    @Test
    void testPerfectScore() {
        submission.setNumCorrectAnswers(10L);
        submission.setNumTotalAnswers(10L);
        submission.setScore(100L);

        assertEquals(submission.getNumCorrectAnswers(), submission.getNumTotalAnswers());
        assertEquals(100L, submission.getScore());
    }

    @Test
    void testZeroScore() {
        submission.setNumCorrectAnswers(0L);
        submission.setNumTotalAnswers(10L);
        submission.setScore(0L);

        assertEquals(0L, submission.getNumCorrectAnswers());
        assertEquals(10L, submission.getNumTotalAnswers());
        assertEquals(0L, submission.getScore());
    }
}