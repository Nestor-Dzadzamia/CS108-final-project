package DAO;

import DB.DBConnection;
import Models.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao {

    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT * FROM categories";
        List<Category> categories = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Category category = new Category(
                        rs.getLong("category_id"),
                        rs.getString("category_name")
                );
                categories.add(category);
            }
        }

        return categories;
    }

    public Category getCategoryById(long id) throws SQLException {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        Category category = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    category = new Category(
                            rs.getLong("category_id"),
                            rs.getString("category_name")
                    );
                }
            }
        }

        return category;
    }

    public void createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO categories (category_name) VALUES (?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, category.getCategoryName());
            stmt.executeUpdate();

            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    category.setCategoryId(keys.getLong(1));
                }
            }
        }
    }

    public void deleteCategory(long id) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }
}
