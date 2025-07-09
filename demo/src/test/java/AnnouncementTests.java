import Models.Announcement;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import static org.junit.jupiter.api.Assertions.*;

class AnnouncementTests {
    /**
     * Unit tests for the {@link Announcement} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>System announcement creation and management</li>
     *   <li>Active status tracking for announcement visibility</li>
     *   <li>Creator association and timestamp management</li>
     *   <li>Long message content and title validation</li>
     *   <li>Multiple announcement scenarios and null creator handling</li>
     * </ul>
     */
    private Announcement announcement;
    private Timestamp createdAt;

    @BeforeEach
    void setUp() {
        announcement = new Announcement();
        createdAt = new Timestamp(System.currentTimeMillis());
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, announcement.getAnnouncementId());
        assertNull(announcement.getTitle());
        assertNull(announcement.getMessage());
        assertNull(announcement.getCreatedBy());
        assertNull(announcement.getCreatedAt());
        assertFalse(announcement.getIsActive());
    }

    @Test
    void testParameterizedConstructor() {
        Announcement fullAnnouncement = new Announcement(1L, "System Update", "The system will be down for maintenance", 5L, createdAt, true);

        assertEquals(1L, fullAnnouncement.getAnnouncementId());
        assertEquals("System Update", fullAnnouncement.getTitle());
        assertEquals("The system will be down for maintenance", fullAnnouncement.getMessage());
        assertEquals(5L, fullAnnouncement.getCreatedBy());
        assertEquals(createdAt, fullAnnouncement.getCreatedAt());
        assertTrue(fullAnnouncement.getIsActive());
    }

    @Test
    void testSettersAndGetters() {
        announcement.setAnnouncementId(10L);
        announcement.setTitle("New Features");
        announcement.setMessage("We've added new quiz types and improved the interface!");
        announcement.setCreatedBy(3L);
        announcement.setCreatedAt(createdAt);
        announcement.setIsActive(true);

        assertEquals(10L, announcement.getAnnouncementId());
        assertEquals("New Features", announcement.getTitle());
        assertEquals("We've added new quiz types and improved the interface!", announcement.getMessage());
        assertEquals(3L, announcement.getCreatedBy());
        assertEquals(createdAt, announcement.getCreatedAt());
        assertTrue(announcement.getIsActive());
    }

    @Test
    void testActiveStatus() {
        announcement.setIsActive(true);
        assertTrue(announcement.getIsActive());

        announcement.setIsActive(false);
        assertFalse(announcement.getIsActive());
    }

    @Test
    void testNullCreatedBy() {
        // Test for deleted admin user
        announcement.setCreatedBy(null);
        assertNull(announcement.getCreatedBy());
    }

    @Test
    void testLongMessage() {
        String longMessage = "This is a very long announcement message that might contain detailed " +
                "information about system updates, new features, maintenance schedules, " +
                "policy changes, or other important information that users need to know about. " +
                "It could span multiple paragraphs and include various formatting.";

        announcement.setMessage(longMessage);
        assertEquals(longMessage, announcement.getMessage());
    }

    @Test
    void testShortTitle() {
        announcement.setTitle("Alert");
        assertEquals("Alert", announcement.getTitle());
    }

    @Test
    void testEmptyStrings() {
        announcement.setTitle("");
        announcement.setMessage("");

        assertEquals("", announcement.getTitle());
        assertEquals("", announcement.getMessage());
    }

    @Test
    void testMultipleAnnouncements() {
        Announcement[] announcements = {
                new Announcement(1L, "Welcome", "Welcome to our quiz platform!", 1L, createdAt, true),
                new Announcement(2L, "Maintenance", "Scheduled maintenance tonight", 1L, createdAt, true),
                new Announcement(3L, "Update", "New quiz categories added", 1L, createdAt, false)
        };

        assertTrue(announcements[0].getIsActive());
        assertTrue(announcements[1].getIsActive());
        assertFalse(announcements[2].getIsActive());
    }

    @Test
    void testTimestampComparison() {
        Timestamp earlierTime = new Timestamp(System.currentTimeMillis() - 86400000L); // -1 day
        Timestamp laterTime = new Timestamp(System.currentTimeMillis());

        Announcement earlyAnnouncement = new Announcement(1L, "Early", "Early message", 1L, earlierTime, true);
        Announcement lateAnnouncement = new Announcement(2L, "Late", "Late message", 1L, laterTime, true);

        assertTrue(earlyAnnouncement.getCreatedAt().before(lateAnnouncement.getCreatedAt()));
    }
}