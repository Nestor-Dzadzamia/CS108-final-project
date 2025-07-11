<%@ page import="Models.Questions.Question" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.lang.*" %>
<%@ page import="Models.Quiz" %>

<%-- @elvariable id="quiz" type="Models.Quiz" --%>
<%-- @elvariable id="questions" type="java.util.List<Models.Questions.Question>" --%>
<%-- @elvariable id="correctAnswers" type="java.util.Map<java.lang.Long, java.util.List<Models.Answer>>" --%>
<%-- @elvariable id="possibleAnswers" type="java.util.Map<java.lang.Long, java.util.List<Models.PossibleAnswer>>" --%>

<%
    int index = 0;
    try {
        index = (Integer) session.getAttribute("index");
    } catch (Exception ignored) {}

    List<Question> questionsList = (List<Models.Questions.Question>) session.getAttribute("questions");
    Models.Questions.Question currentQuestion =(Models.Questions.Question) session.getAttribute("currentQuestion");
    boolean isLast = (index == questionsList.size() - 1);
    request.setAttribute("isLast", isLast);

    Quiz quiz = (Quiz) session.getAttribute("quiz");
    Long remaining = (Long) session.getAttribute("remainingTime");
    if (remaining == null) {
        remaining = quiz.getTotalTimeLimit() * 60L;
        session.setAttribute("remainingTime", remaining);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${quiz.quizTitle} - Question ${index + 1}</title>
    <link rel="stylesheet" href="Styles/take-quiz-multiple-page.css">
</head>
<body>
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

<div id="timer">
    Time Remaining: <span id="timeDisplay">Loading...</span>
</div>

<h2>${quiz.quizTitle}</h2>
<p>${quiz.description}</p>

<form id="quizForm" method="POST" action="${'take-quiz-multiple-reload'}">
    <input type="hidden" name="quiz_id" value="${quiz.quizId}" />
    <input type="hidden" name="index" value="${index + 1}" />

    <div class="question-block">
        <c:choose>
            <c:when test="${fn:trim(currentQuestion.questionType) == 'fill-blank'}">
                <h3>Question ${index + 1}:</h3>
            </c:when>
            <c:otherwise>
                <h3>Question ${index + 1}: ${currentQuestion.questionText}</h3>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty currentQuestion.imageUrl}">
            <img src="${currentQuestion.imageUrl}" alt="Question image" style="max-width: 400px; margin: 10px 0;" />
        </c:if>

        <c:choose>
            <c:when test="${fn:trim(currentQuestion.questionType) == 'question-response'}">
                <input type="text" name="answer_${currentQuestion.questionId}" placeholder="Enter your answer" />
            </c:when>

            <c:when test="${fn:trim(currentQuestion.questionType) == 'fill-blank'}">
                <c:set var="beforeBlank" value="${fn:substringBefore(currentQuestion.questionText, '_')}" />
                <c:set var="afterBlank" value="${fn:substringAfter(currentQuestion.questionText, '_')}" />
                ${beforeBlank}
                <input type="text" name="answer_${currentQuestion.questionId}" />
                ${afterBlank}
            </c:when>

            <c:when test="${fn:trim(currentQuestion.questionType) == 'picture-response'}">
                <input type="text" name="answer_${currentQuestion.questionId}" placeholder="Describe the image" />
            </c:when>

            <c:when test="${fn:trim(currentQuestion.questionType) == 'multiple-choice'}">
                <c:forEach var="option" items="${possibleAnswers[currentQuestion.questionId]}" varStatus="optStatus">
                    <div class="option-container">
                        <input type="radio" name="answer_${currentQuestion.questionId}" value="${option.possibleAnswerText}" id="q${currentQuestion.questionId}_opt${optStatus.index}" />
                        <label for="q${currentQuestion.questionId}_opt${optStatus.index}">${option.possibleAnswerText}</label>
                    </div>
                </c:forEach>
            </c:when>

            <c:when test="${fn:trim(currentQuestion.questionType) == 'multiple-multiple-choice'}">
                <c:forEach var="option" items="${possibleAnswers[currentQuestion.questionId]}" varStatus="optStatus">
                    <div class="option-container">
                        <input type="checkbox" name="answer_${currentQuestion.questionId}" value="${option.possibleAnswerText}" id="q${currentQuestion.questionId}_opt${optStatus.index}" />
                        <label for="q${currentQuestion.questionId}_opt${optStatus.index}">${option.possibleAnswerText}</label>
                    </div>
                </c:forEach>
                <div><em>Select all that apply.</em></div>
            </c:when>

            <c:when test="${fn:trim(currentQuestion.questionType) == 'multi-answer'}">
                <c:set var="count" value="${fn:length(correctAnswers[currentQuestion.questionId])}" />
                <c:if test="${empty count or count <= 0}">
                    <c:set var="count" value="1" />
                </c:if>
                <c:forEach begin="1" end="${count}" var="i">
                    <input type="text" name="answer_${currentQuestion.questionId}_${i}" placeholder="Answer ${i}" /><br/>
                </c:forEach>
                <div><em>Provide ${count} answer(s).</em></div>
            </c:when>

            <c:when test="${fn:trim(currentQuestion.questionType) == 'matching'}">
                <c:set var="count" value="${fn:length(correctAnswers[currentQuestion.questionId])}" />
                <c:if test="${empty count or count <= 0}">
                    <c:set var="count" value="1" />
                </c:if>
                <c:forEach begin="1" end="${count}" var="i">
                    <c:set var="pairText" value="${correctAnswers[currentQuestion.questionId][i-1].getAnswerText()}" />
                    <c:set var="left" value="${fn:substringBefore(pairText, '-')}" />
                    <div>
                        <input type="text" value="${left}" readonly />
                        →
                        <input type="text" name="match_right_${currentQuestion.questionId}_${i}" placeholder="Your match for '${left}'" />
                    </div>
                </c:forEach>
                <div><em>Match the items accordingly.</em></div>
            </c:when>

            <c:otherwise>
                <div style="color:red">❌ Unknown question type: ${currentQuestion.questionType}</div>
                <input type="text" name="answer_${currentQuestion.questionId}" />
            </c:otherwise>
        </c:choose>
    </div>

    <button type="submit" class="submit-btn">
        ${isLast ? 'Submit Quiz' : 'Next Question'}
    </button>
