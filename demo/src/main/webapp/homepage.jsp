<%@ page import="DAO.QuizDao" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%
    QuizDao quizDao = new QuizDao();

    Long quizStartTime = (Long) session.getAttribute("quizStartTime");
    if(quizStartTime != null) session.removeAttribute("quizStartTime");

    String titleFilter = request.getParameter("title") != null ? request.getParameter("title").trim().toLowerCase() : "";
    String creatorFilter = request.getParameter("creator") != null ? request.getParameter("creator").trim().toLowerCase() : "";
    String categoryFilter = request.getParameter("category") != null ? request.getParameter("category").toLowerCase() : "";
    String sortBy = request.getParameter("sort") != null ? request.getParameter("sort") : "";

    List<Map<String, Object>> allQuizzes = quizDao.getAllQuizzesWithDetails();

    Set<String> categoryNames = new TreeSet<>();
    for (Map<String, Object> q : allQuizzes) {
        String cat = q.get("category_name") != null ? q.get("category_name").toString() : "Uncategorized";
        if (!cat.trim().isEmpty()) categoryNames.add(cat);
    }

    List<Map<String, Object>> quizzes = new ArrayList<>();
    for (Map<String, Object> quiz : allQuizzes) {
        String quizTitle = quiz.get("quiz_title") != null ? quiz.get("quiz_title").toString().toLowerCase() : "";
        String quizCreator = quiz.get("creator_name") != null ? quiz.get("creator_name").toString().toLowerCase() : "";
        String quizCategory = quiz.get("category_name") != null ? quiz.get("category_name").toString().toLowerCase() : "";
        boolean match = true;
        if (!titleFilter.isEmpty() && !quizTitle.contains(titleFilter)) match = false;
        if (!creatorFilter.isEmpty() && !quizCreator.contains(creatorFilter)) match = false;
        if (!categoryFilter.isEmpty() && !quizCategory.equals(categoryFilter)) match = false;
        if (match) quizzes.add(quiz);
    }
    if ("newest".equals(sortBy)) {
        quizzes.sort((a, b) -> {
            Timestamp ta = (Timestamp)a.get("created_at");
            Timestamp tb = (Timestamp)b.get("created_at");
            return tb.compareTo(ta);
        });
    } else if ("oldest".equals(sortBy)) {
        quizzes.sort((a, b) -> {
            Timestamp ta = (Timestamp)a.get("created_at");
            Timestamp tb = (Timestamp)b.get("created_at");
            return ta.compareTo(tb);
        });
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz App - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="Styles/homepage.css">
</head>
<body>
<div class="navbar-profile">
    <form action="user" method="get" style="display:inline;">
        <button type="submit" class="btn-flashy"><i class="fas fa-user-circle"></i> <span style="margin-left:0.55em;">My Profile</span></button>
    </form>
</div>
<div class="container py-4">
    <div class="hero mb-4">
        <h1>Welcome to the Quiz App</h1>
        <p class="lead">Challenge yourself, test your knowledge, and create amazing quizzes!</p>
        <div class="btn-flashy-group">
            <form action="create-quiz-setup" method="get" class="d-inline">
                <button class="btn-flashy" type="submit"><i class="fas fa-plus-circle"></i> <span style="margin-left:0.54em;">Create New Quiz</span></button>
            </form>
            <a href="friends" class="btn-flashy"><i class="fas fa-user-friends"></i> <span style="margin-left:0.6em;">Find Friends</span></a>
            <a href="message" class="btn-flashy"><i class="fas fa-comments"></i> <span style="margin-left:0.63em;">Chat with Friends</span></a>
        </div>
    </div>
    <div class="main-content-flex">
        <div class="quizzes-main-section">
            <h2 class="fw-bold mb-4 text-left"> Quiz List </h2>
            <div class="row" id="quizResultsList">
                <% if (quizzes.size() == 0) { %>
                <div class="col-12"><div class="alert alert-warning text-center">No quizzes found with these filters.</div></div>
                <% } %>
                <% for (Map<String, Object> quiz : quizzes) { %>
                <div class="col-12 quiz-item mb-4">
                    <div class="quiz-card h-100">
                        <h5 class="fw-bold mb-2 quiz-title-link">
                            <a href="quiz-summary.jsp?quizId=<%=quiz.get("quiz_id")%>">
                                <%= quiz.get("quiz_title") != null ? quiz.get("quiz_title") : "Untitled" %>
                            </a>
                        </h5>
                        <div class="quiz-meta">
                            <i class="fas fa-user"></i>
                            <%= quiz.get("creator_name") != null && !quiz.get("creator_name").toString().trim().isEmpty() ? quiz.get("creator_name") : "Unknown" %>
                            <span class="quiz-category"><i class="fas fa-tag"></i>
                                <%= quiz.get("category_name") != null && !quiz.get("category_name").toString().trim().isEmpty() ? quiz.get("category_name") : "Uncategorized" %>
                            </span>
                        </div>
                        <div class="quiz-desc"><%= quiz.get("description") != null ? quiz.get("description") : "" %></div>
                        <a href="quiz-summary.jsp?quizId=<%=quiz.get("quiz_id")%>" class="btn-summary align-self-end">
                            <i class="fas fa-eye"></i>
                            <span style="margin-left:0.64em;">View Summary</span>
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <!-- FILTERS -->
        <aside class="sidebar-filters shadow ms-2">
            <h4><i class="fas fa-filter"></i> <span style="margin-left:0.5em;">Filter Quizzes</span></h4>
            <form method="get" action="homepage.jsp">
                <div class="mb-2">
                    <label class="filter-label" for="quizSearch">Quiz Title</label>
                    <input type="text" name="title" class="form-control" placeholder="Quiz title..." value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
                </div>
                <div class="mb-2">
                    <label class="filter-label" for="creatorFilter">Creator</label>
                    <input type="text" name="creator" class="form-control" placeholder="Creator name..." value="<%= request.getParameter("creator") != null ? request.getParameter("creator") : "" %>">
                </div>
                <div class="mb-2">
                    <label class="filter-label" for="categoryFilter">Category</label>
                    <select name="category" class="form-select">
                        <option value="">All categories</option>
                        <% for (String cat : categoryNames) { %>
                        <option value="<%= cat.toLowerCase() %>" <%= cat.equalsIgnoreCase(categoryFilter) ? "selected" : "" %>><%= cat %></option>
                        <% } %>
                    </select>
                </div>
                <div class="mb-2">
                    <label class="filter-label" for="recentFilter">Sort by date</label>
                    <select name="sort" class="form-select">
                        <option value="">Date</option>
                        <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Newest First</option>
                        <option value="oldest" <%= "oldest".equals(sortBy) ? "selected" : "" %>>Oldest First</option>
                    </select>
                </div>
                <div class="mt-4 text-center">
                    <button type="submit" class="btn-flashy w-100"><i class="fas fa-search"></i> <span style="margin-left:0.7em;">Filter</span></button>
                </div>
            </form>
        </aside>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
