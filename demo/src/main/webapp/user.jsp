<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Quiz" %>
<%@ page import="Models.Achievement" %>

<%
  // Fetch user from session
  User user = (User) session.getAttribute("user");

  // Safe defaults for fields
  String username = user != null && user.getUsername() != null ? user.getUsername() : "Guest";
  String email = user != null && user.getEmail() != null ? user.getEmail() : "N/A";
  String memberSince = (user != null && user.getTimeCreated() != null) ? user.getTimeCreated().toString().substring(0, 10) : "N/A";
  Long quizzesCreated = (user != null && user.getNumQuizzesCreated() != null) ? user.getNumQuizzesCreated() : 0L;
  Long quizzesTaken = (user != null && user.getNumQuizzesTaken() != null) ? user.getNumQuizzesTaken() : 0L;
  String top1Achiever = (user != null && user.getWasTop1() != null && user.getWasTop1()) ? "Yes" : "No";
  String takenPractice = (user != null && user.getTakenPractice() != null && user.getTakenPractice()) ? "Yes" : "No";

  // Assuming these are set as request attributes in servlet:
  List<Quiz> myQuizzes = (List<Quiz>) request.getAttribute("myQuizzes");
  List<Achievement> userAchievements = (List<Achievement>) request.getAttribute("userAchievements");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>User Profile - <%= username %></title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f7f9fc;
      margin: 0; padding: 0;
      color: #333;
    }
    .container {
      max-width: 900px;
      margin: 2rem auto;
      background: white;
      padding: 2rem 3rem;
      box-shadow: 0 3px 12px rgba(0,0,0,0.1);
      border-radius: 10px;
    }
    h1, h2, h3 {
      color: #0078d7;
    }
    .profile-info, .stats, .quizzes, .achievements {
      margin-bottom: 2rem;
    }
    .stats div {
      display: inline-block;
      width: 150px;
      background: #e6f0fa;
      border-radius: 8px;
      padding: 1rem;
      margin-right: 1rem;
      text-align: center;
      box-shadow: inset 0 0 6px #c0d4f7;
    }
    ul {
      list-style: none;
      padding-left: 0;
    }
    ul li {
      background: #eef3fb;
      margin: 0.3rem 0;
      padding: 0.8rem 1rem;
      border-radius: 5px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.2s ease;
    }
    ul li:hover {
      background: #c5d9f8;
    }
    .achievement-card {
      display: inline-block;
      width: 150px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 0 10px #ccc;
      padding: 1rem;
      margin: 0.5rem;
      vertical-align: top;
      text-align: center;
    }
    .achievement-card img {
      width: 80px;
      height: 80px;
      margin-bottom: 0.5rem;
    }
    .achievement-name {
      font-weight: 700;
      color: #005aab;
    }
    .achievement-desc {
      font-size: 0.85rem;
      color: #666;
      margin-top: 0.3rem;
      min-height: 2.5em;
    }
    .button {
      background-color: #0078d7;
      color: white;
      border: none;
      padding: 0.7rem 1.2rem;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 600;
      transition: background-color 0.3s ease;
      margin-right: 10px;
    }
    .button:hover {
      background-color: #005fa3;
    }
    .section-header {
      border-bottom: 2px solid #0078d7;
      padding-bottom: 0.5rem;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>Welcome, <%= username %>!</h1>

  <div class="profile-info">
    <h2 class="section-header">Profile Information</h2>
    <p><strong>Email:</strong> <%= email %></p>
    <p><strong>Member Since:</strong> <%= memberSince %></p>
  </div>

  <div class="stats">
    <div>
      <h3><%= quizzesCreated %></h3>
      <p>Quizzes Created</p>
    </div>
    <div>
      <h3><%= quizzesTaken %></h3>
      <p>Quizzes Taken</p>
    </div>
    <div>
      <h3><%= top1Achiever %></h3>
      <p>Top 1 Achiever</p>
    </div>
    <div>
      <h3><%= takenPractice %></h3>
      <p>Taken Practice Quizzes</p>
    </div>
  </div>

  <div class="quizzes">
    <h2 class="section-header">Your Quizzes</h2>
    <%
      if (myQuizzes != null && !myQuizzes.isEmpty()) {
    %>
    <ul>
      <% for (Quiz q : myQuizzes) { %>
      <li><strong><%= q.getTitle() %></strong> (Created on: <%= q.getCreatedAt() != null ? q.getCreatedAt().toString().substring(0,10) : "N/A" %>)</li>
      <% } %>
    </ul>
    <% } else { %>
    <p>You haven’t created any quizzes yet.</p>
    <% } %>
    <form action="createQuiz" method="get" style="margin-top: 1rem;">
      <button class="button" type="submit">Create New Quiz</button>
    </form>
  </div>

  <div class="achievements">
    <h2 class="section-header">Achievements</h2>
    <%
      if (userAchievements != null && !userAchievements.isEmpty()) {
        for (Achievement a : userAchievements) {
    %>
    <div class="achievement-card">
      <img src="<%= a.getIconUrl() %>" alt="Achievement icon" />
      <div class="achievement-name"><%= a.getAchievementName() %></div>
      <div class="achievement-desc"><%= a.getAchievementDescription() %></div>
    </div>
    <%
      }
    } else {
    %>
    <p>No achievements earned yet.</p>
    <% } %>
  </div>

  <form action="logout" method="post" style="margin-top: 2rem;">
    <button class="button" type="submit">Log Out</button>
  </form>
</div>
</body>
</html>
