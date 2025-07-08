<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Logged Out</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f8f9fa;
      text-align: center;
      margin-top: 10%;
      color: #333;
    }
    .logout-box {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      display: inline-block;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    .message {
      font-size: 1.2em;
      margin-bottom: 1rem;
    }
    .redirect-info {
      color: #666;
      font-size: 0.9em;
    }
  </style>
</head>
<body>
<div class="logout-box">
  <h1>You have been logged out.</h1>
  <p class="message">Thank you for using our platform!</p>
  <p class="redirect-info">Redirecting to login page...</p>
</div>

<script>
  setTimeout(function() {
    window.location.href = '<%= request.getContextPath() %>/index.jsp';
  }, 2000);
</script>

</body>
</html>