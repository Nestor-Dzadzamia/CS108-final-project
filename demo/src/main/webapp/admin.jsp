<%@ page import="Models.Announcement" %>
<%@ page import="Models.Quiz" %>
<%@ page import="Models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="DAO.QuizDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  User sessionUser = (User) session.getAttribute("user");
  if (sessionUser == null || !"admin".equals(sessionUser.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }

  QuizDao quizDao = new QuizDao();
  List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
  List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
  List<User> foundUsers = (List<User>) request.getAttribute("foundUsers");
  List<User> adminUsers = (List<User>) request.getAttribute("adminUsers");

  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");
  String userSearchError = (String) request.getAttribute("userSearchError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - QuizApp</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      min-height: 100vh;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      color: #232046;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 1120px;
      margin: 3rem auto 0 auto;
      padding: 2rem;
    }
    .admin-user {
      position: fixed;
      top: 24px;
      right: 44px;
      font-weight: 600;
      color: #fff;
      z-index: 10;
      background: rgba(80,70,180,0.32);
      border-radius: 18px;
      padding: 0.7rem 1.4rem;
      font-size: 1.08rem;
      box-shadow: 0 6px 18px rgba(60,70,140,0.07);
    }
    .admin-user a {
      color: #fff8;
      margin-left: 1.1em;
      text-decoration: underline;
    }
    .admin-title {
      font-size: 2.5rem;
      font-weight: 900;
      color: #fff;
      margin-bottom: 20px;
      letter-spacing: 2px;
      text-shadow: 0 2px 20px #764ba2bb;
      text-align: center;
    }
    .section {
      margin-bottom: 3.5rem;
      background: rgba(255,255,255,0.28);
      padding: 2.2rem 2.1rem 1.6rem 2.1rem;
      border-radius: 2.2rem;
      box-shadow: 0 12px 44px rgba(70, 85, 160, 0.08);
      backdrop-filter: blur(12px);
      border: 1.5px solid rgba(160,170,255,0.13);
    }
    .section-title {
      font-size: 1.4rem;
      font-weight: 700;
      margin-bottom: 1.3rem;
      color: #43326e;
      display: flex;
      align-items: center;
      gap: 0.6em;
      letter-spacing: 0.5px;
    }
    .alert {
      padding: 1.05rem 1.4rem;
      border-radius: 14px;
      margin-bottom: 2rem;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 0.9em;
      font-size: 1.1rem;
    }
    .alert-danger {
      background: linear-gradient(135deg, #fee2e2, #fecaca);
      color: #c8002f;
      border: 1px solid #ef4444;
    }
    .alert-success {
      background: linear-gradient(135deg, #d1fae5, #a7f3d0);
      color: #057857;
      border: 1px solid #10b981;
    }
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 0.8em;
      font-size: 1.06rem;
      background: transparent;
    }
    th, td {
      padding: 0.82em 0.95em;
      border: none;
      text-align: left;
    }
    th {
      color: #353556;
      font-weight: 700;
      font-size: 1.02em;
      border-bottom: 2.5px solid #d7daf3;
    }
    tr {
      background: rgba(255,255,255,0.88);
      border-radius: 15px;
      box-shadow: 0 4px 14px rgba(135,120,200,0.06);
      transition: box-shadow 0.18s;
    }
    tr:hover {
      box-shadow: 0 8px 26px #764ba21a;
      background: #f8f9fe;
    }
    .remove-btn {
      background: linear-gradient(135deg, #ff6c5b, #fd475a);
      color: #fff;
      border: none;
      border-radius: 14px;
      padding: 7px 20px;
      font-size: 1.04em;
      font-weight: 600;
      transition: background 0.18s;
      box-shadow: 0 2px 10px #ffdadb3a;
      cursor: pointer;
    }
    .remove-btn:hover { background: linear-gradient(135deg, #cf2a5a, #5d1565);}
    .add-btn {
      background: linear-gradient(135deg, #6c60e6, #48bb78);
      color: #fff;
      border: none;
      border-radius: 12px;
      padding: 9px 23px;
      font-size: 1.03em;
      font-weight: 700;
      margin-left: 0.2em;
      transition: background 0.18s;
      box-shadow: 0 2px 12px #6c60e653;
    }
    .add-btn:hover { background: linear-gradient(135deg, #4059a8, #13766a);}
    input, select, textarea {
      border-radius: 12px;
      border: 2px solid #e5e7eb;
      padding: 0.74rem 1.07rem;
      font-size: 1.04rem;
      background: #fafafd;
      font-family: inherit;
      margin-bottom: 0.5rem;
      box-shadow: 0 2px 6px #aea8e71a;
      transition: border 0.17s;
    }
    input:focus, select:focus, textarea:focus {
      outline: none;
      border-color: #764ba2;
      background: #f5f7ff;
    }
    .text-muted { color: #bbbcc8 !important; }
    @media (max-width: 900px) {
      .container { padding: 0.7rem; }
      .section { padding: 1.4rem; }
      .admin-user { right: 8px; top: 9px; }
      .admin-title { font-size: 1.6rem; }
      th, td { font-size: 0.99em; }
    }
  </style>
</head>
<body>
<div class="admin-user">
  <i class="fas fa-user-shield"></i>
  Logged in as: <%= sessionUser.getUsername() %> (admin)
  | <a href="logout.jsp">Logout</a>
</div>
<div class="container">
  <div class="admin-title"><i class="fas fa-screwdriver-wrench"></i> Admin Dashboard</div>
  <div class="section" style="margin-bottom:2rem;">
    <div class="section-title"><i class="fas fa-chart-bar"></i> Site Statistics</div>
    <div style="display:flex; gap:3em; flex-wrap:wrap; font-size:1.22em; font-weight:600;">
      <div>
        <span style="color:#667eea"><i class="fas fa-users"></i> Total Users:</span>
        <span style="color:#667eea"><%= request.getAttribute("totalUsers") %></span>
      </div>
      <div>
        <span style="color:#667eea"><i class="fas fa-trophy"></i> Total Quizzes Taken:</span>
        <span style="color:#667eea"><%= request.getAttribute("totalQuizzesTaken") %></span>
      </div>
    </div>
  </div>

  <!-- Admin Users Section -->
  <div class="section">
    <div class="section-title"><i class="fas fa-user-shield"></i> Current Admins</div>
    <% if (adminUsers != null && !adminUsers.isEmpty()) { %>
    <table>
      <thead>
      <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Quizzes Created</th>
        <th>Registration Date</th>
      </tr>
      </thead>
      <tbody>
      <% for (User admin : adminUsers) { %>
      <tr>
        <td><%= admin.getId() %></td>
        <td>
          <%= admin.getUsername() %>
          <% if (sessionUser.getId() == admin.getId()) { %>
          <span style="color: #667eea; font-weight: bold;">(You)</span>
          <% } %>
        </td>
        <td><%= admin.getEmail() %></td>
        <td><%= admin.getNumQuizzesCreated() %></td>
        <td><%= admin.getTimeCreated() != null ?
                new java.text.SimpleDateFormat("yyyy-MM-dd").format(admin.getTimeCreated()) : "N/A" %></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <div style="margin-top: 0.5em; color: #667eea; font-size: 0.9em;">
      <i class="fas fa-info-circle"></i> Total Admins: <%= adminUsers.size() %>
    </div>
    <% } else { %>
    <div style="text-align: center; padding: 2em; color: #999;">
      <i class="fas fa-user-shield" style="font-size: 2em; margin-bottom: 0.5em;"></i>
      <div>No admin users found</div>
    </div>
    <% } %>
  </div>


  <% if (error != null) { %>
  <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
  <% } %>
  <% if (success != null) { %>
  <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
  <% } %>

  <!-- Announcements Section -->
  <div class="section">
    <div class="section-title"><i class="fas fa-bullhorn"></i> Announcements</div>
    <form method="post" action="admin">
      <input type="hidden" name="action" value="add-announcement">
      <div style="display: flex; gap: 1em; align-items: center; flex-wrap: wrap;">
        <input type="text" name="title" class="form-control" placeholder="Announcement Title" required style="flex:2;">
        <input type="text" name="message" class="form-control" placeholder="Announcement Message" required style="flex:4;">
        <button type="submit" class="add-btn"><i class="fas fa-plus"></i> Add</button>
      </div>
    </form>
    <table>
      <thead>
      <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Message</th>
        <th>Active</th>
        <th>Remove</th>
      </tr>
      </thead>
      <tbody>
      <% if (announcements != null) for (Announcement a : announcements) { %>
      <tr>
        <td><%= a.getAnnouncementId() %></td>
        <td><%= a.getTitle() %></td>
        <td><%= a.getMessage() %></td>
        <td><%= a.getIsActive() ? "Yes" : "No" %></td>
        <td>
          <form method="post" action="admin" style="display:inline;">
            <input type="hidden" name="action" value="remove-announcement">
            <input type="hidden" name="id" value="<%= a.getAnnouncementId() %>">
            <button class="remove-btn" type="submit" onclick="return confirm('Remove announcement?')">
              <i class="fas fa-trash"></i> Remove
            </button>
          </form>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
  </div>

  <!-- Quizzes Section -->
  <div class="section">
    <div class="section-title"><i class="fas fa-trophy"></i> All Quizzes</div>
    <table>
      <thead>
      <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Creator</th>
        <th>Remove</th>
      </tr>
      </thead>
      <tbody>
      <% if (quizzes != null) for (Quiz q : quizzes) { %>
      <tr>
        <td><%= q.getQuizId() %></td>
        <td><%= q.getQuizTitle() %></td>
        <td><%= quizDao.getCreatorUsernameByQuizId(q.getQuizId()) %></td>
        <td>
          <form method="post" action="admin" style="display:inline;">
            <input type="hidden" name="action" value="remove-quiz">
            <input type="hidden" name="id" value="<%= q.getQuizId() %>">
            <button class="remove-btn" type="submit" onclick="return confirm('Remove quiz?')">
              <i class="fas fa-trash"></i> Remove
            </button>
          </form>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
  </div>

  <!-- Users Section -->
  <div class="section">
    <div class="section-title"><i class="fas fa-users"></i> Find Users by Username</div>
    <form method="get" action="admin" style="display: flex; gap: 0.8em; align-items: center; flex-wrap: wrap;">
      <input type="text" name="searchUsername" class="form-control" placeholder="Type username or part" required style="flex:2;">
      <button type="submit" class="add-btn" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <i class="fas fa-search"></i> Search
      </button>
    </form>
    <% if (userSearchError != null) { %>
    <div class="alert alert-danger" style="margin-top:1em;"><i class="fas fa-exclamation-circle"></i> <%= userSearchError %></div>
    <% } %>
    <% if (foundUsers != null && !foundUsers.isEmpty()) { %>
    <table class="table table-sm mt-2">
      <thead>
      <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Role</th>
        <th>Actions</th> <!-- Changed from "Remove" to "Actions" -->
      </tr>
      </thead>
      <tbody>
      <% for (User u : foundUsers) { %>
      <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getUsername() %></td>
        <td><%= u.getEmail() %></td>
        <td><%= u.getRole() %></td>
        <td>
          <% if (sessionUser.getId() != u.getId()) { %>
          <!-- Promote button (only for non-admin users) -->
          <% if (!"admin".equals(u.getRole())) { %>
          <form method="post" action="admin" style="display:inline; margin-right:5px;">
            <input type="hidden" name="action" value="promote-user">
            <input type="hidden" name="id" value="<%= u.getId() %>">
            <button class="add-btn" type="submit" onclick="return confirm('Promote <%= u.getUsername() %> to admin?')"
                    style="padding:6px 12px; font-size:0.9em;">
              <i class="fas fa-user-shield"></i> Promote
            </button>
          </form>
          <% } %>
          <!-- Remove button -->
          <form method="post" action="admin" style="display:inline;">
            <input type="hidden" name="action" value="remove-user">
            <input type="hidden" name="id" value="<%= u.getId() %>">
            <button class="remove-btn" type="submit" onclick="return confirm('Remove user?')">
              <i class="fas fa-user-times"></i> Remove
            </button>
          </form>
          <% } else { %>
          <span class="text">You</span>
          <% } %>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
</body>
</html>
