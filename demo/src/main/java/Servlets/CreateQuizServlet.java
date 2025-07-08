package Servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/create-quiz")
public class CreateQuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve info from submitted form data
        String title = request.getParameter("quiz_title");
        String description = request.getParameter("description");
        int questionCountInt = Integer.parseInt(request.getParameter("question_count"));
        int totalTimeInt = Integer.parseInt(request.getParameter("total_time_limit"));
        long categoryId = Long.parseLong(request.getParameter("quiz_category"));

        boolean randomized = request.getParameter("randomized") != null;
        boolean multiplePage = request.getParameter("is_multiple_page") != null;
        boolean immediateCorrection = request.getParameter("immediate_correction") != null;
        boolean allowPractice = request.getParameter("allow_practice") != null;

        // Store everything in session as Long to avoid casting issues
        HttpSession session = request.getSession();
        session.setAttribute("quiz_title", title);
        session.setAttribute("description", description);
        session.setAttribute("question_count", Long.valueOf(questionCountInt));  // changed to Long
        session.setAttribute("total_time_limit", Long.valueOf(totalTimeInt));    // changed to Long
        session.setAttribute("quiz_category", categoryId);
        session.setAttribute("randomized", randomized);
        session.setAttribute("is_multiple_page", multiplePage);
        session.setAttribute("immediate_correction", immediateCorrection);
        session.setAttribute("allow_practice", allowPractice);

        // Forward to createQuizTypes.jsp (question input form)
        request.getRequestDispatcher("createQuizTypes.jsp").forward(request, response);
    }
}
