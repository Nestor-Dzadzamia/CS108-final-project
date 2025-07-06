<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Quiz" %>

<html>
<head><title>My Page</title></head>
<body>
<h2>Welcome to your page!</h2>

<h3>Your Quizzes:</h3>
<ul>
  <%
    List<Quiz> myQuizzes = (List<Quiz>) request.getAttribute("myQuizzes");
    if (myQuizzes != null && !myQuizzes.isEmpty()) {
      for (Quiz quiz : myQuizzes) {
  %>
  <li><%= quiz.getTitle() %> - <%= quiz.getCreatedAt() %></li>
  <%
    }
  } else {
  %>
  <li>You haven’t created any quizzes yet.</li>
  <%
    }
  %>
</ul>
</body>
</html>
