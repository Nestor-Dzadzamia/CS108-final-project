<%@ page import="DAO.QuizDao" %>
<%@ page import="Models.Quiz" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Summary</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:700,400&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Inter:400,600,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Styles/quiz-summary.css">
</head>
<%
    String quizIdStr = request.getParameter("quizId");
    Quiz quiz = null;
    Integer numQuestions = null;
    String errorMsg = null;
    String categoryName = null;

    Long quizStartTime = (Long) session.getAttribute("quizStartTime");
    if(quizStartTime != null) session.removeAttribute("quizStartTime");

    if (quizIdStr == null) {
        errorMsg = "No quiz id provided.";
    } else {
        try {
            long quizId = Long.parseLong(quizIdStr);
            QuizDao quizDao = new QuizDao();
            quiz = quizDao.getQuizById(quizId);
            if (quiz == null) {
                errorMsg = "Quiz not found.";
            } else {
                numQuestions = quizDao.getQuestionsCount(quizId);
                categoryName = quizDao.getQuizCategory(quiz);
            }
        } catch (Exception e) {
            errorMsg = "Error loading quiz summary: " + e.getMessage();
        }
    }

    Object user = session.getAttribute("user");
    boolean loggedIn = (user != null);

    String creatorUsername = "Unknown";
    if (quiz != null) {
        try {
            QuizDao quizDao2 = new QuizDao();
            creatorUsername = quizDao2.getCreatorUsernameByQuizId(quiz.getQuizId());
        } catch (Exception e) {}
    }

    String backgroundStyle = "";
    if (categoryName != null && !categoryName.isEmpty()) {
        backgroundStyle = "background: url('" + request.getContextPath() + "/images/Backgrounds/" + categoryName + ".png') center/cover no-repeat fixed;";
    }

    Map<String, Object> stats = null;
    if (quiz != null) {
        try {
            stats = new DAO.QuizDao().getQuizSummaryStats(quiz.getQuizId());
        } catch (Exception ignore) {}
    }

    List<Map<String, Object>> leaderboard = null;
    if (quiz != null) {
        try {
            leaderboard = new DAO.QuizDao().getTopScorers(quiz.getQuizId(), 5); // Top 5
        } catch (Exception ignore) {}
    }
%>
<body <%= !backgroundStyle.isEmpty() ? "style=\"" + backgroundStyle + "\"" : "" %>>
<a href="<%= loggedIn ? "homepage.jsp" : "index.jsp" %>" class="quiz-summary-logo-link">
    <img src="<%= request.getContextPath() %>/images/quiz_icon.png"
         alt="Quiz App Home"
         class="logo-home">
