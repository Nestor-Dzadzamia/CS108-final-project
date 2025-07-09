import Models.UserAchievement;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class UserAchievementTests {
    /**
     * Unit tests for the {@link UserAchievement} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>User-achievement association tracking</li>
     *   <li>Award timestamp management and recording</li>
     *   <li>Multiple achievements per user scenarios</li>
     *   <li>Same achievement awarded to multiple users</li>
     *   <li>Null timestamp handling and edge cases</li>
     * </ul>
     */
    private UserAchievement userAchievement;
    private Timestamp awardedAt;

    @BeforeEach
    void setUp() {
        userAchievement = new UserAchievement();
        awardedAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, userAchievement.getUserId());
        assertEquals(0, userAchievement.getAchievementId());
        assertNull(userAchievement.getAwardedAt());
    }

    @Test
    void testParameterizedConstructor() {
        UserAchievement fullUserAchievement = new UserAchievement(5L, 10L, awardedAt);

        assertEquals(5L, fullUserAchievement.getUserId());
        assertEquals(10L, fullUserAchievement.getAchievementId());
        assertEquals(awardedAt, fullUserAchievement.getAwardedAt());
    }

    @Test
    void testSettersAndGetters() {
        userAchievement.setUserId(15L);
        userAchievement.setAchievementId(25L);
        userAchievement.setAwardedAt(awardedAt);

        assertEquals(15L, userAchievement.getUserId());
        assertEquals(25L, userAchievement.getAchievementId());
        assertEquals(awardedAt, userAchievement.getAwardedAt());
    }

    @Test
    void testMultipleAchievements() {
        // Test that a user can have multiple achievements
        Timestamp time1 = new Timestamp(System.currentTimeMillis());
        Timestamp time2 = new Timestamp(System.currentTimeMillis() + 86400000); // +1 day

        UserAchievement achievement1 = new UserAchievement(1L, 5L, time1);
        UserAchievement achievement2 = new UserAchievement(1L, 10L, time2);

        assertEquals(1L, achievement1.getUserId());
        assertEquals(1L, achievement2.getUserId());
        assertEquals(5L, achievement1.getAchievementId());
        assertEquals(10L, achievement2.getAchievementId());
        assertNotEquals(achievement1.getAwardedAt(), achievement2.getAwardedAt());
    }

    @Test
    void testSameAchievementMultipleUsers() {
        // Test that same achievement can be awarded to multiple users
        UserAchievement user1Achievement = new UserAchievement(1L, 5L, awardedAt);
        UserAchievement user2Achievement = new UserAchievement(2L, 5L, awardedAt);

        assertEquals(5L, user1Achievement.getAchievementId());
        assertEquals(5L, user2Achievement.getAchievementId());
        assertNotEquals(user1Achievement.getUserId(), user2Achievement.getUserId());
    }

    @Test
    void testNullAwardedAt() {
        userAchievement.setUserId(1L);
        userAchievement.setAchievementId(1L);
        userAchievement.setAwardedAt(null);

        assertEquals(1L, userAchievement.getUserId());
        assertEquals(1L, userAchievement.getAchievementId());
        assertNull(userAchievement.getAwardedAt());
    }
}