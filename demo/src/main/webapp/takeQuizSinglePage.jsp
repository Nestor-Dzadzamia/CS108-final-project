<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%--
  @elvariable id="quiz" type="Models.Quiz"
  @elvariable id="questions" type="java.util.List<Models.Questions.Question>"
  @elvariable id="correctAnswers" type="java.util.Map<java.lang.Long, java.util.List<Models.Answer>"
  @elvariable id="possibleAnswers" type="java.util.Map<java.lang.Long, java.util.List<Models.PossibleAnswer>>"
--%>

<%
    Long remaining = (Long) session.getAttribute("remainingTime");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${quiz.quizTitle}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
        }

        .question-block {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }

        .question-block h3 {
            margin-top: 0;
            color: #333;
        }

        .match-pair {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }

        input[type="text"] {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            min-width: 200px;
        }

        input[type="radio"], input[type="checkbox"] {
            margin-right: 8px;
        }

        label {
            cursor: pointer;
            margin-bottom: 5px;
            display: inline-block;
        }

        .option-container {
            margin-bottom: 8px;
        }

        .submit-btn {
            background-color: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }

        .submit-btn:hover {
            background-color: #0056b3;
        }

        .debug {
            color: red;
            font-size: 12px;
            margin-bottom: 10px;
            padding: 5px;
            background-color: #ffebee;
            border-radius: 3px;
        }

        .multi-answer-input {
            margin-bottom: 10px;
            display: block;
        }

        .question-image {
            max-width: 400px;
            height: auto;
            margin: 10px 0;
            border-radius: 4px;
        }

        .fill-blank-container {
            font-size: 16px;
            line-height: 1.8;
        }

        .fill-blank-input {
            display: inline-block;
            width: 150px;
            margin: 0 5px;
        }

        .instructions {
            font-style: italic;
            color: #666;
            margin-top: 5px;
        }

        #timer {
            font-size: 20px;
            font-weight: bold;
            color: #d9534f;
            text-align: right;
            margin-bottom: 10px;
            position: sticky;
            top: 0;
            background-color: white;
            padding: 10px;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .timer-warning {
            color: #ff6b6b !important;
            animation: pulse 1s infinite;
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
    </style>
</head>
<body>
<div id="timer">
    Time Remaining: <span id="timeDisplay">Loading...</span>
</div>

<h1>${quiz.quizTitle}</h1>
<p>${quiz.description}</p>

<form method="POST" action="submit-quiz" id="quizForm">
    <input type="hidden" name="quiz_id" value="${quiz.quizId}" />

    <c:forEach var="q" items="${questions}" varStatus="status">
        <div class="question-block">
            <h3>Question ${status.index + 1}: ${q.questionText}</h3>

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
        //remainingSeconds = 5;
        let isFormSubmitting = false;

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
                isFormSubmitting = true;
                form.submit();
            }
        }, 1000);

        // Stop timer when form is submitted
        form.addEventListener('submit', function() {
            clearInterval(timer);
            isFormSubmitting = true;
        });

        // // Warn before leaving page
        // window.addEventListener('beforeunload', function(e) {
        //     if (!isFormSubmitting && remainingSeconds > 0) {
        //         e.preventDefault();
        //         e.returnValue = 'Are you sure you want to leave? Your quiz progress will be lost.';
        //     }
        // });

    });
</script>
</body>
</html>