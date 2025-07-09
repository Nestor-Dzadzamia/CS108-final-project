import Models.Tag;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TagTests {
    /**
     * Unit tests for the {@link Tag} class.
     * <p>
     * Covers full functionality and validation logic, including:
     * <ul>
     *   <li>Tag creation with ID and name properties</li>
     *   <li>Common tag name patterns and variations</li>
     *   <li>Multi-word tags and special character handling</li>
     *   <li>Empty tag names and edge case validation</li>
     *   <li>Tag labeling system for quiz organization</li>
     * </ul>
     */
    private Tag tag;

    @BeforeEach
    void setUp() {
        tag = new Tag();
    }

    @Test
    void testDefaultConstructor() {
        assertEquals(0, tag.getTagId());
        assertNull(tag.getTagName());
    }

    @Test
    void testParameterizedConstructor() {
        Tag namedTag = new Tag(1L, "beginner");

        assertEquals(1L, namedTag.getTagId());
        assertEquals("beginner", namedTag.getTagName());
    }

    @Test
    void testSettersAndGetters() {
        tag.setTagId(15L);
        tag.setTagName("advanced");

        assertEquals(15L, tag.getTagId());
        assertEquals("advanced", tag.getTagName());
    }

    @Test
    void testCommonTags() {
        String[] commonTags = {"easy", "medium", "hard", "popular", "new", "featured"};

        for (int i = 0; i < commonTags.length; i++) {
            Tag testTag = new Tag((long) i + 1, commonTags[i]);
            assertEquals(i + 1, testTag.getTagId());
            assertEquals(commonTags[i], testTag.getTagName());
        }
    }

    @Test
    void testMultiWordTag() {
        tag.setTagName("computer science");
        assertEquals("computer science", tag.getTagName());
    }

    @Test
    void testSpecialCharacters() {
        tag.setTagName("c++");
        assertEquals("c++", tag.getTagName());

        tag.setTagName("web-development");
        assertEquals("web-development", tag.getTagName());
    }

    @Test
    void testEmptyTagName() {
        tag.setTagName("");
        assertEquals("", tag.getTagName());
    }
}