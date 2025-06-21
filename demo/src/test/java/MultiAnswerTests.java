import Questions.MultiAnswer;
import junit.framework.TestCase;

import java.util.*;

public class MultiAnswerTests extends TestCase {

    private List<Set<String>> createAnswerList(String[][] data) {
        List<Set<String>> answerList = new ArrayList<>();
        for (String[] group : data) {
            Set<String> set = new HashSet<>();
            for (String ans : group) {
                set.add(ans.trim().toLowerCase());
            }
            answerList.add(set);
        }
        return answerList;
    }

    // Test retrieval of correct answer sets from MultiAnswer
    public void testGetCorrectAnswersMultiple() {
        String[][] data = {
                {"USA", "United States"},
                {"Georgia", "Sakartvelo"}
        };
        MultiAnswer q = new MultiAnswer(1, 101, "Test question", false, createAnswerList(data));

        List<Set<String>> correct = q.getCorrectAnswersMultiple();

        // Check the size matches
        assertEquals(2, correct.size());

        // Check that each set contains all expected variations
        assertTrue(correct.get(0).contains("usa"));
        assertTrue(correct.get(0).contains("united states"));
        assertTrue(correct.get(1).contains("georgia"));
        assertTrue(correct.get(1).contains("sakartvelo"));
    }

    // Test scoring all correct in sorted mode
    public void testSortedAllCorrect() {
        String[][] data = {
                {"united states", "usa"},
                {"canada"},
                {"mexico"}
        };
        MultiAnswer q = new MultiAnswer(1, 101, "Name 3 countries", true, createAnswerList(data));
        List<String> answers = Arrays.asList("USA", "Canada", "Mexico");
        assertEquals(3, q.getScoreMultiple(answers));
    }

    // Test scoring some correct and some wrong in sorted mode
    public void testSortedSomeIncorrect() {
        String[][] data = {
                {"a"},
                {"b"},
                {"c"}
        };
        MultiAnswer q = new MultiAnswer(2, 102, "Give three letters", true, createAnswerList(data));
        List<String> answers = Arrays.asList("A", "wrong", "C");
        assertEquals(2, q.getScoreMultiple(answers));
    }

    // Test scoring with fewer answers than expected in sorted mode
    public void testSortedTooFewAnswers() {
        String[][] data = {
                {"a"},
                {"b"},
                {"c"}
        };
        MultiAnswer q = new MultiAnswer(4, 104, "Three letters", true, createAnswerList(data));
        List<String> answers = Arrays.asList("A");
        assertEquals(1, q.getScoreMultiple(answers));
    }

    // Test scoring all correct answers in unsorted mode
    public void testUnsortedAllCorrect() {
        String[][] data = {
                {"apple"},
                {"banana"},
                {"cherry"}
        };
        MultiAnswer q = new MultiAnswer(5, 105, "Fruits", false, createAnswerList(data));
        List<String> answers = Arrays.asList("Cherry", "Banana", "Apple");
        assertEquals(3, q.getScoreMultiple(answers));
    }

    // Test scoring duplicates in user answers in unsorted mode
    public void testUnsortedDuplicatesInAnswers() {
        String[][] data = {
                {"apple"},
                {"banana"},
                {"cherry"}
        };
        MultiAnswer q = new MultiAnswer(6, 106, "Fruits", false, createAnswerList(data));
        List<String> answers = Arrays.asList("Apple", "Apple", "Apple");
        assertEquals(1, q.getScoreMultiple(answers)); // Only matches one correct slot
    }

    // Test that too many answers in unsorted mode throws exception
    public void testUnsortedMoreAnswersThanCorrect() {
        String[][] data = {
                {"a"},
                {"b"}
        };
        MultiAnswer q = new MultiAnswer(7, 107, "Two letters", false, createAnswerList(data));
        List<String> answers = Arrays.asList("A", "B", "C", "D");
        try {
            q.getScoreMultiple(answers);
            fail("Expected IllegalArgumentException due to too many answers");
        } catch (IllegalArgumentException e) {
            // Test passes because exception was thrown
        }
    }

    // Test that extra whitespace in user answers is trimmed properly
    public void testUnsortedAnswerWithExtraWhitespace() {
        String[][] data = {
                {"hello"},
                {"world"}
        };
        MultiAnswer q = new MultiAnswer(8, 108, "Greetings", false, createAnswerList(data));
        List<String> answers = Arrays.asList("  hello  ", " WORLD ");
        assertEquals(2, q.getScoreMultiple(answers));
    }

    // Test scoring synonyms correctly in unsorted mode
    public void testUnsortedWithSynonyms() {
        String[][] data = {
                {"usa", "united states", "united states of america"},
                {"uk", "united kingdom"},
                {"uae", "united arab emirates"}
        };
        MultiAnswer q = new MultiAnswer(9, 109, "Name 3 countries", false, createAnswerList(data));
        List<String> answers = Arrays.asList("United Kingdom", "USA", "UAE");
        assertEquals(3, q.getScoreMultiple(answers));
    }

    // Test constructor rejects null correct answers list
    public void testConstructorRejectsNullList() {
        try {
            new MultiAnswer(10, 110, "Invalid", false, null);
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            // Pass
        }
    }

    // Test constructor rejects empty correct answers list
    public void testConstructorRejectsEmptyList() {
        try {
            new MultiAnswer(11, 111, "Invalid", false, new ArrayList<>());
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            // Pass
        }
    }

