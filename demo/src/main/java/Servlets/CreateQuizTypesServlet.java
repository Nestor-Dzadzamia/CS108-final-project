package Servlets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/create-quiz-types")
public class CreateQuizTypesServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        Long questionCount = (Long) session.getAttribute("question_count");
        if (questionCount == null || questionCount <= 0) {
            questionCount = 1L;
        }

        Map<Integer, String> questionTypes = new HashMap<>();
        Map<Integer, Integer> correctCounts = new HashMap<>();
        Map<Integer, Integer> totalAnswersMap = new HashMap<>();

        boolean allValid = true;

        for (int i = 1; i <= questionCount; i++) {
            String type = req.getParameter("question_" + i + "_type");
            String correctStr = req.getParameter("question_" + i + "_num_correct");
            String totalStr = req.getParameter("question_" + i + "_total_answers");

            if (type == null || type.isEmpty() || correctStr == null || correctStr.isEmpty()) {
                allValid = false;
                break;
            }

            try {
                int correctCount = Integer.parseInt(correctStr);
                int totalAnswers = -1;

                if ("multiple-choice".equals(type)) {
                    correctCount = 1; // force to 1
                    totalAnswers = Integer.parseInt(totalStr);
                    if (totalAnswers < 4 || totalAnswers > 6) {
                        allValid = false;
                        break;
                    }

                } else if ("multiple-multiple-choice".equals(type)) {
                    totalAnswers = Integer.parseInt(totalStr);
                    if (totalAnswers < 4 || totalAnswers > 8) {
                        allValid = false;
                        break;
                    }

                    // Allow correctCount to be 1 or more, but not >= total
                    if (correctCount < 1) {
                        correctCount = 1;
                    }
                    if (correctCount >= totalAnswers) {
                        correctCount = totalAnswers - 1;
                    }
                }

                if (totalAnswers == -1) {
                    totalAnswers = 0;
                }

                questionTypes.put(i, type);
                correctCounts.put(i, correctCount);
                totalAnswersMap.put(i, totalAnswers);

            } catch (NumberFormatException e) {
                allValid = false;
                break;
            }
        }

        if (!allValid) {
            req.setAttribute("error", "Invalid input: check that correct and total answers are valid for each question.");
            RequestDispatcher rd = req.getRequestDispatcher("createQuizTypes.jsp");
            rd.forward(req, resp);
            return;
        }

        session.setAttribute("question_types", questionTypes);
        session.setAttribute("correct_counts", correctCounts);
        session.setAttribute("total_answers", totalAnswersMap);

        resp.sendRedirect("createQuizQuestions.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("createQuizTypes.jsp");
    }
}