</form>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        let remainingSeconds = <%= remaining %>;
        //remainingSeconds = 5;

        console.log("Starting timer with", remainingSeconds, "seconds");

        const timeDisplay = document.getElementById("timeDisplay");
        const timerElement = document.getElementById("timer");
        const form = document.getElementById("quizForm");

        // Simple timer display function
        function showTime(seconds) {
            const mins = Math.floor(seconds / 60);
            const secs = seconds % 60;
            const timeString = mins + ":" + (secs < 10 ? "0" + secs : secs);
            timeDisplay.textContent = timeString;
            console.log("Timer showing:", timeString);
        }

        // Show initial time
        showTime(remainingSeconds);

        // Start countdown
        const timer = setInterval(function() {
            remainingSeconds--;
            showTime(remainingSeconds);

            // Add warning when under 2 minutes
            if (remainingSeconds <= 120) {
                timerElement.style.color = "#ff0000";
                timerElement.style.animation = "pulse 1s infinite";
            }

            // Time's up
            if (remainingSeconds <= 0) {
                clearInterval(timer);
                alert("Time's up! Submitting quiz...");
                form.submit();
            }
        }, 1000);

        // Stop timer when form is submitted
        form.addEventListener('submit', function() {
            clearInterval(timer);
        });

        // // Warn before leaving page
        // window.addEventListener('beforeunload', function(e) {
        //     if (remainingSeconds > 0) {
        //         e.preventDefault();
        //         e.returnValue = 'Are you sure you want to leave? Your quiz progress will be lost.';
        //     }
        // });

    });
</script>
</body>
</html>