</a>
<div class="container main-flex-row">
    <% if (errorMsg != null) { %>
    <div class="alert alert-danger mt-5"><%= errorMsg %></div>
    <% } else if (quiz == null) { %>
    <div class="alert alert-warning mt-5">Quiz not found.</div>
    <% } else { %>
    <!-- Summary Card LEFT -->
    <div class="summary-card">
        <h1><%= quiz.getQuizTitle() %></h1>
        <div class="subtitle">
            Show how well you know <%= categoryName != null ? categoryName : "this topic" %>
        </div>
        <hr>
        <div class="pill-field"><b>Created by:</b>
            <a class="pill-link" href="friends?action=profile&userId=<%= quiz.getCreatedBy() %>"><%= creatorUsername %></a>
        </div>
        <div class="pill-field"><b>Total Time Limit:</b> <%= (quiz.getTotalTimeLimit() == 0) ? "No limit" : quiz.getTotalTimeLimit() + " minutes" %></div>
        <div class="pill-field"><b>Questions:</b> <%= numQuestions %></div>
        <div class="pill-field"><b>Category:</b> <%= categoryName %></div>
        <% if (loggedIn) { %>
            <form action="take-quiz-starter" method="get" style="width: 100%; margin: 0; padding: 0;">
                <input type="hidden" name="id" value="<%= quiz.getQuizId() %>">
                <button class="pill-btn" type="submit">Take this Quiz</button>
            </form>
            <% if (quiz.isAllowPractice()) { %>
            <form action="take-quiz-starter" method="get" class="mt-2">
                <input type="hidden" name="id" value="<%= quiz.getQuizId() %>">
                <input type="hidden" name="mode" value="practice">
                <button class="pill-btn pill-btn-secondary" type="submit">Practice Mode</button>
            </form>
            <% } %>
        <% } else { %>
            <button class="pill-btn" disabled title="Login to take quizzes!">Take this Quiz</button>
            <div class="text-muted" style="margin:7px 0 0 0;">Please <a href="login.jsp">login</a> to take quizzes.</div>
        <% } %>
        <a href="<%= loggedIn ? "homepage.jsp" : "index.jsp" %>" class="back-btn">← Back to Home</a>
    </div>
    <!-- Leaderboard Card RIGHT -->
    <div class="leaderboard-card">
        <!-- Stats at top -->
        <table class="leaderboard-stats mb-3" style="width:100%; margin-bottom:1.2rem;">
            <tr><th colspan="2" style="background:transparent; font-size:1.15rem; border:none; padding-bottom: 0.6em; color: #6b21a8">Quiz Statistics</th></tr>
            <tr>
                <td><b>Times Taken</b></td>
                <td style="text-align:right;"><%= (stats != null && stats.get("times_taken") != null) ? stats.get("times_taken") : 0 %></td>
            </tr>
            <tr>
                <td><b>Average Score</b></td>
                <td style="text-align:right;"><%= (stats != null && stats.get("avg_score") != null) ? stats.get("avg_score") : "N/A" %></td>
            </tr>
            <tr>
                <td><b>Average Time</b></td>
                <td style="text-align:right;">
                    <%
                        if (stats != null && stats.get("avg_time") != null) {
                            double avgTimeSec = 0.0;
                            Object avgObj = stats.get("avg_time");
                            if (avgObj instanceof Double) {
                                avgTimeSec = (Double) avgObj;
                            } else if (avgObj instanceof Number) {
                                avgTimeSec = ((Number) avgObj).doubleValue();
                            }
                            double avgTimeMin = avgTimeSec / 60.0;
                            String formattedTime = String.format("%.2f min", avgTimeMin);
                    %>
                    <%= formattedTime %>
                    <%
                    } else {
                    %>
                    N/A
                    <%
                        }
                    %>
                </td>
            </tr>
        </table>
        <!-- Leaderboard Table -->
        <table class="leaderboard-table">
            <thead>
            <tr>
                <th colspan="5" style="text-align:center; font-size:1.16rem; background:#e9d6fa;">Top Scorers</th>
            </tr>
            <tr>
                <th>#</th>
                <th>User</th>
                <th>Score</th>
                <th>Correct</th>
                <th>Time<br>(min)</th>
            </tr>
            </thead>
            <tbody>
            <% int rank = 1;
                if (leaderboard != null) {
                    for (Map<String, Object> row : leaderboard) {
                        long timeSpentSec = (row.get("time_spent") != null) ? ((Number) row.get("time_spent")).longValue() : 0;
                        double timeSpentMin = timeSpentSec / 60.0;
                        String formattedUserTime = String.format("%.2f", timeSpentMin);
            %>
            <tr>
                <td><span class="pill-table pill-rank"><%= rank++ %></span></td>
                <td><span class="pill-table username-pill"><%= row.get("username") %></span></td>
                <td><span class="pill-table score-pill"><%= row.get("score") %></span></td>
                <td><span class="pill-table correct-pill"><%= row.get("num_correct_answers") %> / <%= row.get("num_total_answers") %></span></td>
                <td><span class="pill-table time-pill"><%= formattedUserTime %></span></td>
            </tr>
            <% }
            }
            %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
</body>
</html>
