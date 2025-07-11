<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign Up - QuizApp</title>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #e9edfb 60%, #764ba2 100%);
            padding: 50px 0;
            min-height: 100vh;
        }
        .form-container {
            background: rgba(255,255,255,0.93);
            padding: 2.8rem 2.2rem 2.3rem 2.2rem;
            border-radius: 1.6rem;
            max-width: 420px;
            margin: 3rem auto 0 auto;
            box-shadow: 0 8px 40px rgba(78,84,200,0.13), 0 2px 12px rgba(120, 70, 200, 0.07);
            border: 1.5px solid #d7daf3;
            transition: box-shadow 0.22s;
        }
        .form-container h2 {
            font-weight: 900;
            font-size: 2.1rem;
            letter-spacing: 1px;
            color: #443380;
            margin-bottom: 20px;
            text-align: center;
        }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 13px 14px;
            margin-top: 8px;
            margin-bottom: 23px;
            border: 2px solid #e5e7eb;
            border-radius: 14px;
            background: #f6f8fe;
            font-size: 1.08rem;
            box-shadow: 0 2px 8px #764ba217;
            transition: border 0.17s;
        }
        input[type="text"]:focus, input[type="email"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #764ba2;
            background: #f5f7ff;
        }
        label {
            font-weight: 600;
            color: #4c397a;
            margin-bottom: 3px;
            margin-top: 3px;
            display: block;
        }
        button {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 14px;
            font-weight: 700;
            font-size: 1.11rem;
            letter-spacing: .5px;
            margin-top: 10px;
            box-shadow: 0 2px 14px #6c60e634;
            transition: background 0.18s, box-shadow 0.17s;
            cursor: pointer;
        }
        button:hover {
            background: linear-gradient(135deg, #4a46b8 0%, #753b99 100%);
            box-shadow: 0 4px 32px #6c60e664;
        }
        .error {
            color: #b82532;
            margin-bottom: 15px;
            font-weight: 700;
            background: #fee2e2;
            padding: 0.75em 1em;
            border-radius: 10px;
            text-align: center;
        }
        .form-container p {
            text-align: center;
            margin-top: 16px;
            font-size: 1.04em;
            color: #6e6589;
        }
        .form-container a {
            color: #667eea;
            text-decoration: underline;
            font-weight: 600;
        }
        .form-container a:hover {
            color: #764ba2;
        }
        .logo-home {
            box-shadow: 0 4px 16px rgba(78,84,200,0.13);
            border-radius: 16px;
            transition: 0.18s;
        }
        .logo-home:hover {
            box-shadow: 0 8px 32px rgba(78,84,200,0.25);
            transform: scale(1.09) rotate(-2deg);
            cursor: pointer;
        }
    </style>
</head>
<body>
<a href="<%= request.getContextPath() %>/"
   style="position: absolute; top: 24px; left: 24px; z-index: 1000; text-decoration: none;">
    <img src="<%= request.getContextPath() %>/images/quiz_icon.png"
         alt="Quiz App Home"
         class="logo-home"
         style="height:70px; width:auto;">
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
    <p>Already have an account? <a href="login.jsp">Login here</a></p>
</div>
</body>
</html>
