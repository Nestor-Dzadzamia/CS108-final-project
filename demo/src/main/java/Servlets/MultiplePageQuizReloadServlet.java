package Servlets;

import Models.Answer;
import Models.PossibleAnswer;
import Models.Questions.Question;
import Models.Quiz;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/take-quiz-multiple-reload")
public class MultiplePageQuizReloadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Quiz quiz = (Quiz) session.getAttribute("quiz");
        int currentIndex = (Integer) session.getAttribute("index");
        int nextIndex = currentIndex + 1;
        session.setAttribute("index", nextIndex);
        List<Question> questions = (List<Question>) session.getAttribute("questions");
        Map<Long, List<Answer>> correctAnswers = (Map<Long, List<Answer>>) session.getAttribute("correctAnswers");
        Map<Long, List<PossibleAnswer>> possibleAnswers = (Map<Long, List<PossibleAnswer>>) session.getAttribute("possibleAnswers");
        Map<Long, List<String>> providedAnswers = (Map<Long, List<String>>) session.getAttribute("providedAnswers");
        populateUserAnswersMap(providedAnswers, req, questions, correctAnswers, currentIndex);

        session.setAttribute("providedAnswers", providedAnswers);
        if(nextIndex == questions.size()) {
            RequestDispatcher dispatcher = req.getRequestDispatcher("/submit-quiz");
            dispatcher.forward(req, resp);
        } else {
            Question currentQuestion = questions.get(nextIndex); //next question
            session.setAttribute("currentQuestion", currentQuestion);

            long quizStartTime = (Long) session.getAttribute("quizStartTime");
            long now = System.currentTimeMillis();
            long elapsedSeconds = (now - quizStartTime) / 1000;
            long totalAllowedSeconds = quiz.getTotalTimeLimit() * 60;
            //totalAllowedSeconds = 5; //for debugging
            long remainingSeconds = Math.max(0, totalAllowedSeconds - elapsedSeconds);
            session.setAttribute("remainingTime", remainingSeconds);

            if(remainingSeconds <= 0) {
                RequestDispatcher dispatcher = req.getRequestDispatcher("/submit-quiz");
                dispatcher.forward(req, resp);
            } else {
                req.getRequestDispatcher("takeQuizMultiplePage.jsp").forward(req, resp);
            }
        }
    }

    private void populateUserAnswersMap(Map<Long, List<String>> providedAnswers, HttpServletRequest req, List<Question> questions, Map<Long, List<Answer>> correctAnswers, int currentIndex) {
            Question q = questions.get(currentIndex);
            Long qid = q.getQuestionId();
            String type = q.getQuestionType().strip().toLowerCase();
            switch (type) {
                case "question-response":
                case "picture-response":
                case "fill-blank", "multiple-choice": {
                    String answer = req.getParameter("answer_" + qid);
                    if (answer != null && !answer.strip().isEmpty()) {
                        providedAnswers.put(qid, List.of(answer.strip()));
                    } else {
                        providedAnswers.put(qid, List.of(""));
                    }
                    break;
                }
                case "multiple-multiple-choice": {
                    String[] selected = req.getParameterValues("answer_" + qid);
                    if (selected != null && selected.length > 0) {
                        providedAnswers.put(qid, List.of(selected));
                    } else {
                        providedAnswers.put(qid, List.of(""));
                    }
                    break;
                }
                case "multi-answer": {
                    int expectedCount = correctAnswers.get(qid) != null ? correctAnswers.get(qid).size() : 1;
                    List<String> answers = new java.util.ArrayList<>();
                    for (int i = 1; i <= expectedCount; i++) {
                        String param = req.getParameter("answer_" + qid + "_" + i);
                        if (param != null && !param.strip().isEmpty()) {
                            answers.add(param.strip());
                        } else {
                            answers.add("");
                        }
                    }
                    providedAnswers.put(qid, answers);
                    break;
                }
                case "matching": {
                    int expectedCount = correctAnswers.get(qid) != null ? correctAnswers.get(qid).size() : 1;
                    List<String> matches = new java.util.ArrayList<>();
                    for (int i = 1; i <= expectedCount; i++) {
                        String matchRight = req.getParameter("match_right_" + qid + "_" + i);
                        if (matchRight != null && !matchRight.strip().isEmpty()) {
                            matches.add(matchRight.strip());
                        } else {
                            matches.add("");
                        }
                    }
                    providedAnswers.put(qid, matches);
                    break;
                }
            }

    }
}