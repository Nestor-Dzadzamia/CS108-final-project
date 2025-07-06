<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet"
  />
  <style>
    body {
      background-color: #f5f5f5;
    }
    .dashboard-card {
      transition: transform 0.2s ease-in-out;
    }
    .dashboard-card:hover {
      transform: scale(1.02);
    }
    .dashboard-title {
      margin-top: 2rem;
      text-align: center;
    }
  </style>
</head>
<body>
<div class="container mt-4">
  <h1 class="dashboard-title">Admin Dashboard</h1>
  <div class="row mt-4 g-4">
    <div class="col-md-4">
      <div class="card dashboard-card shadow-sm p-3">
        <h4>Manage Users</h4>
        <p class="text-muted">View, edit or delete user accounts.</p>
        <a href="manageUsers.jsp" class="btn btn-primary">Go</a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card dashboard-card shadow-sm p-3">
        <h4>Manage Quizzes</h4>
        <p class="text-muted">Moderate or delete inappropriate quizzes.</p>
        <a href="manageQuizzes.jsp" class="btn btn-primary">Go</a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card dashboard-card shadow-sm p-3">
        <h4>Achievements</h4>
        <p class="text-muted">Create and assign achievements to users.</p>
        <a href="manageAchievements.jsp" class="btn btn-primary">Go</a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card dashboard-card shadow-sm p-3">
        <h4>Site Analytics</h4>
        <p class="text-muted">View usage statistics and reports.</p>
        <a href="analytics.jsp" class="btn btn-primary">Go</a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card dashboard-card shadow-sm p-3">
        <h4>Settings</h4>
        <p class="text-muted">Configure site-wide settings.</p>
        <a href="settings.jsp" class="btn btn-primary">Go</a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card dashboard-card shadow-sm p-3">
        <h4>Logout</h4>
        <p class="text-muted">Sign out of the admin panel.</p>
        <form action="logout" method="post">
          <button type="submit" class="btn btn-danger">Logout</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
></script>
</body>
</html>
