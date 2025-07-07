package Servlets;

import DAO.CategoryDao;
import Models.Category;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/create-quiz-setup")
public class CreateQuizSetupServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CategoryDao categoryDao = new CategoryDao();

        try {
            List<Category> categories = categoryDao.getAllCategories();
            req.setAttribute("categories", categories);
        } catch (SQLException e) {
            e.printStackTrace(); // You can log this
            req.setAttribute("error", "Unable to load categories.");
        }

        RequestDispatcher dispatcher = req.getRequestDispatcher("/createQuizSetup.jsp");
        dispatcher.forward(req, resp);
    }
}