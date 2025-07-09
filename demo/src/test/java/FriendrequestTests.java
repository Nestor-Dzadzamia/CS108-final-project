import Models.FriendRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class FriendrequestTests {
    private FriendRequest friendRequest;
    private Timestamp sentAt;

    @BeforeEach
    void setUp() {
        friendRequest = new FriendRequest();
        sentAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, friendRequest.getRequestId());
        assertEquals(0, friendRequest.getSenderId());
        assertEquals(0, friendRequest.getReceiverId());
        assertNull(friendRequest.getStatus());
        assertNull(friendRequest.getSentAt());
    }

    @Test
    void testParameterizedConstructor() {
        FriendRequest fullRequest = new FriendRequest(1L, 5L, 10L, "pending", sentAt);

        assertEquals(1L, fullRequest.getRequestId());
        assertEquals(5L, fullRequest.getSenderId());
        assertEquals(10L, fullRequest.getReceiverId());
        assertEquals("pending", fullRequest.getStatus());
        assertEquals(sentAt, fullRequest.getSentAt());
    }

    @Test
    void testSettersAndGetters() {
        friendRequest.setRequestId(100L);
        friendRequest.setSenderId(15L);
        friendRequest.setReceiverId(25L);
        friendRequest.setStatus("accepted");
        friendRequest.setSentAt(sentAt);

        assertEquals(100L, friendRequest.getRequestId());
        assertEquals(15L, friendRequest.getSenderId());
        assertEquals(25L, friendRequest.getReceiverId());
        assertEquals("accepted", friendRequest.getStatus());
        assertEquals(sentAt, friendRequest.getSentAt());
    }

    @Test
    void testValidStatuses() {
        String[] validStatuses = {"pending", "accepted", "rejected"};

        for (String status : validStatuses) {
            assertDoesNotThrow(() -> friendRequest.setStatus(status));
            assertEquals(status, friendRequest.getStatus());
        }
    }

    @Test
    void testInvalidStatus() {
        assertThrows(IllegalArgumentException.class, () -> {
            friendRequest.setStatus("invalid");
        });

        assertThrows(IllegalArgumentException.class, () -> {
            friendRequest.setStatus("PENDING");
        });

        assertThrows(IllegalArgumentException.class, () -> {
            friendRequest.setStatus("cancelled");
        });
    }

    @Test
    void testStatusTransitions() {
        // Test typical status flow
        friendRequest.setStatus("pending");
        assertEquals("pending", friendRequest.getStatus());

        friendRequest.setStatus("accepted");
        assertEquals("accepted", friendRequest.getStatus());
    }

    @Test
    void testRejectedStatus() {
        friendRequest.setStatus("rejected");
        assertEquals("rejected", friendRequest.getStatus());
    }

    @Test
    void testMultipleRequests() {
        // Test that multiple requests can exist between same users
        FriendRequest request1 = new FriendRequest(1L, 5L, 10L, "pending", sentAt);
        FriendRequest request2 = new FriendRequest(2L, 10L, 5L, "pending", sentAt);

        assertEquals(5L, request1.getSenderId());
        assertEquals(10L, request1.getReceiverId());
        assertEquals(10L, request2.getSenderId());
        assertEquals(5L, request2.getReceiverId());
    }
}