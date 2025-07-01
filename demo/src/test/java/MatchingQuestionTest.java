import Questions.MatchingQuestion;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for the {@link MatchingQuestion} class.
 * This class verifies the correctness and robustness of the MatchingQuestion implementation,
 * including its scoring logic, input validation, and getter/setter behavior.
 * The tests cover scenarios such as assertion checks, correct and partial user answers,
 * null input handling, and accessors for question data.
 */
public class MatchingQuestionTest {
    private MatchingQuestion matchingQuestion;

    /**
     * Tests that certain methods throw UnsupportedOperationException
     * as expected (such as calling getScore(String) or getCorrectAnswers()).
     */
    @Test
    public void testAssertions() {
        matchingQuestion = new MatchingQuestion(1, 1, "Match each item on the left" +
                " with the correct item on the right.", null, null, null);

        assertThrows(UnsupportedOperationException.class, () -> matchingQuestion.getScore("dummy"));
        assertThrows(UnsupportedOperationException.class, () -> matchingQuestion.getCorrectAnswers());
    }

    /**
     * Tests Validity of Matching Question logic
     */
    @Test
    public void testValidity1() {
        List<String> leftItems = new ArrayList<>(Arrays.asList("Georgia", "Portugal", "Spain"));
        List<String> rightItems = new ArrayList<>(Arrays.asList("Tbilisi", "Lisbon", "Madrid"));
        Map<String, String> correctMatches = new HashMap<>();
        correctMatches.put("Georgia", "tbilisi");
        correctMatches.put("Portugal", "Lisbon");
        correctMatches.put("Spain", "Madrid");

        matchingQuestion = new MatchingQuestion(1, 1, "Match Countries with Capital cities", leftItems, rightItems, correctMatches);

        matchingQuestion.setLeftItems(leftItems);
        matchingQuestion.setRightItems(rightItems);
        matchingQuestion.setCorrectMatches(correctMatches);

        Map<String, String> userAnswers = new HashMap<>();
        userAnswers.put("Georgia", "tBilisi");
        userAnswers.put("Spain", "MadriD");

        assertEquals(2, matchingQuestion.getScore(userAnswers));
    }

    @Test
    public void testValidity2() {
        List<String> leftItems = new ArrayList<>(Arrays.asList("Jon Jones", "Michael Jordan", "Lionel Messi"));
        List<String> rightItems = new ArrayList<>(Arrays.asList("Mixed martial arts", "Basketball", "Football"));
        Map<String, String> correctMatches = new HashMap<>();
        correctMatches.put("Jon Jones", "Mixed martial arts");
        correctMatches.put("Michael Jordan", "Basketball");
        correctMatches.put("Lionel messi", "Football");

        matchingQuestion = new MatchingQuestion(1, 1, "Match Sportsmen to sport", leftItems, rightItems, correctMatches);

        assertEquals(0, matchingQuestion.getScore((Map<String, String>) null));
        assertEquals(1, matchingQuestion.getScore(new HashMap<String, String>() {{
            put("Jon Jones", "Mixed martial arts");
        }}));
    }


    /**
     * Tests the getter and setter methods for leftItems, rightItems, and correctMatches.
     * Ensures that the MatchingQuestion stores and retrieves these lists/maps as expected.
     */
    @Test
    public void testGetters() {
        matchingQuestion = new MatchingQuestion(1, 1, "Match each item on the left" +
                " with the correct item on the right.", null, null, null);

        assertNull(matchingQuestion.getCorrectMatches());
        assertNull(matchingQuestion.getLeftItems());
        assertNull(matchingQuestion.getRightItems());

        List<String> leftItems = new ArrayList<>(Arrays.asList("English", "Georgian", "Greek"));
        List<String> rightItems = new ArrayList<>(Arrays.asList("Hello", "Γειά σου", "გამარჯობა"));
        Map<String, String> correctMatches = new HashMap<>();
        correctMatches.put("English", "Hello");
        correctMatches.put("Georgian", "გამარჯობა");
        correctMatches.put("Greek", "Γειά σου");

        matchingQuestion.setLeftItems(leftItems);
        matchingQuestion.setRightItems(rightItems);
        matchingQuestion.setCorrectMatches(correctMatches);

        List<String> testLeftItems = matchingQuestion.getLeftItems();
        List<String> testrightItems = matchingQuestion.getRightItems();
        Map<String, String> testCorrectMatches = matchingQuestion.getCorrectMatches();

        assertEquals(leftItems, testLeftItems);
        assertEquals(rightItems, testrightItems);
        assertEquals(correctMatches, testCorrectMatches);
    }
}
