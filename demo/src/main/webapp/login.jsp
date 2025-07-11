<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - QuizApp</title>
    <link rel="stylesheet" href="Styles/login.css">
</head>
<body>
<a href="<%= request.getContextPath() %>/"
   class="logo-home-link">
    <img src="images/quiz_icon.png"
         alt="Quiz App Home"
         class="logo-home">
</a>

<div class="form-container">
    <h2>Login to QuizApp</h2>

    <% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form method="post" action="login">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit">Login</button>
    </form>

    <p style="margin-top:15px;">Don't have an account? <a href="signup.jsp">Sign up here</a></p>
</div>
</body>
</html>
