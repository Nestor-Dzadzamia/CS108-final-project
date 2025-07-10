<%@ page import="DAO.QuizDao" %>
<%@ page import="Models.Quiz" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Summary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Helvetica Neue', sans-serif; }
        .summary-card { background: #fff; border-radius: 1rem; box-shadow: 0 4px 16px rgba(0,0,0,0.12); margin-top: 3rem; padding: 2.5rem 2rem; }
        .back-btn { margin-top: 2rem; }
        .logo-home:hover {
            box-shadow: 0 8px 32px rgba(0,0,0,0.25);
            transform: scale(1.08) rotate(-3deg);
        }
    </style>
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
                // Get category name from new method
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
        } catch (Exception e) {
            // leave as Unknown
        }
    }

    // CATEGORY BACKGROUND LOGIC - FIXED!
    String backgroundStyle = "";
    if (categoryName != null && !categoryName.isEmpty()) {
        backgroundStyle = "background: url('" + request.getContextPath() + "/images/Backgrounds/" + categoryName + ".png') center/cover no-repeat fixed;";
    }
%>
<body <%= !backgroundStyle.isEmpty() ? "style=\"" + backgroundStyle + "\"" : "" %>>
<!-- Logo at top left, outside container! -->
<a href="<%= loggedIn ? "homepage.jsp" : "index.jsp" %>" style="position: absolute; top: 12px; left: 24px; z-index: 1000; text-decoration: none;">
    <img src="<%= request.getContextPath() %>/images/quiz_icon.png"
         alt="Quiz App Home"
         class="logo-home"
         style="height:90px; width:auto; border-radius: 16px; box-shadow: 0 4px 18px rgba(0,0,0,0.15); transition:0.2s;">
</a>

<div class="container">
    <% if (errorMsg != null) { %>
    <div class="alert alert-danger mt-5"><%= errorMsg %></div>
    <% } else if (quiz == null) { %>
    <div class="alert alert-warning mt-5">Quiz not found.</div>
    <% } else { %>
    <div class="summary-card mx-auto" style="max-width:600px;">
        <h1 class="mb-3"><%= quiz.getQuizTitle() %></h1>
        <p class="lead"><%= (quiz.getDescription() == null || quiz.getDescription().isEmpty()) ? "No description." : quiz.getDescription() %></p>
        <hr>
        <ul class="list-unstyled mb-3">
            <li><strong>Created by:</strong> <a href="friends?action=profile&userId=<%= quiz.getCreatedBy() %>"><%= creatorUsername %></a></li>
            <li><strong>Total Time Limit:</strong>
                <%= (quiz.getTotalTimeLimit() == 0 || quiz.getTotalTimeLimit() == 0) ? "No limit" : quiz.getTotalTimeLimit() + " minutes" %>
            </li>
            <li><strong>Questions:</strong> <%= numQuestions %></li>
            <li><strong>Taken:</strong> <%= quiz.getSubmissionsNumber() %> Times </li>
            <li><strong>Category:</strong> <%= categoryName %></li>
        </ul>

        <% if (loggedIn) { %>
        <form action="take-quiz-starter" method="get" class="mt-3">
            <input type="hidden" name="id" value="<%= quiz.getQuizId() %>">
            <button class="btn btn-primary btn-lg" name="startQuiz" value="true">Take this Quiz</button>
        </form>
        <% if (quiz.isAllowPractice()) { %>
        <form action="take-quiz-starter" method="get" class="mt-2">
            <input type="hidden" name="id" value="<%= quiz.getQuizId() %>">
            <input type="hidden" name="mode" value="practice">
            <button class="btn btn-warning btn-lg">Practice Mode</button>
        </form>
        <% } %>
        <% } else { %>
        <button class="btn btn-primary btn-lg mt-3" disabled title="Login to take quizzes!">Take this Quiz</button>
        <div class="text-muted mt-2">Please <a href="login.jsp">login</a> to take quizzes.</div>
        <% } %>
        <a href="<%= loggedIn ? "homepage.jsp" : "index.jsp" %>" class="btn btn-outline-secondary back-btn">← Back to Home</a>
    </div>
    <% } %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
