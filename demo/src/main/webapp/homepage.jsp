<%@ page import="DAO.QuizDao" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%
    QuizDao quizDao = new QuizDao();

    Long quizStartTime = (Long) session.getAttribute("quizStartTime");
    if(quizStartTime != null) session.removeAttribute("quizStartTime");

    String titleFilter = request.getParameter("title") != null ? request.getParameter("title").trim().toLowerCase() : "";
    String creatorFilter = request.getParameter("creator") != null ? request.getParameter("creator").trim().toLowerCase() : "";
    String categoryFilter = request.getParameter("category") != null ? request.getParameter("category").trim().toLowerCase() : "";
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
    <style>
        body {
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(135deg, #7f90ea 0%, #7c61d4 100%);
            min-height: 100vh;
        }
        .hero {
            background: rgba(255,255,255,0.09);
            border-radius: 28px;
            padding: 3.2rem 2.5rem 2.7rem 2.5rem;
            margin-bottom: 2.6rem;
            margin-top: 2.2rem;
            text-align: center;
            box-shadow: 0 6px 32px 0 #886eff1f;
            max-width: 1050px;
            margin-left: auto;
            margin-right: auto;
        }
        .hero h1 {
            font-weight: 800;
            font-size: 2.6rem;
            color: #fff;
            text-shadow: 0 2px 22px #958bff44;
            margin-bottom: 1.3rem;
            margin-top: 0.3rem;
        }
        .hero p.lead {
            color: #e5e6fa;
            font-size: 1.13rem;
            margin-bottom: 2rem;
            font-weight: 500;
            letter-spacing: 0.01em;
        }
        .btn-flashy-group {
            display: flex;
            gap: 1.2rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 0.2rem;
        }
        .btn-flashy {
            background: linear-gradient(90deg, #a38cf7 0%, #8c4fe7 100%);
            color: #fff !important;
            border: none !important;
            border-radius: 22px;
            font-size: 1.13rem;
            font-weight: 700;
            padding: 0.74rem 2.3rem;
            margin: 0 0.4rem 0.7rem 0.4rem;
            box-shadow: 0 3px 16px 0 rgba(120,110,255,0.20), 0 0px 8px 2px #ab8fff33;
            transition: all 0.18s cubic-bezier(.45,1.6,.64,1);
            position: relative;
            letter-spacing: 0.5px;
            outline: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.72em;
        }
        .btn-flashy:hover, .btn-flashy:focus {
            background: linear-gradient(90deg, #8c4fe7 0%, #a38cf7 100%);
            color: #fff;
            transform: translateY(-2px) scale(1.045);
            box-shadow: 0 7px 32px 4px #a38cf7aa, 0 0px 16px 2px #8c4fe7bb;
        }
        .btn-flashy:active {
            transform: scale(0.97);
            filter: brightness(0.97);
        }
        .btn-flashy i {
            font-size: 1.15em;
        }
        .navbar-profile {
            position: absolute;
            right: 55px;
            top: 33px;
            z-index: 2;
        }
        .main-content-flex {
            display: flex;
            align-items: flex-start;
            gap: 2.6rem;
            margin-top: 30px;
            justify-content: center;
            min-height: 65vh;
        }
        .quizzes-main-section {
            flex: 1 1 0;
            min-width: 340px;
            max-width: 850px;
            background: rgba(255,255,255,0.18);
            border-radius: 22px;
            padding: 2.1rem 2.2rem 1.8rem 2.2rem;
            box-shadow: 0 2px 22px 0 #b8a2ff17;
        }
        .quizzes-main-section h2 {
            color: #413cc9;
            font-weight: 800;
            font-size: 1.43rem;
            margin-bottom: 2.1rem;
            letter-spacing: 1.2px;
        }
        .sidebar-filters {
            width: 370px;
            min-width: 220px;
            background: rgba(255,255,255,0.94);
            border-radius: 20px;
            box-shadow: 0 4px 18px rgba(120, 109, 173, 0.09);
            padding: 2.4rem 2rem 2.2rem 2rem;
            position: sticky;
            top: 98px;
            height: fit-content;
        }
        .sidebar-filters h4 {
            font-size: 1.18rem;
            font-weight: 700;
            margin-bottom: 1.8rem;
            color: #7353df;
            letter-spacing: 1px;
        }
        .filter-label {
            font-size: 1.06rem;
            font-weight: 600;
            color: #434174;
            margin-bottom: .5rem;
            margin-top: 1.1rem;
        }
        .quiz-card {
            background: #f9fafd;
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 #9076f016;
            padding: 1.1rem 1.1rem 1rem 1.1rem;
            margin-bottom: 1.7rem;
            border-left: 4px solid #ffd600;
            display: flex;
            flex-direction: column;
            min-height: 165px;
            border-left: none;
            box-shadow: 0 4px 32px 0 #9076f014;
            transition: box-shadow 0.22s cubic-bezier(.44,1.6,.64,1), transform 0.22s cubic-bezier(.44,1.6,.64,1);
            will-change: transform, box-shadow;
        }
        .quiz-card:hover {
            box-shadow: 0 18px 48px 0 #856fff44;
            transform: translateY(-10px) scale(1.013);
        }
        .quiz-title-link {
            color: #5742ea;
            font-size: 1.13rem;
            font-weight: bold;
            text-decoration: underline;
        }
        .quiz-title-link a { color: #4832de; }
        .quiz-title-link a:hover { color: #a279ff; }
        .quiz-meta {
            color: #786e8b;
            font-size: .97em;
            margin-top: 2px;
            font-weight: 500;
        }
        .quiz-category {
            color: #7c4cff;
            font-size: 0.98em;
            font-weight: 600;
            margin-left: 11px;
        }
        .quiz-desc {
            color: #6d669a;
            font-size: 1.05rem;
            font-style: italic;
            margin-top: 14px;
            margin-left: 4px;
            padding: 10px 18px;
            border-left: 3px solid #ece8ff;
            background: rgba(127, 96, 244, 0.04);
            border-radius: 8px;
            max-width: 98%;
        }
        .quiz-meta i {
            color: #716d9a;
            margin-right: 3px;
        }
        .quiz-category i {
            margin-right: 3px;
        }
        .alert-warning {
            background: #fce7c1;
            border: 1px solid #f8d477;
            color: #946106;
            border-radius: 8px;
            margin: 2rem 0 2rem 0;
            padding: 1.5rem 2rem;
        }
        /* View Summary button style: more pill-like, less chunky, more horizontal */
        .btn-summary {
            background: linear-gradient(90deg, #b285fd 0%, #8942f7 100%);
            color: #fff !important;
            border: none;
            border-radius: 38px;
            font-size: 1.08rem;
            font-weight: 700;
            padding: 0.68rem 2.1rem 0.68rem 1.3rem;
            min-width: 180px;
            display: inline-flex;
            align-items: center;
            gap: 0.88em;
            justify-content: center;
            margin-top: 15px;
            transition: background .15s, transform .14s;
            box-shadow: 0 3px 12px #ad86ff33;
            text-decoration: none !important;
        }
        .btn-summary:hover, .btn-summary:focus {
            background: linear-gradient(90deg, #8942f7 0%, #b285fd 100%);
            color: #fff;
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 10px 28px #a579ff55;
        }
        @media (max-width: 1100px) {
            .main-content-flex { flex-direction: column; gap: 1.2rem;}
            .sidebar-filters { width: 99vw; max-width: 99vw; margin-top: 20px;}
            .quizzes-main-section { max-width: 100vw; }
        }
    </style>
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
