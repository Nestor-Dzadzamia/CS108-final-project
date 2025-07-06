package Servlets;

import Models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class AdminHomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // you could enhance this with role checking:
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"admin".equals(user.getUsername())) {
            // block non-admins
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
