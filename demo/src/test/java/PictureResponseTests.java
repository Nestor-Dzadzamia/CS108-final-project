import Models.Questions.PictureResponse;
import junit.framework.TestCase;
import java.util.Set;

public class PictureResponseTests extends TestCase {

    private PictureResponse question;

    // Creates PictureResponse class object for specific question
    @Override
    protected void setUp() throws Exception {
        super.setUp();
        Set<String> answers = Set.of("Lincoln", "Abraham Lincoln");
        question = new PictureResponse(
                1,
                1,
                "Who's in the picture?",
                answers,
                "http://example.com/lincoln.jpg"
        );
    }

    // Checks score when exact correct answer is given
    public void testCorrectAnswerExactMatch() {
        assertEquals(1, question.getScore("Lincoln"));
    }

    // Checks score when case-insensitive correct answer is given
    public void testCorrectAnswerCaseInsensitive() {
        assertEquals(1, question.getScore("abraham lincoln"));
    }

    // Checks score when correct answer with blank spaces is given
    public void testCorrectAnswerWithWhitespace() {
        assertEquals(1, question.getScore("  Lincoln  "));
    }

    // Checks score for incorrect answer
    public void testIncorrectAnswer() {
        assertEquals(0, question.getScore("George Washington"));
    }

    // Checks score for null answer
    public void testNullAnswer() {
        assertEquals(0, question.getScore(null));
    }

    // Checks score for empty answer
    public void testEmptyAnswer() {
        assertEquals(0, question.getScore(""));
    }

    // Checks getter for URL
    public void testGetPictureUrl() {
        assertEquals("http://example.com/lincoln.jpg", question.getPictureUrl());
    }

    // Checks Question text
    public void testGetQuestionText() {
        assertEquals("Who's in the picture?", question.getQuestion());
    }

    // Checks number of all correct answers
    public void testGetCorrectAnswersSize() {
        assertEquals(2, question.getCorrectAnswers().size());
    }

    // Checks whether correct answers set is immutable
    public void testImmutableCorrectAnswersSet() {
        try {
            question.getCorrectAnswers().add("New Answer");
            fail("Expected UnsupportedOperationException");
        } catch (UnsupportedOperationException e) {
            // pass
        }
    }

    // Checks constructor throws when null answers are given
    public void testConstructorWithNullAnswers() {
        try {
            new PictureResponse(2, 1, "Test", null, "http://example.com/test.jpg");
            fail("Expected IllegalArgumentException for null answers");
        } catch (IllegalArgumentException e) {
            // pass
        }
    }

    // Checks constructor throws when empty answer set is given
    public void testConstructorWithEmptyAnswers() {
        try {
            new PictureResponse(3, 1, "Test", Set.of(), "http://example.com/test.jpg");
            fail("Expected IllegalArgumentException for empty answers");
        } catch (IllegalArgumentException e) {
            // pass
        }
    }

    // Checks constructor throws when null URL is given
    public void testConstructorWithNullUrl() {
        try {
            new PictureResponse(4, 1, "Test", Set.of("answer"), null);
            fail("Expected IllegalArgumentException for null URL");
        } catch (IllegalArgumentException e) {
            // pass
        }
    }

    // Checks constructor throws when empty URL is given
    public void testConstructorWithEmptyUrl() {
        try {
            new PictureResponse(5, 1, "Test", Set.of("answer"), "");
            fail("Expected IllegalArgumentException for empty URL");
        } catch (IllegalArgumentException e) {
            // pass
        }
    }

    // Checks that ID and question type ID are correctly returned
    public void testGetIdAndQuestionTypeId() {
        assertEquals(1, question.getId());
        assertEquals(1, question.getQuestionTypeId());
    }

    // Checks score when answer has extra spaces and mixed casing
    public void testScoreWithAnswerContainingExtraSpacesAndMixedCase() {
        assertEquals(1, question.getScore("  aBrAhAm LiNcOlN "));
    }

    // Checks score when answer contains special characters
    public void testScoreWithAnswerContainingSpecialCharacters() {
        // This assumes special characters cause a mismatch
        assertEquals(0, question.getScore("Lincoln!"));
    }

    // Checks score when a partial (substring) answer is given
    public void testScoreWithAnswerSubstring() {
        assertEquals(0, question.getScore("Abra"));
    }

    // Checks that correct answers set cannot be cleared
    public void testCorrectAnswersSetIsUnmodifiable() {
        Set<String> answers = question.getCorrectAnswers();
        try {
            answers.clear();
            fail("Expected UnsupportedOperationException when clearing set");
        } catch (UnsupportedOperationException e) {
            // expected
        }
    }

    // Checks equality of two PictureResponse objects with same content
    public void testQuestionObjectEquality() {
        Set<String> answers = Set.of("Lincoln", "Abraham Lincoln");
        PictureResponse sameQuestion = new PictureResponse(1, 1, "Who's in the picture?", answers, "http://example.com/lincoln.jpg");
        assertEquals(question.getQuestion(), sameQuestion.getQuestion());
        assertEquals(question.getPictureUrl(), sameQuestion.getPictureUrl());
        assertEquals(question.getCorrectAnswers(), sameQuestion.getCorrectAnswers());
    }

    // Checks score when answer has tab characters around it
    public void testScoreWithAnswerHavingLeadingTrailingTabs() {
        assertEquals(1, question.getScore("\tLincoln\t"));
    }

    // Checks score behavior with accented characters and locale differences
    public void testScoreWithAnswerDifferentLocale() {
        Set<String> answers = Set.of("Café");
        PictureResponse q = new PictureResponse(10, 1, "Name the place", answers, "http://example.com/cafe.jpg");
        assertEquals(1, q.getScore("café"));      // same accent, lower case
        assertEquals(0, q.getScore("cafe"));      // missing accent, should fail
    }
}
