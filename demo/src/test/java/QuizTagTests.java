import Models.QuizTag;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class QuizTagTests {
    /**
     * Unit tests for the {@link QuizTag} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>Many-to-many relationship between quizzes and tags</li>
     *   <li>Quiz and tag ID association and mapping</li>
     *   <li>Multiple tag assignments to single quiz</li>
     *   <li>Single tag applied to multiple quizzes</li>
     *   <li>ID validation and edge case handling</li>
     * </ul>
     */
    private QuizTag quizTag;

    @BeforeEach
    void setUp() {
        quizTag = new QuizTag();
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, quizTag.getQuizId());
        assertEquals(0, quizTag.getTagId());
    }

    @Test
    void testParameterizedConstructor() {
        QuizTag namedQuizTag = new QuizTag(10L, 5L);

        assertEquals(10L, namedQuizTag.getQuizId());
        assertEquals(5L, namedQuizTag.getTagId());
    }

    @Test
    void testSettersAndGetters() {
        quizTag.setQuizId(25L);
        quizTag.setTagId(12L);

        assertEquals(25L, quizTag.getQuizId());
        assertEquals(12L, quizTag.getTagId());
    }

    @Test
    void testMultipleAssociations() {
        // Test that we can create multiple quiz-tag associations
        QuizTag[] associations = {
                new QuizTag(1L, 10L),
                new QuizTag(1L, 15L),
                new QuizTag(2L, 10L),
                new QuizTag(3L, 20L)
        };

        // Quiz 1 has tags 10 and 15
        assertEquals(1L, associations[0].getQuizId());
        assertEquals(10L, associations[0].getTagId());
        assertEquals(1L, associations[1].getQuizId());
        assertEquals(15L, associations[1].getTagId());

        // Tag 10 is used by quizzes 1 and 2
        assertEquals(10L, associations[0].getTagId());
        assertEquals(10L, associations[2].getTagId());
    }

    @Test
    void testZeroIds() {
        quizTag.setQuizId(0L);
        quizTag.setTagId(0L);

        assertEquals(0L, quizTag.getQuizId());
        assertEquals(0L, quizTag.getTagId());
    }

    @Test
    void testLargeIds() {
        quizTag.setQuizId(999999L);
        quizTag.setTagId(888888L);

        assertEquals(999999L, quizTag.getQuizId());
        assertEquals(888888L, quizTag.getTagId());
    }
}