<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Logged Out</title>
  <link rel="stylesheet" href="Styles/logout.css">
</head>
<body>
<div class="logout-box">
  <h1>You have been logged out.</h1>
  <p>Thank you for using our platform!</p>
  <a href="login.jsp" class="button">Log In Again</a>
</div>

<script>
  setTimeout(function() {
    window.location.href = '<%= request.getContextPath() %>/index.jsp';
  }, 3000);
</script>
</body>
</html>
