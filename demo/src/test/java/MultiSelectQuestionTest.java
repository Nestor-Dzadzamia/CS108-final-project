import Questions.MultiSelectQuestion;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the {@link MultiSelectQuestion} class.
 * This class validates the core functionality of MultiSelectQuestion, including:
 * Exception handling for unsupported operations
 * Correctness of scoring logic based on user input
 * Proper functioning of setter and getter methods
 * The tests ensure robustness against null input, validate partial and full correct answers,
 * and confirm data storage/retrieval via accessor methods.
 *
 */
public class MultiSelectQuestionTest {
    private MultiSelectQuestion question;

    // Simple and Default initialization of instance before each test call
    @BeforeEach
    public void init() {
        question = new MultiSelectQuestion(1, 1, "please mark US presidents",
                                           null, null);
    }

    @Test
    public void testAssertion() {
        assertThrows(UnsupportedOperationException.class, () -> question.getScore((String) null));
    }

    // Testing Validity of Question object Logic
    @Test
    public void testValidity() {
        List<String> possibleAnswers = new ArrayList<>(Arrays.asList("George Washington",
                "Joseph Stalin",
                "George Bush"));

        Set<String> answers = Set.of("George Washington", "George Bush");

        question.setPossibleAnswers(possibleAnswers);
        question.setAnswers(answers);

        assertEquals(0, question.getScore(Set.of("Joseph Stalin")));
        assertEquals(1, question.getScore(Set.of("George Bush", "Joseph Stalin")));
    }


    @Test
    public void testGettersSetters() {
        assertNull(question.getCorrectAnswers());
        assertNull(question.getPossibleAnswers());

        List<String> possibleAnswers = new ArrayList<>(Arrays.asList("Donald Trump",
                "Barack Obama",
                "George Bush"));

        Set<String> answers = Set.of("Donald Trump", "George Bush", "Barack Obama");

        question.setAnswers(answers);
        question.setPossibleAnswers(possibleAnswers);

        List<String> testPossibleAnswers = question.getPossibleAnswers();
        Set<String> testAnswers = question.getCorrectAnswers();

        assertEquals(testPossibleAnswers, possibleAnswers);
        assertEquals(testAnswers, answers);
    }
}
