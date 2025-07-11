<%@ page import="DAO.QuizDao" %>
<%@ page import="DAO.AnnouncementDao" %>
<%@ page import="Models.Quiz" %>
<%@ page import="Models.Announcement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  QuizDao quizDao = new QuizDao();
  List<Quiz> popularQuizzes = null;
  String quizError = null;
  try {
    popularQuizzes = quizDao.getPopularQuizzes();
  } catch (Exception e) {
    quizError = e.getMessage();
  }

  AnnouncementDao announcementDao = new AnnouncementDao();
  List<Announcement> announcements = null;
  String announcementError = null;
  try {
    announcements = announcementDao.getAllAnnouncements();
  } catch (Exception e) {
    announcementError = e.getMessage();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>QuizRizz - Welcome</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="icon" type="image/png" href="images/quiz_icon_no_background.png">
  <link rel="stylesheet" href="Styles/index.css">
</head>
<body>
<a href="<%= request.getContextPath() %>/" class="logo-link">
  <img src="images/quiz_icon.png"
       alt="Quiz App Home"
       class="logo-img">
</a>
<div class="header-bar">
  <a href="login.jsp" class="nav-btn outline">Login</a>
  <a href="signup.jsp" class="nav-btn">Sign Up</a>
</div>
<div class="page-content">
  <!-- Center Main Content -->
  <div class="main-center">
    <div class="header">
      <h1><i class="fas fa-graduation-cap"></i> Welcome to QuizRizz!</h1>
      <div class="subtitle">
        Compete, learn, and have fun! Check the latest announcements or try a popular quiz below.
      </div>
    </div>
    <div class="quiz-section-title">
      <i class="fas fa-fire"></i> Popular Quizzes
    </div>
    <div class="quizzes-list">
      <% if (quizError != null) { %>
      <p style="color:red;">Error loading popular quizzes: <%= quizError %></p>
      <% } else if (popularQuizzes != null && !popularQuizzes.isEmpty()) {
        for (Quiz quiz : popularQuizzes) {
          String creatorUsername = quizDao.getCreatorUsernameByQuizId(quiz.getQuizId());
      %>
      <a href="quiz-summary.jsp?quizId=<%= quiz.getQuizId() %>" class="quiz-link-block">
        <div class="quiz-card">
          <span class="quiz-title-link"><%= quiz.getQuizTitle() %></span>
          <span class="popular-badge">Popular</span><br><br>
          <span class="quiz-meta">
            By <span class="creator-link"><%= creatorUsername != null ? creatorUsername : "Unknown" %></span>
            &bull; Attempts: <%= quiz.getSubmissionsNumber() %>
          </span><br>
          <span class="quiz-desc"><%= quiz.getDescription() == null ? "No description available." : quiz.getDescription() %></span>
        </div>
      </a>
      <%   }
      } else { %>
      <div class="quiz-card">
        <span class="quiz-title-link">No quizzes yet</span>
        <div class="quiz-desc">Be the first to create a quiz and become popular!</div>
      </div>
      <% } %>
    </div>
  </div>
  <!-- Announcements Sidebar -->
  <aside class="announcement-sidebar">
    <div class="announcement-titlebar">
      <i class="fas fa-bullhorn"></i> Administration Announcements
    </div>
    <div class="announcements-list">
      <% if (announcementError != null) { %>
      <p style="color: red;">Error loading announcements: <%= announcementError %></p>
      <% } else if (announcements != null && !announcements.isEmpty()) { %>
      <% for (Announcement ann : announcements) { %>
      <div class="announcement-card">
        <span class="announcement-title"><%= ann.getTitle() %></span>
        <span class="announcement-date"><%= new SimpleDateFormat("yyyy-MM-dd HH:mm").format(ann.getCreatedAt()) %></span>
        <div class="announcement-msg"><%= ann.getMessage() %></div>
      </div>
      <% } %>
      <% } else { %>
      <div class="announcement-card">
        <span class="announcement-title">No announcements yet</span>
        <div class="announcement-msg">Stay tuned for updates from the admins!</div>
      </div>
      <% } %>
    </div>
  </aside>
</div>
</body>
</html>
