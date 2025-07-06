package Servlets;

import DAO.UserDao;
import Models.User;
import util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            String salt = PasswordUtil.generateSalt();
            String hashedPassword = PasswordUtil.hashPassword(password, salt);

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setSalt(salt);
            user.setHashedPassword(hashedPassword);

            UserDao userDao = new UserDao();

            boolean success = userDao.insertUser(user);

            if (success) {
                response.sendRedirect("homepage.jsp");
            } else {
                // fallback error message
                request.setAttribute("error", "We couldn't complete your registration. Please try again.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            String message = e.getMessage();
            if (message != null && message.contains("Duplicate entry")) {
                if (message.contains("username") && !message.contains("email")) {
                    request.setAttribute("error", "That username is already taken. Please choose a different one.");
                } else if (message.contains("email")) {
                    request.setAttribute("error", "An account with this email already exists.");
                } else {
                    request.setAttribute("error", "An account with similar credentials already exists.");
                }
            } else {
                // For unexpected SQL errors
                request.setAttribute("error", "A system error occurred. Please try again later.");
            }

            request.getRequestDispatcher("signup.jsp").forward(request, response);

        } catch (Exception e) {
            // Catch-all for hashing or other unexpected failures
            e.printStackTrace(); // for debugging/logging
            request.setAttribute("error", "Something went wrong during registration. Please try again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}

