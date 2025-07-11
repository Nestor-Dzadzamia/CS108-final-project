<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Logged Out</title>
  <style>
    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: linear-gradient(135deg, #e9edfb 60%, #764ba2 100%);
      min-height: 100vh;
      text-align: center;
      color: #333;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .logout-box {
      background: rgba(255,255,255,0.98);
      padding: 2.2rem 2.3rem;
      border-radius: 1.7rem;
      box-shadow: 0 8px 34px #6c60e644;
      border: 1.5px solid #d7daf3;
      margin: auto;
      display: inline-block;
      min-width: 320px;
      margin-top: 9vh;
      animation: fadeIn 0.8s;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(32px);}
      to { opacity: 1; transform: none;}
    }
    .logout-box h1 {
      font-size: 2rem;
      font-weight: 900;
      margin-bottom: 8px;
      color: #4b3894;
    }
    .logout-box p {
      color: #443380;
      font-size: 1.09rem;
      margin-bottom: 24px;
    }
    a.button {
      display: inline-block;
      margin-top: 1rem;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 0.8rem 1.7rem;
      text-decoration: none;
      border-radius: 12px;
      font-weight: 700;
      font-size: 1.04rem;
      box-shadow: 0 2px 14px #6c60e634;
      transition: background 0.18s, box-shadow 0.14s;
    }
    a.button:hover {
      background: linear-gradient(135deg, #4a46b8 0%, #753b99 100%);
      box-shadow: 0 6px 26px #6c60e664;
    }
  </style>
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
