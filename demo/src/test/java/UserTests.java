import Models.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;

class UserTest {

    private User user;

    @BeforeEach
    void setUp() {
        user = new User();
    }

    @Test
    void testDefaultConstructor() {
        assertNull(user.getId());
        assertNull(user.getUsername());
        assertNull(user.getEmail());
        assertNull(user.getHashedPassword());
        assertNull(user.getSalt());
        assertNull(user.getTimeCreated());
        assertNull(user.getNumQuizzesCreated());
        assertNull(user.getNumQuizzesTaken());
        assertNull(user.getWasTop1());
        assertNull(user.getTakenPractice());
    }

    @Test
    void testParameterizedConstructor() {
        Long id = 1L;
        String username = "testuser";
        String email = "test@gmail.com";
        String hash = "hash123";
        String salt = "salt456";
        Timestamp timeCreated = Timestamp.valueOf("2023-01-01 10:00:00");
        Long quizzesCreated = 5L;
        Long quizzesTaken = 10L;
        Boolean wasTop1 = true;
        Boolean tookPractice = false;

        User newUser = new User(id, username, email, hash, salt, timeCreated,
                quizzesCreated, quizzesTaken, wasTop1, tookPractice);

        assertEquals(id, newUser.getId());
        assertEquals(username, newUser.getUsername());
        assertEquals(email, newUser.getEmail());
        assertEquals(hash, newUser.getHashedPassword());
        assertEquals(salt, newUser.getSalt());
        assertEquals(timeCreated, newUser.getTimeCreated());
        assertEquals(quizzesCreated, newUser.getNumQuizzesCreated());
        assertEquals(quizzesTaken, newUser.getNumQuizzesTaken());
        assertEquals(wasTop1, newUser.getWasTop1());
        assertEquals(tookPractice, newUser.getTakenPractice());
    }

    @Test
    void testSettersAndGetters() {
        Timestamp now = new Timestamp(System.currentTimeMillis());

        user.setId(42L);
        user.setUsername("alice");
        user.setEmail("alice@gmail.com");
        user.setHashedPassword("passhash");
        user.setSalt("saltvalue");
        user.setTimeCreated(now);
        user.setNumQuizzesCreated(3L);
        user.setNumQuizzesTaken(7L);
        user.setWasTop1(false);
        user.setTakenPractice(true);

        assertAll("User properties",
                () -> assertEquals(42L, user.getId()),
                () -> assertEquals("alice", user.getUsername()),
                () -> assertEquals("alice@gmail.com", user.getEmail()),
                () -> assertEquals("passhash", user.getHashedPassword()),
                () -> assertEquals("saltvalue", user.getSalt()),
                () -> assertEquals(now, user.getTimeCreated()),
                () -> assertEquals(3L, user.getNumQuizzesCreated()),
                () -> assertEquals(7L, user.getNumQuizzesTaken()),
                () -> assertFalse(user.getWasTop1()),
                () -> assertTrue(user.getTakenPractice())
        );
    }

    @Test
    void testNullValues() {
        user.setEmail(null);
        user.setUsername(null);
        user.setHashedPassword(null);
        user.setSalt(null);
        user.setTimeCreated(null);
        user.setNumQuizzesCreated(null);
        user.setNumQuizzesTaken(null);
        user.setWasTop1(null);
        user.setTakenPractice(null);

        assertNull(user.getEmail());
        assertNull(user.getUsername());
        assertNull(user.getHashedPassword());
        assertNull(user.getSalt());
        assertNull(user.getTimeCreated());
        assertNull(user.getNumQuizzesCreated());
        assertNull(user.getNumQuizzesTaken());
        assertNull(user.getWasTop1());
        assertNull(user.getTakenPractice());
    }

    @Test
    void testEdgeCaseValues() {
        user.setNumQuizzesCreated(0L);
        user.setNumQuizzesTaken(0L);
        user.setUsername("");
        user.setEmail("");
        user.setSalt("");
        user.setHashedPassword("");

        assertEquals(0L, user.getNumQuizzesCreated());
        assertEquals(0L, user.getNumQuizzesTaken());
        assertEquals("", user.getUsername());
        assertEquals("", user.getEmail());
        assertEquals("", user.getSalt());
        assertEquals("", user.getHashedPassword());
    }
}
