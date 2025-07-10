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
  <title>QuizApp - Welcome</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="icon" type="image/png" href="images/quiz_icon_no_background.png">
  <style>
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      color: #2e2349;
      margin: 0;
      padding: 0;
    }
    .header-bar {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 0;
      gap: 18px;
      position: fixed;
      top: 32px;
      right: 44px;
      z-index: 99;
    }
    .header-bar .nav-btn {
      padding: 9px 28px;
      border-radius: 14px;
      font-size: 1.05rem;
      font-weight: 600;
      text-decoration: none;
      background: linear-gradient(100deg, #4e54c8 70%, #8f94fb 120%);
      color: #fff !important;
      border: none;
      transition: all 0.16s cubic-bezier(.4,2,.5,.75);
      margin-left: 0;
    }
    .header-bar .nav-btn.outline {
      background: #fff;
      color: #4e54c8 !important;
      border: 2px solid #4e54c8;
    }
    .header-bar .nav-btn:hover {
      transform: scale(1.07) translateY(-2px);
      box-shadow: 0 6px 22px rgba(78,84,200,0.22);
      color: #ffd600 !important;
      background: linear-gradient(90deg, #4952c9 60%, #ffd600 140%);
    }
    .header-bar .nav-btn.outline:hover {
      color: #4952c9 !important;
      background: #fffdfa;
      border-color: #ffd600;
    }
    .logo-link {
      position: absolute;
      top: 38px;
      left: 44px;
      z-index: 1000;
      text-decoration: none;
    }
    .logo-img {
      height: 70px;
      width: auto;
      border-radius: 16px;
      box-shadow: 0 4px 16px rgba(78,84,200,0.13);
      transition: 0.15s;
    }
    .logo-img:hover {
      transform: scale(1.08) rotate(-4deg);
      box-shadow: 0 8px 32px rgba(78,84,200,0.22);
    }

    .page-content {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      margin-top: 90px;
      min-height: 100vh;
      width: 100%;
      gap: 38px;
    }
    .main-center {
      background: rgba(255,255,255,0.17);
      border-radius: 30px;
      box-shadow: 0 12px 50px rgba(70, 66, 124, 0.10);
      padding: 36px 56px 44px 56px;
      flex: 1 1 900px;
      max-width: 980px;
      min-width: 370px;
      margin-bottom: 40px;
      margin-right: 0;
    }
    .header {
      text-align: center;
      margin-bottom: 16px;
    }
    .header h1 {
      color: #fff;
      font-size: 2.7rem;
      font-weight: 800;
      letter-spacing: 1px;
      text-shadow: 0 2px 24px #4e54c8;
      margin-bottom: 0.45em;
    }
    .header .subtitle {
      color: #fff;
      font-size: 1.25rem;
      font-weight: 700;
      letter-spacing: .4px;
      margin-bottom: 1.3em;
      margin-top: -8px;
      text-shadow: 0 1.5px 10px #564c9a26;
    }
    .quiz-section-title {
      font-family: inherit;
      color: #323268;
      font-weight: 800;
      font-size: 2rem;
      text-align: center;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 13px;
      margin-bottom: 1.7rem;
      margin-top: 0;
      letter-spacing: .2px;
    }
    .quizzes-list {
      display: flex;
      flex-direction: column;
      gap: 18px;
      width: 100%;
    }
    .quiz-link-block {
      text-decoration: none;
      width: 100%;
      display: block;
    }
    .quiz-card {
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 12px 40px rgba(120, 109, 173, 0.13);
      padding: 1.45rem 1.6rem 1.2rem 1.6rem;
      border: 1.5px solid #e2e8f0;
      border-left: 4px solid #ffd600;
      position: relative;
      transition: box-shadow 0.18s, transform 0.18s;
      overflow: hidden;
      cursor: pointer;
      margin-bottom: 0;
    }
    .quiz-card:hover {
      box-shadow: 0 12px 36px rgba(110, 85, 220, 0.20);
      transform: translateY(-2px) scale(1.013);
      background: #f6f8ff;
    }
    .quiz-title-link {
      color: #593ef8;
      font-size: 1.14rem;
      font-weight: bold;
      text-decoration: underline;
      pointer-events: none;
      font-family: inherit;
    }
    .quiz-link-block:hover .quiz-title-link {
      color: #ff9100;
    }
    .creator-link {
      color: #26222d;
      font-weight: bold;
      margin-left: 3px;
      font-family: inherit;
      pointer-events: none;
    }
    .quiz-meta {
      color: #55597a;
      font-size: .98em;
      margin-top: 1px;
    }
    .quiz-desc {
      color: #6d669a;
      font-size: 1.04rem;
      font-style: italic;
      margin-top: 13px;
      margin-left: 8px;
      padding: 13px 20px;
      border-left: 3px solid #ece8ff;
      background: rgba(127, 96, 244, 0.045);
      border-radius: 9px;
      transition: background 0.2s;
      font-family: 'Inter', sans-serif;
      display: block;
      max-width: 98%;
    }
    .quiz-card:hover .quiz-desc {
      background: #f2f1fc;
    }
    .popular-badge {
      background: linear-gradient(90deg, #ffe072 0%, #ffca3a 100%);
      color: #3d2c00;
      font-size: 0.85em;
      font-weight: 600;
      border-radius: 8px;
      padding: 2px 10px;
      margin-left: 8px;
    }

    .announcement-sidebar {
      width: 390px;
      min-width: 290px;
      max-width: 420px;
      background: rgba(255,255,255,0.17);
      border-radius: 24px;
      box-shadow: 0 12px 50px rgba(70, 66, 124, 0.10);
      padding: 32px 30px 22px 30px;
      margin-top: 90px;
      margin-left: 18px;
      position: sticky;
      top: 92px;
      height: fit-content;
      z-index: 2;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
    }
    .announcement-titlebar {
      font-size: 2rem;
      font-weight: 800;
      color: #37316b;
      margin-bottom: 22px;
      display: flex;
      align-items: center;
      gap: 13px;
      font-family: inherit;
      line-height: 1.2;
    }
    .announcements-list {
      width: 100%;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .announcement-card {
      background: #fff;
      border-radius: 15px;
      box-shadow: 0 8px 20px rgba(120, 109, 173, 0.11);
      padding: 1.15rem 1.2rem 0.8rem 1.2rem;
      border: 1.5px solid #e2e8f0;
      border-left: 4px solid #76a4fa;
      margin-bottom: 0;
    }
    .announcement-title {
      font-weight: 700;
      color: #4952c9;
      font-size: 1.08em;
      margin-bottom: 1px;
    }
    .announcement-date {
      color: #e0b508;
      font-size: 0.92em;
      margin-left: 8px;
      font-weight: 500;
    }
    .announcement-msg {
      color: #43486c;
      font-size: 1.01em;
      margin-top: 3px;
      line-height: 1.55;
    }
    @media (max-width: 1200px) {
      .page-content { flex-direction: column; align-items: center; }
      .announcement-sidebar { margin-left: 0; margin-top: 24px; width: 98vw; max-width: 600px;}
      .main-center { max-width: 97vw; }
    }
    @media (max-width: 700px) {
      .main-center, .announcement-sidebar { padding: 4vw 3vw; }
      .header-bar { top: 12px; right: 6vw;}
      .logo-link { left: 10px !important; top: 12px !important;}
      .announcement-titlebar, .quiz-section-title { font-size: 1.14rem;}
    }
  </style>
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
      <h1><i class="fas fa-graduation-cap"></i> Welcome to QuizApp!</h1>
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
