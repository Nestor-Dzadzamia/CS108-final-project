<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create Quiz</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4 text-center">Create a New Quiz</h2>

    <!-- Show error if categories fail to load -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>

    <form action="create-quiz" method="post" class="p-4 bg-white rounded shadow-sm">

        <!-- Quiz Title -->
        <div class="mb-3">
            <label for="quizTitle" class="form-label">Quiz Title</label>
            <input type="text" class="form-control" id="quizTitle" name="quiz_title" required>
        </div>

        <!-- Description -->
        <div class="mb-3">
            <label for="description" class="form-label">Quiz Description</label>
            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
        </div>

        <!-- Number of Questions -->
        <div class="mb-3">
            <label for="questionCount" class="form-label">Number of Questions</label>
            <select class="form-select" id="questionCount" name="question_count" required>
                <c:forEach var="i" begin="5" end="25">
                    <option value="${i}">${i}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Time Limit (in minutes) -->
        <div class="mb-3">
            <label for="timeLimit" class="form-label">Total Time Limit (minutes)</label>
            <input type="number" class="form-control" id="timeLimit" name="total_time_limit" min="15" max="180" required>
        </div>

        <!-- Category (Dynamically loaded from DB) -->
        <div class="mb-3">
            <label for="quizCategory" class="form-label">Category</label>
            <select class="form-select" id="quizCategory" name="quiz_category" required>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.categoryId}">${category.categoryName}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Quiz Settings -->
        <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" name="randomized" id="randomized">
            <label class="form-check-label" for="randomized">Randomize Questions</label>
        </div>

        <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" name="is_multiple_page" id="multiplePage">
            <label class="form-check-label" for="multiplePage">Display Questions on Multiple Pages</label>
        </div>

        <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" name="immediate_correction" id="immediateCorrection">
            <label class="form-check-label" for="immediateCorrection">Immediate Correction After Each Question</label>
        </div>

        <div class="form-check mb-4">
            <input class="form-check-input" type="checkbox" name="allow_practice" id="allowPractice">
            <label class="form-check-label" for="allowPractice">Allow Practice Mode</label>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn btn-primary w-100">Create Quiz</button>
    </form>
</div>
</body>
</html>
