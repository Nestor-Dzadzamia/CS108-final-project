<%@ page import="DAO.QuizDao" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Quiz" %>
<%@ page import="DB.DBConnection" %>
<%
    QuizDao quizDao = new QuizDao();
%>
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
        .popular-section {
            margin-top: 4rem;
        }
        .popular-section h2 {
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
        }
        .popular-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .popular-card:hover {
            transform: scale(1.02);
        }
        .badge-popular {
            background: linear-gradient(135deg, #ff416c, #ff4b2b);
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
        <a href="friends" class="btn btn-outline-light btn-lg mt-2">Find Friends</a>
    </div>

    <!-- RECENT QUIZZES -->
    <h2 class="mb-4">Recent Quizzes</h2>
    <div class="row g-4">
        <%
            List<Quiz> recent = (List<Quiz>) request.getAttribute("recentQuizzes");
            if (recent != null && !recent.isEmpty()) {
                for (Quiz quiz : recent) {
                    String creatorUsername = "Unknown";
                    try {
                        creatorUsername = quizDao.getCreatorUsernameByQuizId(quiz.getQuizId());
                    } catch (Exception e) {
                        // You may want to log this in production
                    }
        %>
        <div class="col-md-4">
            <div class="card quiz-card shadow-sm h-100">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><%= quiz.getQuizTitle() %></h5>
                    <p class="card-text flex-grow-1"><%= quiz.getDescription() == null ? "No description available." : quiz.getDescription() %></p>
                    <small class="text-muted">Created by <%= creatorUsername %></small>
                    <a href="takeQuiz?id=<%= quiz.getQuizId() %>" class="btn btn-outline-primary mt-3">Take Quiz</a>
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
        <% } %>
    </div>

    <!-- TOP 10 POPULAR QUIZZES -->
    <div class="popular-section">
        <h2>Top 10 Popular Quizzes</h2>
        <div class="row g-4">
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    stmt = conn.prepareStatement(
                            "SELECT quiz_id, quiz_title, description, submissions_number, creator FROM view_popular_quizzes"
                    );
                    rs = stmt.executeQuery();
                    while (rs.next()) {
                        long quizId = rs.getLong("quiz_id");
                        String quizTitle = rs.getString("quiz_title");
                        String description = rs.getString("description");
                        long submissions = rs.getLong("submissions_number");
                        String creator = rs.getString("creator");
            %>
            <div class="col-md-4">
                <div class="popular-card p-3 h-100">
                    <h5 class="fw-bold mb-2"><%= quizTitle %>
                        <span class="badge badge-popular ms-2">Popular</span>
                    </h5>
                    <small class="text-muted">By <%= creator %> • <%= submissions %> taken</small>
                    <p class="mt-2"><%= description == null ? "No description." : description %></p>
                    <a href="quiz-summary.jsp?quizId=<%= quizId %>" class="btn btn-sm btn-primary mt-auto">View Summary</a>
                </div>
            </div>
            <%
                }
            } catch (Exception e) {
            %>
            <div class="col-12">
                <div class="alert alert-danger">Error loading popular quizzes: <%= e.getMessage() %></div>
            </div>
            <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </div>
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
