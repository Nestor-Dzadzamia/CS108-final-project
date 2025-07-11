<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="Models.Quiz" %>
<%@ page import="Models.Achievement" %>
<%
  User user = (User) session.getAttribute("user");

  String username = user != null && user.getUsername() != null ? user.getUsername() : "Guest";
  String email = user != null && user.getEmail() != null ? user.getEmail() : "N/A";
  String memberSince = (user != null && user.getTimeCreated() != null) ? user.getTimeCreated().toString().substring(0, 10) : "N/A";
  long quizzesCreated = (user != null && user.getNumQuizzesCreated() != null) ? user.getNumQuizzesCreated() : 0L;
  long quizzesTaken = (user != null && user.getNumQuizzesTaken() != null) ? user.getNumQuizzesTaken() : 0L;
  String top1Achiever = (user != null && user.getWasTop1() != null && user.getWasTop1()) ? "Yes" : "No";
  String takenPractice = (user != null && user.getTakenPractice() != null && user.getTakenPractice()) ? "Yes" : "No";

  List<Quiz> myQuizzes = (List<Quiz>) request.getAttribute("myQuizzes");
  List<Achievement> allAchievements = (List<Achievement>) request.getAttribute("allAchievements");
  Set<Long> earnedIds = (Set<Long>) request.getAttribute("earnedIds");
  List<Achievement> userAchievements = (List<Achievement>) request.getAttribute("userAchievements");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= username %>'s Profile | Quiz Rizz</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="Styles/user.css">
</head>
<body>
<div class="container">
  <div class="header">
    <h1><i class="fas fa-user-circle"></i> <%= username %>'s Profile</h1>
    <p>Your Quiz Master stats, quizzes & achievements</p>
  </div>

  <div class="profile-info">
    <div class="profile-avatar">
      <i class="fas fa-user"></i>
    </div>
    <div class="profile-details">
      <h2><%= username %></h2>
      <p><i class="fas fa-envelope"></i> <%= email %></p>
      <p><i class="fas fa-calendar-alt"></i> Member Since: <%= memberSince %></p>
    </div>
  </div>

  <div class="stats-section">
    <div class="stat-box">
      <h3><%= quizzesCreated %></h3>
      <p>Quizzes Created</p>
    </div>
    <div class="stat-box">
      <h3><%= quizzesTaken %></h3>
      <p>Quizzes Taken</p>
    </div>
    <div class="stat-box">
      <h3><%= top1Achiever %></h3>
      <p>Top 1 Achiever</p>
    </div>
    <div class="stat-box">
      <h3><%= takenPractice %></h3>
      <p>Practice Quizzes</p>
    </div>
  </div>

  <div class="main-content">
    <!-- Left: Quizzes & Achievements -->
    <div>
      <div class="panel quizzes-list">
        <h3><i class="fas fa-list-ol"></i> Your Quizzes</h3>
        <%
          if (myQuizzes != null && !myQuizzes.isEmpty()) {
        %>
        <ul>
          <% for (Quiz q : myQuizzes) { %>
          <li>
            <strong><%= q.getQuizTitle() %></strong>
            (Created on: <%= q.getCreatedAt() != null ? q.getCreatedAt().toString().substring(0,10) : "N/A" %>)
          </li>
          <% } %>
        </ul>
        <% } else { %>
        <p>You haven’t created any quizzes yet.</p>
        <% } %>
        <form action="create-quiz-setup" method="get" style="margin-top: 1rem;">
          <button class="button" type="submit"><i class="fas fa-plus"></i> Create New Quiz</button>
        </form>
      </div>

      <div class="achievements-section" style="margin-top:2rem;">
        <h3><i class="fas fa-trophy"></i> Achievements</h3>
        <div class="achievements-grid">
          <%
            if (allAchievements != null && !allAchievements.isEmpty()) {
              for (Achievement a : allAchievements) {
                boolean earned = earnedIds != null && earnedIds.contains(a.getAchievementId());
                java.sql.Timestamp awardedAt = null;
                if (earned && userAchievements != null) {
                  for (Achievement earnedA : userAchievements) {
                    if (earnedA.getAchievementId() == a.getAchievementId()) {
                      awardedAt = earnedA.getAwardedAt();
                      break;
                    }
                  }
                }
          %>
          <div class="achievement-card <%= earned ? "earned" : "locked" %>">
            <img src="images/<%= a.getIconUrl() %>" alt="Achievement icon" />
            <div class="achievement-name"><%= a.getAchievementName() %></div>
            <div class="achievement-desc"><%= a.getAchievementDescription() %></div>
            <% if (earned) { %>
            <div class="badge-label badge-earned">
              Earned<%= (awardedAt != null ? " on " + awardedAt.toString().substring(0,10) : "") %>
            </div>
            <% } else { %>
            <div class="badge-label badge-locked">Locked</div>
            <% } %>
          </div>
          <%
            }
          } else {
          %>
          <p>No achievements found.</p>
          <% } %>
        </div>
      </div>
    </div>
    <!-- Right: Quick actions (fixed inside white box!) -->
    <div>
      <div class="side-actions">
        <form action="logout" method="post">
          <button class="button" type="submit"><i class="fas fa-sign-out-alt"></i> Log Out</button>
        </form>
        <a href="friends" class="button"><i class="fas fa-user-friends"></i> Manage Friends</a>
        <a href="homepage.jsp" class="button" style="background:linear-gradient(135deg,#8b5cf6,#7c3aed);"><i class="fas fa-arrow-left"></i> Back to Home</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
