<%@ page import="java.util.List" %>
<%@ page import="Models.Quiz" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Homepage - Quiz App</title>
</head>
<body>
<h1>Recent Quizzes</h1>

<ul>
    <%
        List<Quiz> recent = (List<Quiz>) request.getAttribute("recentQuizzes");
        if (recent != null && !recent.isEmpty()) {
            for (Quiz quiz : recent) {
    %>
    <li>
        <strong><%= quiz.getTitle() %></strong> by <%= quiz.getCreator() %>
    </li>
    <%
        }
    } else {
    %>
    <li>No recent quizzes found.</li>
    <%
        }
    %>
</ul>

<form action="createQuiz" method="get">
    <button type="submit">Create New Quiz</button>
</form>
<form action="user" method="get" style="margin-top: 1rem;">
    <button type="submit">My Page</button>
</form>

</body>
</html>
