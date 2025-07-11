<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign Up - QuizApp</title>
    <link rel="stylesheet" href="Styles/signup.css">
</head>
<body>
<a href="<%= request.getContextPath() %>/"
   class="logo-link">
    <img src="<%= request.getContextPath() %>/images/quiz_icon.png"
         alt="Quiz App Home"
         class="logo-home">
</a>

<div class="form-container">
    <h2>Create Your Account</h2>

    <% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form method="post" action="signup">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Email (must end with @gmail.com)</label>
        <input type="email" name="email" required pattern=".*@gmail\.com">

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit">Sign Up</button>
    </form>

    <p style="margin-top:15px;">Already have an account? <a href="login.jsp">Login here</a></p>
</div>
</body>
</html>
