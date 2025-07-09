<%@ page import="DAO.QuizDao" %>
<%@ page import="Models.Quiz" %>
<%@ page import="java.util.List" %>
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
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>QuizApp - Welcome</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: radial-gradient(circle at 70% 20%, #e9edfb 65%, #f4f7fd 100%);
      min-height: 100vh;
      margin: 0;
      padding: 0;
    }
    .logo-link {
      position: absolute;
      top: 24px;
      left: 24px;
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
    .header-bar {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 32px 48px 0 48px;
      background: none;
      z-index: 2;
      position: relative;
    }
    .header-bar .nav-btn {
      margin-left: 18px;
      padding: 9px 28px;
      border-radius: 12px;
      font-size: 1.06rem;
      font-weight: 600;
      text-decoration: none;
      background: linear-gradient(100deg, #4e54c8 70%, #8f94fb 120%);
      color: #fff !important;
      box-shadow: 0 2px 12px rgba(78,84,200,0.13);
      border: none;
      transition: all 0.16s cubic-bezier(.4,2,.5,.75);
      display: inline-block;
      position: relative;
      top: 0;
    }
    .header-bar .nav-btn.outline {
      background: #fff;
      color: #4e54c8 !important;
      border: 2px solid #4e54c8;
      box-shadow: 0 2px 10px rgba(78,84,200,0.08);
    }
    .header-bar .nav-btn:hover {
      transform: scale(1.07) translateY(-2px);
      box-shadow: 0 6px 22px rgba(78,84,200,0.22);
      color: #ffd600 !important;
      text-decoration: none;
      background: linear-gradient(90deg, #4952c9 60%, #ffd600 140%);
    }
    .header-bar .nav-btn.outline:hover {
      color: #4952c9 !important;
      background: #fffdfa;
      border-color: #ffd600;
    }
    .page-title-outer {
      width: 100%;
      margin-top: 38px;
      margin-bottom: 18px;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .page-title {
      font-size: 2.5rem;
      font-weight: 800;
      color: #343a60;
      text-shadow: 0 2px 14px #fff;
      margin: 0 auto 0 auto;
      letter-spacing: .7px;
    }
    .main-content {
      max-width: 790px;
      margin: 0 auto 0 auto;
      background: #fff;
      border-radius: 30px;
      box-shadow: 0 8px 32px rgba(78,84,200,0.08), 0 1.5px 0 #f9e79f;
      padding: 42px 42px 28px 42px;
    }
    .section-title {
      font-weight: 800;
      font-size: 1.4rem;
      color: #323268;
      margin-top: 24px;
      margin-bottom: 10px;
      letter-spacing: 0.5px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .quiz-item {
      background: #fafdff;
      padding: 18px 18px 13px 22px;
      margin-bottom: 18px;
      border-radius: 13px;
      box-shadow: 0 2px 10px rgba(78,84,200,0.06);
      transition: transform 0.17s, box-shadow 0.17s;
      border-left: 4px solid #ffd600;
      position: relative;
    }
    .quiz-item:hover {
      transform: scale(1.02) translateY(-2px);
      box-shadow: 0 8px 24px rgba(78,84,200,0.16);
      background: #f3f6ff;
      z-index: 1;
    }
    .quiz-title-link {
      color: #5837fa;
      font-size: 1.08rem;
      font-weight: bold;
      text-decoration: none;
      transition: color 0.17s;
    }
    .quiz-title-link:hover {
      color: #ff9100;
      text-decoration: underline;
    }
    .quiz-meta {
      color: #55597a;
      font-size: .97em;
    }
    .quiz-desc {
      color: #37456a;
      font-size: 0.98rem;
      letter-spacing: 0.2px;
      font-style: italic;
    }
    .popular-badge {
      background: linear-gradient(90deg, #ffe072 0%, #ffca3a 100%);
      color: #3d2c00;
      font-size: 0.86em;
      font-weight: 600;
      border-radius: 9px;
      padding: 2px 10px;
      margin-left: 8px;
    }
    @media (max-width: 900px) {
      .main-content { padding: 28px 7vw 18px 7vw; }
      .header-bar { padding: 22px 10vw 0 7vw;}
    }
    @media (max-width: 700px) {
      .main-content { padding: 14px 2vw 8px 2vw; }
      .header-bar { padding: 10px 3vw 0 2vw;}
      .page-title { font-size: 1.4rem;}
    }
  </style>
</head>
<body>
<a href="<%= request.getContextPath() %>/" class="logo-link">
  <img src="<%= request.getContextPath() %>/images/quiz_icon.png"
       alt="Quiz App Home"
       class="logo-img">
</a>


<div class="header-bar">
  <a href="login.jsp" class="nav-btn outline">Login</a>
  <a href="signup.jsp" class="nav-btn">Sign Up</a>
</div>

<div class="page-title-outer">
  <h1 class="page-title">Welcome to QuizApp!</h1>
</div>

<div class="main-content">
  <div class="section-title">Administration Announcements</div>
  <p style="margin-bottom:20px;">No announcements yet. Stay tuned!</p>

  <div class="section-title">Top 10 Popular Quizzes</div>
  <% if (quizError != null) { %>
  <p style="color:red;">Error loading popular quizzes: <%= quizError %></p>
  <% } else if (popularQuizzes != null && !popularQuizzes.isEmpty()) {
    for (Quiz quiz : popularQuizzes) { %>
  <div class="quiz-item">
    <a href="quiz-summary.jsp?quizId=<%= quiz.getQuizId() %>" class="quiz-title-link"><%= quiz.getQuizTitle() %></a>
    <span class="popular-badge">Popular</span><br>
    <span class="quiz-meta">
       By <a href="friends?action=profile&userId=<%= quiz.getCreatedBy() %>"><%= quizDao.getCreatorUsernameByQuizId(quiz.getQuizId()) != null ? quizDao.getCreatorUsernameByQuizId(quiz.getQuizId()) : "Unknown" %></a>
          &bull; Taken <%= quiz.getSubmissionsNumber() %> times
        </span><br>
    <span class="quiz-desc"><%= quiz.getDescription() == null ? "No description available." : quiz.getDescription() %></span>
  </div>
  <%   }
  } else { %>
  <p>No popular quizzes found.</p>
  <% } %>
</div>

</body>
</html>
