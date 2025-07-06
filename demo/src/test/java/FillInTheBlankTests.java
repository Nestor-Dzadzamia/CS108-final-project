import Models.Questions.Question;
import Models.Questions.FillInTheBlank;
import Models.Questions.QuestionResponse;
import org.junit.jupiter.api.Test;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
/**
 * Unit tests for the {@link FillInTheBlank} class.
 * <p>
 * Covers full functionality and validation logic, including:
 * <ul>
 *   <li>Basic scoring and correct answer matching</li>
 *   <li>Validation of question formatting (presence of underscore)</li>
 *   <li>Exception handling from parent {@link QuestionResponse} and {@link Question}</li>
 *   <li>Multiple question instances with varying inputs</li>
 * </ul>
 */
public class FillInTheBlankTests {

    @Test
    void testEmpty() {
        Set<String> correctAnswers = new HashSet<>();
        FillInTheBlank question = new FillInTheBlank(77, 2, "empty_", correctAnswers, 1);
        assertEquals(0, question.getScore("empty"));
        assertNull(question.getCorrectAnswers());
    }

    @Test
    void testValidFillInTheBlank() {
        Set<String> correctAnswers = Set.of("Pablo Picasso", "luka modric");

        FillInTheBlank q = new FillInTheBlank(10, 2, "The best artist is _", correctAnswers, 5);

        assertEquals(10, q.getId());
        assertEquals(2, q.getQuestionTypeId());
        assertEquals("The best artist is _", q.getQuestion());

        assertEquals(correctAnswers, q.getCorrectAnswers());
        assertEquals(5, q.getScore("LUKA MODRIC"));
        assertEquals(0, q.getScore("Pedri"));
    }
    @Test
    void testMultipleCorrectAnswers() {
        Set<String> correctAnswers = new HashSet<>();
        correctAnswers.add("Guram Kutateladze");
        correctAnswers.add("The Georgian Gladiator");

        FillInTheBlank question = new FillInTheBlank(2, 2, "The most underrated Georgian UFC fighter is _", correctAnswers, 2);

        assertNotEquals("Who is the most underrated Georgian UFC fighter?", question.getQuestion());
        assertEquals(2, question.getScore("GURAM KUTATELADZE"));
        assertEquals(0, question.getScore(null));
        assertEquals(0, question.getScore("Ilia Topuria"));
    }
    @Test
    void testExceptions() {
        IllegalArgumentException ex1 = assertThrows(IllegalArgumentException.class, () -> {
            new FillInTheBlank(1, 2, null, new HashSet<>(Collections.singletonList("SIUU")), 5);
        });
        assertEquals("Question must contain at least one blank (_) character.", ex1.getMessage());

        assertDoesNotThrow(() -> {
            FillInTheBlank question = new FillInTheBlank(1, 2, "_", Set.of("SIUU"), 5);
            assertEquals("_", question.getQuestion());
        });
        IllegalArgumentException ex3 = assertThrows(IllegalArgumentException.class, () ->
                new QuestionResponse(1, 2, null, Set.of("SIUU"), 3)
        );
        assertEquals("Question text must not be null or empty.", ex3.getMessage());
        IllegalArgumentException ex4 = assertThrows(IllegalArgumentException.class, () ->
                new QuestionResponse(1, 2, "   ", Set.of("SIUU"), 3)
        );
        assertEquals("Question text must not be null or empty.", ex4.getMessage());
        IllegalArgumentException ex5 = assertThrows(IllegalArgumentException.class, () -> {
            new FillInTheBlank(1, 2, "NO BLANKS", new HashSet<>(Collections.singletonList("SIUU")), 5);
        });
        assertEquals("Question must contain at least one blank (_) character.", ex1.getMessage());
    }

    @Test
    void testInvalidIdException() {
        Exception ex1 = assertThrows(IllegalArgumentException.class, () ->
                new FillInTheBlank(0, 2, "Who is _", Set.of("any"), 3)
        );
        assertEquals("ID must be a positive integer.", ex1.getMessage());

        Exception ex2 = assertThrows(IllegalArgumentException.class, () ->
                new FillInTheBlank(1, -2, "Who is _", Set.of("any"), 3)
        );
        assertEquals("Question type ID must be a positive integer.", ex2.getMessage());
    }

    @Test
    void testMultipleQuestions() {
        Set<String> firstCorrectAnswers = new HashSet<>();
        firstCorrectAnswers.add("Machine");
        firstCorrectAnswers.add("Best 135");

        Set<String> secondCorrectAnswers = new HashSet<>();
        secondCorrectAnswers.add("khinkali");
        secondCorrectAnswers.add("Bebos kampoti");
        secondCorrectAnswers.add("mom's cooking");

        FillInTheBlank firstQuestion = new FillInTheBlank(3, 2, "Merab Dvalishvili fights like a _", firstCorrectAnswers, 9);
        FillInTheBlank secondQuestion = new FillInTheBlank(4, 2, "What does Ilia Topuria eat before every fight? _", secondCorrectAnswers, 9);

        assertEquals(0, secondQuestion.getScore("machine"));
        assertEquals(0, firstQuestion.getScore("khinkali"));
        assertEquals(9, secondQuestion.getScore("KHINKALI"));

        assertEquals(firstQuestion.getQuestionTypeId(), secondQuestion.getQuestionTypeId());
        assertNotEquals(firstQuestion.getId(), secondQuestion.getId());
    }

}