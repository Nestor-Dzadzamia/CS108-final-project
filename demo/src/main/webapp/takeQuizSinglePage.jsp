<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- @elvariable id="quiz" type="Models.Quiz" --%>
<%-- @elvariable id="questions" type="java.util.List<Models.Questions.Question>" --%>
<%-- @elvariable id="correctAnswers" type="java.util.Map<java.lang.Long, java.util.List<Models.Answer>" --%>
<%-- @elvariable id="possibleAnswers" type="java.util.Map<java.lang.Long, java.util.List<Models.PossibleAnswer>>" --%>

<%
    Long remaining = (Long) session.getAttribute("remainingTime");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.quizTitle}</title>
    <link rel="stylesheet" href="Styles/take-quiz-single-page.css">
</head>
<body>
<div id="timer">
    Time Remaining: <span id="timeDisplay">Loading...</span>
</div>

<%
    Boolean isPracticeMode = (Boolean) session.getAttribute("isPracticeMode");
    if (Boolean.TRUE.equals(isPracticeMode)) {
%>
<div class="practice-mode-banner">
    Practice Mode
    <small>Submission data won't be saved</small>
</div>
<%
    }
%>

<h1>${quiz.quizTitle}</h1>
<p>${quiz.description}</p>

<form method="POST" action="submit-quiz" id="quizForm">
    <input type="hidden" name="quiz_id" value="${quiz.quizId}" />

    <c:forEach var="q" items="${questions}" varStatus="status">
        <div class="question-block">
            <c:choose>
                <c:when test="${fn:trim(q.questionType) == 'fill-blank'}">
                    <h3>Question ${status.index + 1}:</h3>
                </c:when>
                <c:otherwise>
                    <h3>Question ${status.index + 1}: ${q.questionText}</h3>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty q.imageUrl}">
                <img src="${q.imageUrl}" alt="Question image" class="question-image" />
            </c:if>

            <c:choose>
                <%-- Question Response Type --%>
                <c:when test="${fn:trim(q.questionType) == 'question-response'}">
                    <input type="text" name="answer_${q.questionId}" placeholder="Enter your answer here" />
                </c:when>

                <%-- Fill in the Blank Type --%>
                <c:when test="${fn:trim(q.questionType) == 'fill-blank'}">
                    <div class="fill-blank-container">
                        <c:set var="beforeBlank" value="${fn:substringBefore(q.questionText, '_')}" />
                        <c:set var="afterBlank" value="${fn:substringAfter(q.questionText, '_')}" />
                            ${beforeBlank}
                        <input type="text" name="answer_${q.questionId}" placeholder="Fill the blank" class="fill-blank-input" />
                            ${afterBlank}
                    </div>
                </c:when>

                <%-- Picture Response Type --%>
                <c:when test="${fn:trim(q.questionType) == 'picture-response'}">
                    <input type="text" name="answer_${q.questionId}" placeholder="Describe what you see in the image" />
                </c:when>

                <%-- Multiple Choice Type --%>
                <c:when test="${fn:trim(q.questionType) == 'multiple-choice'}">
                    <c:forEach var="option" items="${possibleAnswers[q.questionId]}" varStatus="optStatus">
                        <div class="option-container">
                            <input type="radio" name="answer_${q.questionId}" value="${option.possibleAnswerText}" id="q${q.questionId}_opt${optStatus.index}" />
                            <label for="q${q.questionId}_opt${optStatus.index}">${option.possibleAnswerText}</label>
                        </div>
                    </c:forEach>
                </c:when>

                <%-- Multiple Multiple Choice Type --%>
                <c:when test="${fn:trim(q.questionType) == 'multiple-multiple-choice'}">
                    <c:forEach var="option" items="${possibleAnswers[q.questionId]}" varStatus="optStatus">
                        <div class="option-container">
                            <input type="checkbox" name="answer_${q.questionId}" value="${option.possibleAnswerText}" id="q${q.questionId}_opt${optStatus.index}" />
                            <label for="q${q.questionId}_opt${optStatus.index}">${option.possibleAnswerText}</label>
                        </div>
                    </c:forEach>
                    <div class="instructions">Select all that apply. Incorrect selections may reduce your score.</div>
                </c:when>

                <%-- Multi Answer Type --%>
                <c:when test="${fn:trim(q.questionType) == 'multi-answer'}">
                    <c:set var="count" value="${fn:length(correctAnswers[q.questionId + 0])}" />
                    <c:if test="${empty count or count <= 0}">
                        <c:set var="count" value="1" />
                    </c:if>
                    <c:forEach begin="1" end="${count}" var="i">
                        <input type="text" name="answer_${q.questionId}_${i}" placeholder="Answer ${i}" class="multi-answer-input" />
                    </c:forEach>
                    <div class="instructions">Provide ${count} answer(s) for this question.</div>
                </c:when>

                <%-- Matching Type --%>
                <c:when test="${fn:trim(q.questionType) == 'matching'}">
                    <c:set var="count" value="${fn:length(correctAnswers[q.questionId + 0])}" />
                    <c:if test="${empty count or count <= 0}">
                        <c:set var="count" value="1" />
                    </c:if>

                    <c:forEach begin="1" end="${count}" var="i">
                        <c:set var="pairText" value="${correctAnswers[q.questionId][i-1].getAnswerText()}" />
                        <c:set var="left" value="${fn:substringBefore(pairText, '-')}" />
                        <div class="match-pair">
                            <input type="text" name="match_left_${q.questionId}_${i}" value="${left}" readonly />
                            <span>→</span>
                            <input type="text" name="match_right_${q.questionId}_${i}" placeholder="Your match for '${left}'" />
                        </div>
                    </c:forEach>

                    <div class="instructions">Match each item on the left with the correct answer on the right.</div>
                </c:when>

                <%-- Unknown Question Type --%>
                <c:otherwise>
                    <div class="debug" style="color: red; font-weight: bold;">
                        ❌ UNKNOWN QUESTION TYPE: "${q.questionType}"<br>
                        Available types: question-response, fill-blank, picture-response, multiple-choice, multiple-multiple-choice, multi-answer, matching
                    </div>
                    <input type="text" name="answer_${q.questionId}" placeholder="Default text input (unknown question type)" />
                </c:otherwise>
            </c:choose>
        </div>
    </c:forEach>

    <button type="submit" class="submit-btn">Submit Quiz</button>
</form>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let remainingSeconds = <%= remaining %>;
        let isFormSubmitting = false;

        const timeDisplay = document.getElementById("timeDisplay");
        const timerElement = document.getElementById("timer");
        const form = document.getElementById("quizForm");

        function showTime(seconds) {
            const mins = Math.floor(seconds / 60);
            const secs = seconds % 60;
            const timeString = mins + ":" + (secs < 10 ? "0" + secs : secs);
            timeDisplay.textContent = timeString;
        }

        showTime(remainingSeconds);

        const timer = setInterval(function() {
            remainingSeconds--;
            showTime(remainingSeconds);

            if (remainingSeconds <= 120) {
                timerElement.style.color = "#ff0000";
                timerElement.style.animation = "pulse 1s infinite";
            }
            if (remainingSeconds <= 0) {
                clearInterval(timer);
                alert("Time's up! Submitting quiz...");
                isFormSubmitting = true;
                form.submit();
            }
        }, 1000);

        form.addEventListener('submit', function() {
            clearInterval(timer);
            isFormSubmitting = true;
        });
    });
</script>
</body>
</html>
