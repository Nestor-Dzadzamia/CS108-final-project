import Models.Achievement;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class AchievementTests {
    /**
     * Unit tests for the {@link Achievement} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>Achievement creation with name, description, and icon</li>
     *   <li>Constructor variations with and without award timestamp</li>
     *   <li>Award timestamp tracking for user achievements</li>
     *   <li>Long description handling and empty string validation</li>
     *   <li>Icon URL management and metadata storage</li>
     * </ul>
     */
    private Achievement achievement;
    private Timestamp awardedAt;

    @BeforeEach
    void setUp() {
        achievement = new Achievement();
        awardedAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, achievement.getAchievementId());
        assertNull(achievement.getAchievementName());
        assertNull(achievement.getAchievementDescription());
        assertNull(achievement.getIconUrl());
        assertNull(achievement.getAwardedAt());
    }

    @Test
    void testConstructorWithoutAwardedAt() {
        Achievement simpleAchievement = new Achievement(1L, "First Quiz", "Created your first quiz", "icons/first.png");

        assertEquals(1L, simpleAchievement.getAchievementId());
        assertEquals("First Quiz", simpleAchievement.getAchievementName());
        assertEquals("Created your first quiz", simpleAchievement.getAchievementDescription());
        assertEquals("icons/first.png", simpleAchievement.getIconUrl());
        assertNull(simpleAchievement.getAwardedAt());
    }

    @Test
    void testFullConstructor() {
        Achievement fullAchievement = new Achievement(2L, "Quiz Master", "Created 10 quizzes", "icons/master.png", awardedAt);

        assertEquals(2L, fullAchievement.getAchievementId());
        assertEquals("Quiz Master", fullAchievement.getAchievementName());
        assertEquals("Created 10 quizzes", fullAchievement.getAchievementDescription());
        assertEquals("icons/master.png", fullAchievement.getIconUrl());
        assertEquals(awardedAt, fullAchievement.getAwardedAt());
    }

    @Test
    void testSettersAndGetters() {
        achievement.setAchievementId(5L);
        achievement.setAchievementName("Speed Demon");
        achievement.setAchievementDescription("Completed a quiz in under 1 minute");
        achievement.setIconUrl("icons/speed.png");
        achievement.setAwardedAt(awardedAt);

        assertEquals(5L, achievement.getAchievementId());
        assertEquals("Speed Demon", achievement.getAchievementName());
        assertEquals("Completed a quiz in under 1 minute", achievement.getAchievementDescription());
        assertEquals("icons/speed.png", achievement.getIconUrl());
        assertEquals(awardedAt, achievement.getAwardedAt());
    }

    @Test
    void testLongDescription() {
        String longDescription = "This achievement is awarded to users who have demonstrated exceptional " +
                "dedication to learning by completing over 100 quizzes with an average score " +
                "of 90% or higher. It represents mastery and commitment to continuous improvement.";

        achievement.setAchievementDescription(longDescription);
        assertEquals(longDescription, achievement.getAchievementDescription());
    }

    @Test
    void testEmptyStrings() {
        achievement.setAchievementName("");
        achievement.setAchievementDescription("");
        achievement.setIconUrl("");

        assertEquals("", achievement.getAchievementName());
        assertEquals("", achievement.getAchievementDescription());
        assertEquals("", achievement.getIconUrl());
    }
}