<%@ page import="java.sql.*" %>
<%@ page import="DB.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Connection connection = null;
  PreparedStatement statement = null;
  ResultSet resultSet = null;
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>QuizApp - Welcome</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 30px;
      background-color: #f4f4f4;
    }
    h1, h2 {
      color: #333;
    }
    .quiz-item {
      background: white;
      padding: 15px;
      margin-bottom: 10px;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    .header-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 25px;
    }
    .header-bar a {
      margin-left: 15px;
      text-decoration: none;
      color: #007BFF;
      font-weight: bold;
    }
    .header-bar a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

<div class="header-bar">
  <h1>Welcome to QuizApp!</h1>
  <div>
    <a href="login.jsp">Login</a>
    <a href="signup.jsp">Sign Up</a>
  </div>
</div>

<hr>

<h2>🛎️ Administration Announcements</h2>
<p>No announcements yet. Stay tuned!</p>

<hr>

<h2>🔥 Top 10 Popular Quizzes</h2>

<%
  try {
    connection = DBConnection.getConnection();

    String query = "SELECT quiz_id, quiz_title, description, submissions_number, creator FROM view_popular_quizzes";
    statement = connection.prepareStatement(query);
    resultSet = statement.executeQuery();

    while (resultSet.next()) {
      long quizId = resultSet.getLong("quiz_id");
      String quizTitle = resultSet.getString("quiz_title");
      String description = resultSet.getString("description");
      long submissions = resultSet.getLong("submissions_number");
      String creator = resultSet.getString("creator");
%>
<div class="quiz-item">
  <a href="quiz-summary.jsp?quizId=<%= quizId %>"><strong><%= quizTitle %></strong></a><br>
  <small>By <%= creator %> | Taken <%= submissions %> times</small><br>
  <em><%= description %></em>
</div>
<%
  }
} catch (Exception e) {
%>
<p style="color:red;">Error loading popular quizzes: <%= e.getMessage() %></p>
<%
  } finally {
    if (resultSet != null) try { resultSet.close(); } catch (SQLException ignored) {}
    if (statement != null) try { statement.close(); } catch (SQLException ignored) {}
    if (connection != null) try { connection.close(); } catch (SQLException ignored) {}
  }
%>

</body>
</html>