    // Test that getScore(String) throws UnsupportedOperationException
    public void testUnsupportedGetScore() {
        MultiAnswer q = new MultiAnswer(12, 112, "Unsupported", false, createAnswerList(new String[][]{{"a"}}));
        try {
            q.getScore("a");
            fail("Expected UnsupportedOperationException");
        } catch (UnsupportedOperationException e) {
            // Pass
        }
    }

    // Test that getCorrectAnswers() throws UnsupportedOperationException
    public void testUnsupportedGetCorrectAnswers() {
        MultiAnswer q = new MultiAnswer(13, 113, "Unsupported", false, createAnswerList(new String[][]{{"a"}}));
        try {
            q.getCorrectAnswers();
            fail("Expected UnsupportedOperationException");
        } catch (UnsupportedOperationException e) {
            // Pass
        }
    }

    // Test exact match scoring in sorted mode
    public void testSortedExactMatch() {
        String[][] data = { {"one"}, {"two"}, {"three"} };
        MultiAnswer q = new MultiAnswer(1, 101, "Numbers", true, createAnswerList(data));
        List<String> answers = List.of("one", "two", "three");
        assertEquals(3, q.getScoreMultiple(answers));
    }

    // Test scoring partial correct answers when order is wrong in sorted mode
    public void testSortedWrongOrder() {
        String[][] data = { {"one"}, {"two"}, {"three"} };
        MultiAnswer q = new MultiAnswer(2, 101, "Numbers", true, createAnswerList(data));
        List<String> answers = List.of("three", "two", "one");
        assertEquals(1, q.getScoreMultiple(answers));  // only "two" matches correct slot #1
    }

    // Test scoring all correct answers in any order in unsorted mode
    public void testUnsortedAnyOrder() {
        String[][] data = { {"one"}, {"two"}, {"three"} };
        MultiAnswer q = new MultiAnswer(3, 102, "Numbers", false, createAnswerList(data));
        List<String> answers = List.of("three", "two", "one");
        assertEquals(3, q.getScoreMultiple(answers));
    }

    // Test scoring duplicates in unsorted user answers
    public void testUnsortedDuplicateUserAnswers() {
        String[][] data = { {"one"}, {"two"}, {"three"} };
        MultiAnswer q = new MultiAnswer(4, 102, "Numbers", false, createAnswerList(data));
        List<String> answers = List.of("one", "one", "two");
        assertEquals(2, q.getScoreMultiple(answers)); // only two unique correct slots matched
    }

    // Test scoring synonyms in a single correct answer slot
    public void testSynonymsInSingleSlot() {
        String[][] data = { {"usa", "united states", "america"}, {"canada"} };
        MultiAnswer q = new MultiAnswer(5, 102, "Countries", false, createAnswerList(data));
        List<String> answers = List.of("United States", "Canada");
        assertEquals(2, q.getScoreMultiple(answers));
    }

    // Test scoring with empty user answer list
    public void testEmptyUserAnswers() {
        String[][] data = { {"a"} };
        MultiAnswer q = new MultiAnswer(6, 101, "Single letter", true, createAnswerList(data));
        List<String> answers = List.of();
        assertEquals(0, q.getScoreMultiple(answers));
    }

    // Test scoring with null user answer list throws exception
    public void testNullUserAnswers() {
        String[][] data = { {"a"} };
        MultiAnswer q = new MultiAnswer(7, 101, "Single letter", true, createAnswerList(data));
        try {
            q.getScoreMultiple(null);
            fail("Expected NullPointerException or IllegalArgumentException");
        } catch (Exception e) {
            // pass
        }
    }

    // Test exception on user answer list size mismatch in sorted mode
    public void testUserAnswersTooMany() {
        String[][] data = { {"a"}, {"b"} };
        MultiAnswer q = new MultiAnswer(8, 101, "Two letters", true, createAnswerList(data));
        List<String> answers = List.of("a", "b", "c");
        try {
            q.getScoreMultiple(answers);
            fail("Expected IllegalArgumentException for size mismatch");
        } catch (IllegalArgumentException e) {
            // pass
        }
    }

    // Test that getScore(String) is unsupported (again)
    public void testUnsupportedGetScoreSingle() {
        String[][] data = { {"a"} };
        MultiAnswer q = new MultiAnswer(9, 101, "Single letter", true, createAnswerList(data));
        try {
            q.getScore("a");
            fail("Expected UnsupportedOperationException");
        } catch (UnsupportedOperationException e) {
            // pass
        }
    }

    // Test trimming whitespace and case insensitivity in scoring
    public void testWhitespaceAndCaseInsensitivity() {
        String[][] data = { {"hello"} };
        MultiAnswer q = new MultiAnswer(11, 101, "Greeting", true, createAnswerList(data));
        List<String> answers = List.of("  HeLLo  ");
        assertEquals(1, q.getScoreMultiple(answers));
    }

    // Test partial correct answers scoring in unsorted mode
    public void testPartialCorrectAnswersUnsorted() {
        String[][] data = { {"red"}, {"blue"}, {"green"} };
        MultiAnswer q = new MultiAnswer(12, 102, "Colors", false, createAnswerList(data));
        List<String> answers = List.of("red", "yellow", "blue");
        assertEquals(2, q.getScoreMultiple(answers));
    }
}
