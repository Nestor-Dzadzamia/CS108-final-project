<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Map<Integer, String> questionTypes = (Map<Integer, String>) session.getAttribute("question_types");
    Map<Integer, Integer> correctCounts = (Map<Integer, Integer>) session.getAttribute("correct_counts");
    Map<Integer, Integer> totalAnswersMap = (Map<Integer, Integer>) session.getAttribute("total_answers");

    if (questionTypes == null || correctCounts == null) {
        response.sendRedirect("createQuizTypes.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>Enter Quiz Questions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .question-block {
            margin-bottom: 2rem;
            padding: 1rem;
            border: 1px solid #ccc;
            border-radius: 10px;
            background-color: #fff;
        }
    </style>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center mb-4">Enter Quiz Questions</h2>
    <form action="save-quiz" method="post">
        <% for (Map.Entry<Integer, String> entry : questionTypes.entrySet()) {
            int index = entry.getKey();
            String type = entry.getValue();
        %>
        <div class="question-block">
            <h5>Question <%= index %> - <%= type.replace("-", " ") %></h5>
            <input type="hidden" name="question_<%= index %>_type" value="<%= type %>"/>

            <%-- COMMON FIELDS --%>
            <div class="mb-3">
                <label class="form-label">Question Text</label>
                <input type="text" name="question_<%= index %>_text" class="form-control"
                    <%= "fill-blank".equals(type) ? "placeholder='Include _ for the blank'" : "" %> required>
            </div>

            <% if ("picture-response".equals(type)) { %>
            <div class="mb-3">
                <label class="form-label">Image URL</label>
                <input type="text" name="question_<%= index %>_image" class="form-control" required>
            </div>
            <% } %>

            <% if (type.equals("question-response") || type.equals("fill-blank") || type.equals("multi-answer") || type.equals("picture-response")) {
                int numAnswers = correctCounts.getOrDefault(index, 1); %>
            <div class="mb-3">
                <label class="form-label">Correct Answers</label>
                <% for (int a = 1; a <= numAnswers; a++) { %>
                <input type="text" name="question_<%= index %>_answer_<%= a %>" class="form-control mb-1"
                    <%= (a == 1) ? "required" : "" %>>
                <% } %>
            </div>
            <% if ("multi-answer".equals(type)) { %>
            <div class="form-check">
                <input class="form-check-input" type="checkbox" name="question_<%= index %>_ordered" id="ordered_<%= index %>">
                <label class="form-check-label" for="ordered_<%= index %>">Answers must be in order</label>
            </div>
            <% } } %>

            <% if (type.equals("multiple-choice") || type.equals("multiple-multiple-choice")) {
                int totalChoices = totalAnswersMap.getOrDefault(index, 4);  // from session
                for (int i = 0; i < totalChoices; i++) {
                    char label = (char) ('A' + i); %>
            <div class="input-group mb-2">
                <span class="input-group-text"><%= label %></span>
                <input type="text" name="question_<%= index %>_option_<%= label %>" class="form-control" required>
                <div class="input-group-text">
                    <input type="<%= type.equals("multiple-multiple-choice") ? "checkbox" : "radio" %>"
                           name="question_<%= index %>_correct_choice<%= type.equals("multiple-multiple-choice") ? "_" + label : "" %>"
                           value="<%= label %>">
                </div>
            </div>
            <%  } } %>


            <%-- MATCHING TYPE --%>
            <% if ("matching".equals(type)) {
                int numPairs = correctCounts.getOrDefault(index, 1);
            %>
            <div class="mb-2">
                <label class="form-label">Matching Pairs</label>
                <% for (int m = 1; m <= numPairs; m++) { %>
                <div class="row mb-2">
                    <div class="col">
                        <input type="text" name="question_<%= index %>_match_left_<%= m %>"
                               class="form-control" placeholder="Left side" required>
                    </div>
                    <div class="col">
                        <input type="text" name="question_<%= index %>_match_right_<%= m %>"
                               class="form-control" placeholder="Right side" required>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>


        </div>
        <% } %>

        <div class="text-center mt-4">
            <button type="submit" class="btn btn-primary">Save Quiz</button>
        </div>
    </form>
</div>
</body>
</html>
