import Models.Message;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class MessageTests {
    private Message message;
    private Timestamp sentAt;

    @BeforeEach
    void setUp() {
        message = new Message();
        sentAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertNull(message.getMessageId());
        assertNull(message.getSenderId());
        assertNull(message.getReceiverId());
        assertNull(message.getMessageType());
        assertNull(message.getContent());
        assertFalse(message.isRead());
    }

    @Test
    void testParameterizedConstructor() {
        Message quickMessage = new Message(5L, 10L, "note", "Hello friend!");

        assertEquals(5L, quickMessage.getSenderId());
        assertEquals(10L, quickMessage.getReceiverId());
        assertEquals("note", quickMessage.getMessageType());
        assertEquals("Hello friend!", quickMessage.getContent());
        assertFalse(quickMessage.isRead());
    }

    @Test
    void testSettersAndGetters() {
        message.setMessageId(100L);
        message.setSenderId(15L);
        message.setReceiverId(25L);
        message.setMessageType("challenge");
        message.setContent("I challenge you to take this quiz!");
        message.setQuizId(50L);
        message.setFriendRequestId(75L);
        message.setSentAt(sentAt);
        message.setRead(true);
        message.setSenderName("John");
        message.setQuizTitle("Math Quiz");

        assertEquals(100L, message.getMessageId());
        assertEquals(15L, message.getSenderId());
        assertEquals(25L, message.getReceiverId());
        assertEquals("challenge", message.getMessageType());
        assertEquals("I challenge you to take this quiz!", message.getContent());
        assertEquals(50L, message.getQuizId());
        assertEquals(75L, message.getFriendRequestId());
        assertEquals(sentAt, message.getSentAt());
        assertTrue(message.isRead());
        assertEquals("John", message.getSenderName());
        assertEquals("Math Quiz", message.getQuizTitle());
    }

    @Test
    void testNoteMessage() {
        message.setMessageType("note");
        message.setContent("Great job on the quiz!");
        message.setRead(false);

        assertEquals("note", message.getMessageType());
        assertEquals("Great job on the quiz!", message.getContent());
        assertFalse(message.isRead());
    }

    @Test
    void testChallengeMessage() {
        message.setMessageType("challenge");
        message.setContent("Beat my score of 95%!");
        message.setQuizId(10L);
        message.setQuizTitle("Science Quiz");

        assertEquals("challenge", message.getMessageType());
        assertEquals("Beat my score of 95%!", message.getContent());
        assertEquals(10L, message.getQuizId());
        assertEquals("Science Quiz", message.getQuizTitle());
    }

    @Test
    void testFriendRequestMessage() {
        message.setMessageType("friend_request");
        message.setContent("wants to be your friend");
        message.setFriendRequestId(5L);

        assertEquals("friend_request", message.getMessageType());
        assertEquals("wants to be your friend", message.getContent());
        assertEquals(5L, message.getFriendRequestId());
    }

    @Test
    void testReadStatus() {
        assertFalse(message.isRead());

        message.setRead(true);
        assertTrue(message.isRead());

        message.setRead(false);
        assertFalse(message.isRead());
    }

    @Test
    void testLongContent() {
        String longContent = "This is a very long message that might be sent between friends " +
                "discussing their performance on various quizzes and sharing tips " +
                "for improvement. It could contain multiple sentences and detailed explanations.";

        message.setContent(longContent);
        assertEquals(longContent, message.getContent());
    }

    @Test
    void testEmptyContent() {
        message.setContent("");
        assertEquals("", message.getContent());
    }

    @Test
    void testNullOptionalFields() {
        message.setQuizId(null);
        message.setFriendRequestId(null);
        message.setSenderName(null);
        message.setQuizTitle(null);

        assertNull(message.getQuizId());
        assertNull(message.getFriendRequestId());
        assertNull(message.getSenderName());
        assertNull(message.getQuizTitle());
    }
}