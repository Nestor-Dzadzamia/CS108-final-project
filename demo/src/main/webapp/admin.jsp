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
  <link rel="stylesheet" href="Styles/admin.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="admin-user">
  <i class="fas fa-user-shield"></i>
  Logged in as: <%= sessionUser.getUsername() %> (admin)
  | <a href="logout.jsp">Logout</a>
</div>
<div class="container">
  <div class="admin-title"><i class="fas fa-screwdriver-wrench"></i> Admin Dashboard</div>

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
        <th>Remove</th>
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
          <form method="post" action="admin" style="display:inline;">
            <input type="hidden" name="action" value="remove-user">
            <input type="hidden" name="id" value="<%= u.getId() %>">
            <button class="remove-btn" type="submit" onclick="return confirm('Remove user?')"><i class="fas fa-user-times"></i> Remove</button>
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
