package Servlets;

import DAO.UserDao;
import Models.Answer;
import Models.PossibleAnswer;
import Models.Questions.Question;
import Models.Quiz;
import Models.User;
import com.mysql.cj.conf.ConnectionUrlParser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.http.HttpRequest;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebServlet("/submit-quiz")
public class SubmitQuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        double finalScore = 0.0;
        HttpSession session = req.getSession();
        Quiz quiz = (Quiz) session.getAttribute("quiz");
        List<Question> questions = (List<Question>) session.getAttribute("questions");
        Map<Long, List<Answer>> correctAnswers = (Map<Long, List<Answer>>) session.getAttribute("correctAnswers");
        Map<Long, List<PossibleAnswer>> possibleAnswers = (Map<Long, List<PossibleAnswer>>) session.getAttribute("possibleAnswers");
        Map<Long, List<String>> providedAnswers = (Map<Long, List<String>>) session.getAttribute("providedAnswers");
        //for single page map is not populated yet
        if(!quiz.isMultiplePage()) populateUserAnswersMap(providedAnswers, req, questions, correctAnswers);

        //populating user answers with mock data if he/she couldn't reach some pages
        //because of time limit
        for(long l: correctAnswers.keySet() ) {
            if(!providedAnswers.containsKey(l)) {
                providedAnswers.put(l, new ArrayList<>());
                providedAnswers.get(l).add("");
            }
        }
        for(Long l:  providedAnswers.keySet()) {
            for(int i = 0; i < providedAnswers.get(l).size(); i++) {
                System.out.println(providedAnswers.get(l).get(i));
            }
        }
        for(Long l: correctAnswers.keySet()) {
            for(int i = 0; i < correctAnswers.get(l).size(); i++) {
                System.out.println(correctAnswers.get(l).get(i).getAnswerText());
            }
        }
        List<Double> quizStats = new ArrayList<>();
        finalScore = evaluateFinalScore(providedAnswers, correctAnswers, questions, quizStats);
        System.out.println("Final Score: " + finalScore);
        quizStats.add(finalScore);

        //total time spent
        long quizStartTime = (Long) session.getAttribute("quizStartTime"); // keep in ms
        long currentTime = System.currentTimeMillis(); // ms
        long totalMillis = currentTime - quizStartTime;
        long totalSeconds = totalMillis / 1000;
        long totalTimeSpent = totalSeconds / 60;
        long totalSecondsRem = totalSeconds % 60;
        // if user used all quiz time and few additional seconds spent while submitting form
        if(totalTimeSpent >= quiz.getTotalTimeLimit()) {
            totalTimeSpent = quiz.getTotalTimeLimit();
            totalSecondsRem = 0;
        }

        User user = (User) session.getAttribute("user");
        //update all the info in database
        UserDao userDao = new UserDao();
        if(!(Boolean) session.getAttribute("isPracticeMode")) {
            try {
                boolean inserted = userDao.recordSubmissionAndCheckAchievements(user.getId(), quiz.getQuizId(), quizStats.get(1).longValue(), quizStats.get(0).longValue(), quizStats.get(3).longValue(), totalTimeSpent);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            try {
                userDao.handlePracticeAchievement(user.getId());
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        //clear session except for user info
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String attr = attributeNames.nextElement();
            System.out.println(attr + ": " + session.getAttribute(attr));
            if(!attr.equals("user") && !attr.equals("isPracticeMode")) session.removeAttribute(attr);
        }

        //set all needed attributes to the request
        req.setAttribute("totalTimeSpent", totalTimeSpent);
        req.setAttribute("totalSecondsRem", totalSecondsRem);
        req.setAttribute("quiz", quiz); // basic quiz info (title, settings)
        req.setAttribute("questions", questions); // list of quiz questions
        req.setAttribute("correctAnswers", correctAnswers); // map of qid to correct answers
        req.setAttribute("providedAnswers", providedAnswers); // map of qid to user answers
        req.setAttribute("possibleAnswers", possibleAnswers); // for MCQ or matching
        req.setAttribute("quizStats", quizStats); // contains [totalCount, gotRightCount, markedIncorrectly, finalScore]
        req.setAttribute("finalScore", finalScore); // if you want it directly



        req.getRequestDispatcher("takeQuizSummaryPage.jsp").forward(req, resp);
    }

    private void populateUserAnswersMap(Map<Long, List<String>> providedAnswers, HttpServletRequest req, List<Question> questions, Map<Long, List<Answer>> correctAnswers) {
        for (Question q : questions) {
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

    private double evaluateFinalScore(Map<Long, List<String>> providedAnswers, Map<Long, List<Answer>> correctAnswers, List<Question> questions, List<Double> quizStats) {
        double totalCount = 0.0;
        double gotRightCount = 0.0;
        double markedIncorrectly = 0.0;
        for (Question q : questions) {
            Long qid = q.getQuestionId();
            String type = q.getQuestionType().strip().toLowerCase();
            switch (type) {
                case "question-response":
                case "picture-response":
                case "fill-blank", "multiple-choice": {
                    String userAnswer = providedAnswers.get(qid).get(0);
                    totalCount += 1;
                    for(Answer a: correctAnswers.get(qid)) {
                        String curr = a.getAnswerText();
                        if(curr.equalsIgnoreCase(userAnswer.strip())) {
                            gotRightCount += 1;
                            break;
                        }
                    }
                    break;
                }
                case "multiple-multiple-choice": {
                    totalCount += correctAnswers.get(qid).size();
                    List<Answer> answers = new ArrayList<>(correctAnswers.get(qid));
                    for(String s: providedAnswers.get(qid)) {
                        if(s.equals("")) continue;
                        boolean found = false;
                        for(Answer a: answers) {
                            if(a.getAnswerText().equalsIgnoreCase(s.strip())) {
                                gotRightCount += 1;
                                found = true;
                                answers.remove(a);
                                break;
                            }
                        }
                        if(!found) {
                            markedIncorrectly += 1; //minus point for choosing wrong answer
                            System.out.println("Wrong answer: " + s);
                        }
                    }
                    break;
                }
                case "multi-answer": {
                    totalCount += correctAnswers.get(qid).size();
                    if(correctAnswers.get(qid).get(0).getMatchOrder() != -1) { //ordered answers
                        for(int i = 0; i < providedAnswers.get(qid).size(); i++) {
                            if(correctAnswers.get(qid).get(i).getAnswerText().equalsIgnoreCase(providedAnswers.get(qid).get(i).strip()) ) {
                                gotRightCount += 1;
                            }
                        }
                    } else {
                        List<Answer> answers = new ArrayList<>(correctAnswers.get(qid));
                        for(String s: providedAnswers.get(qid)) {
                            for(Answer a: answers) {
                                if(a.getAnswerText().equalsIgnoreCase(s.strip())) {
                                    gotRightCount += 1;
                                    answers.remove(a);
                                    break;
                                }
                            }
                        }
                    }
                    break;
                }
                case "matching": {
                    totalCount += correctAnswers.get(qid).size();
                    for(int i = 0; i < providedAnswers.get(qid).size(); i++) {
                        String providedAnswer = providedAnswers.get(qid).get(i);
                        String toMatch = correctAnswers.get(qid).get(i).getAnswerText();
                        String x = "";
                        for(int j = 0; j < toMatch.length(); j++) {
                            if(toMatch.charAt(j) == '-') {
                                x = toMatch.substring(j + 1);
                                break;
                            }
                        }
                        //System.out.println("String " + x);
                        if(x.equalsIgnoreCase(providedAnswer.strip())) {
                            gotRightCount += 1;
                        }
                    }
                    break;
                }
            }
        }
        System.out.println("totalCount: " + totalCount);
        System.out.println("gotRightCount: " + gotRightCount);
        System.out.println("markedIncorrectly: " + markedIncorrectly);
        quizStats.add(totalCount);
        quizStats.add(gotRightCount);
        quizStats.add(markedIncorrectly);
        if(gotRightCount <= 0.0) { //if got 0 correct and/or marked multi-multi-answer wrong
            return 0.0;
        }
        return (gotRightCount - markedIncorrectly) / totalCount * 100; //points in percentage
    }

}