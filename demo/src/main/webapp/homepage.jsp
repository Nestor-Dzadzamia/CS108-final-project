<%@ page import="java.util.List" %>
<%@ page import="Models.Quiz" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz App - Home</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
    >
    <style>
        body {
            background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Helvetica Neue', sans-serif;
        }
        .quiz-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .hero {
            background: linear-gradient(135deg, #4e54c8, #8f94fb);
            color: white;
            padding: 3rem;
            border-radius: 1rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        .hero h1 {
            font-weight: 700;
        }
        .btn-primary {
            background-color: #4e54c8;
            border: none;
        }
        .btn-primary:hover {
            background-color: #5f63d2;
        }
    </style>
</head>
<body>
<div class="container py-4">

    <!-- HERO SECTION -->
    <div class="hero">
        <h1>Welcome to the Quiz App</h1>
        <p class="lead">Challenge yourself, test your knowledge, and create amazing quizzes!</p>
        <form action="create-quiz-setup" method="get">
            <button class="btn btn-primary btn-lg mt-3">Create New Quiz</button>
        </form>
    </div>

    <!-- RECENT QUIZZES -->
    <h2 class="mb-4">Recent Quizzes</h2>
    <div class="row g-4">
        <%
            List<Quiz> recent = (List<Quiz>) request.getAttribute("recentQuizzes");
            if (recent != null && !recent.isEmpty()) {
                for (Quiz quiz : recent) {
        %>
        <div class="col-md-4">
            <div class="card quiz-card shadow-sm h-100">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><%= quiz.getTitle() %></h5>
                    <p class="card-text flex-grow-1"><%= quiz.getDescription() == null ? "No description available." : quiz.getDescription() %></p>
                    <small class="text-muted">Created by <%= quiz.getCreator() %></small>
                    <a href="takeQuiz?id=<%= quiz.getId() %>" class="btn btn-outline-primary mt-3">Take Quiz</a>
                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div class="col-12">
            <div class="alert alert-info">No recent quizzes found.</div>
        </div>
        <%
            }
        %>
    </div>

    <!-- USER PAGE -->
    <div class="text-center mt-5">
        <form action="user" method="get">
            <button type="submit" class="btn btn-secondary">Go to My Page</button>
        </form>
    </div>

</div>

<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
></script>
</body>
</html>
