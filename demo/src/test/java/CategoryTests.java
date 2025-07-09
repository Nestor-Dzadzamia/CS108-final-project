import Models.Category;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CategoryTests {
    private Category category;

    @BeforeEach
    void setUp() {
        category = new Category("Science");
    }

    @Test
    void testConstructorWithName() {
        assertEquals("Science", category.getCategoryName());
        assertEquals(0, category.getCategoryId()); // Default value
    }

    @Test
    void testFullConstructor() {
        Category fullCategory = new Category(1L, "Mathematics");

        assertEquals(1L, fullCategory.getCategoryId());
        assertEquals("Mathematics", fullCategory.getCategoryName());
    }

    @Test
    void testSettersAndGetters() {
        category.setCategoryId(10L);
        category.setCategoryName("History");

        assertEquals(10L, category.getCategoryId());
        assertEquals("History", category.getCategoryName());
    }

    @Test
    void testToString() {
        category.setCategoryId(5L);
        category.setCategoryName("Literature");

        String expected = "Category{categoryId=5, categoryName='Literature'}";
        assertEquals(expected, category.toString());
    }

    @Test
    void testDifferentCategoryNames() {
        String[] categoryNames = {"Sports", "Music", "Geography", "Art", "Technology"};

        for (String name : categoryNames) {
            Category testCategory = new Category(name);
            assertEquals(name, testCategory.getCategoryName());
        }
    }

    @Test
    void testEmptyName() {
        Category emptyCategory = new Category("");
        assertEquals("", emptyCategory.getCategoryName());
    }

    @Test
    void testLongCategoryName() {
        String longName = "Advanced Computer Science and Software Engineering Fundamentals";
        Category longCategory = new Category(longName);
        assertEquals(longName, longCategory.getCategoryName());
    }
}