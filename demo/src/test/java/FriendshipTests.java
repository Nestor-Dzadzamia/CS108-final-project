import Models.Friendship;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class FriendshipTests {
    private Friendship friendship;
    private Timestamp friendsSince;

    @BeforeEach
    void setUp() {
        friendship = new Friendship();
        friendsSince = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, friendship.getUserId1());
        assertEquals(0, friendship.getUserId2());
        assertNull(friendship.getFriendsSince());
    }

    @Test
    void testParameterizedConstructor() {
        Friendship fullFriendship = new Friendship(5L, 10L, friendsSince);

        assertEquals(5L, fullFriendship.getUserId1());
        assertEquals(10L, fullFriendship.getUserId2());
        assertEquals(friendsSince, fullFriendship.getFriendsSince());
    }

    @Test
    void testSettersAndGetters() {
        friendship.setUserId1(15L);
        friendship.setUserId2(25L);
        friendship.setFriendsSince(friendsSince);

        assertEquals(15L, friendship.getUserId1());
        assertEquals(25L, friendship.getUserId2());
        assertEquals(friendsSince, friendship.getFriendsSince());
    }

    @Test
    void testBidirectionalFriendship() {
        // Test that friendship can be represented both ways
        Friendship friendship1 = new Friendship(1L, 2L, friendsSince);
        Friendship friendship2 = new Friendship(2L, 1L, friendsSince);

        // Both should represent the same friendship
        assertTrue((friendship1.getUserId1() == 1L && friendship1.getUserId2() == 2L) ||
                (friendship1.getUserId1() == 2L && friendship1.getUserId2() == 1L));
        assertTrue((friendship2.getUserId1() == 1L && friendship2.getUserId2() == 2L) ||
                (friendship2.getUserId1() == 2L && friendship2.getUserId2() == 1L));
    }

    @Test
    void testDifferentFriendshipTimes() {
        Timestamp oldTime = new Timestamp(System.currentTimeMillis() - 86400000L); // -1 day
        Timestamp newTime = new Timestamp(System.currentTimeMillis());

        Friendship oldFriendship = new Friendship(1L, 2L, oldTime);
        Friendship newFriendship = new Friendship(3L, 4L, newTime);

        assertTrue(oldFriendship.getFriendsSince().before(newFriendship.getFriendsSince()));
    }

    @Test
    void testSameUserIds() {
        // Although this shouldn't happen in practice, test edge case
        friendship.setUserId1(5L);
        friendship.setUserId2(5L);

        assertEquals(5L, friendship.getUserId1());
        assertEquals(5L, friendship.getUserId2());
    }

    @Test
    void testNullFriendsSince() {
        friendship.setUserId1(1L);
        friendship.setUserId2(2L);
        friendship.setFriendsSince(null);

        assertEquals(1L, friendship.getUserId1());
        assertEquals(2L, friendship.getUserId2());
        assertNull(friendship.getFriendsSince());
    }
}