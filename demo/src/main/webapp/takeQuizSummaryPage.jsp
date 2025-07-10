<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Models.*" %>
<%@ page import="Models.Questions.Question" %>
<html>
<head>
    <title>Quiz Summary</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .question-summary { margin-bottom: 30px; padding: 20px; border: 1px solid #ccc; border-radius: 8px; }
        .question-summary h4 { margin-bottom: 10px; }
        .label { font-weight: bold; color: #333; }
        .answer-block { margin-left: 20px; margin-top: 5px; white-space: pre-line; }

         .practice-mode-banner {
             background-color: #ffeb3b;
             color: #000;
             font-weight: bold;
             padding: 10px 24px;
             border-radius: 10px;
             box-shadow: 0 4px 12px rgba(0,0,0,0.25);
             font-size: 20px;
             text-align: center;
             margin: 20px auto;
             width: fit-content;
         }

        .practice-mode-banner small {
            display: block;
            font-size: 13px;
            font-weight: normal;
            margin-top: 4px;
        }
    </style>
    </style>
</head>
<body>

<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    Map<Long, List<Answer>> correctAnswers = (Map<Long, List<Answer>>) request.getAttribute("correctAnswers");
    Map<Long, List<String>> providedAnswers = (Map<Long, List<String>>) request.getAttribute("providedAnswers");
    List<Double> stats = (List<Double>) request.getAttribute("quizStats");
    long totalTimeSpent = (Long) request.getAttribute("totalTimeSpent");
    long totalSecondsRem = (Long) request.getAttribute("totalSecondsRem");
    double totalPoints = stats.get(0);
    double correctCount = stats.get(1);
    double markedIncorrect = stats.get(2);
    double finalScore = stats.get(3);
%>

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

<h1>Quiz Summary</h1>
<h2><%= quiz.getQuizTitle() %></h2>
<p><%= quiz.getDescription() %></p>

<hr/>

<h3>Quiz Stats:</h3>
<ul>
    <li><strong>Total Time Spent:</strong> <%= (long) totalTimeSpent %> minutes <%= (long) totalSecondsRem %> seconds. </li>
    <li><strong>Total Possible Points:</strong> <%= (int) totalPoints %></li>
    <li><strong>Correct Answers:</strong> <%= (int) correctCount %></li>
    <li><strong>Incorrect Selections:</strong> <%= (int) markedIncorrect %></li>
    <li><strong>Final Score:</strong> <%= String.format("%.2f", finalScore) %>%</li>
</ul>

<hr/>

<h3>Question Review:</h3>
<%
    for (Question q : questions) {
        Long qid = q.getQuestionId();
        String qType = q.getQuestionType().toLowerCase().strip();
        List<String> userAnswers = providedAnswers.get(qid);
        List<Answer> correctAns = correctAnswers.get(qid);
%>

<div class="question-summary">
    <h4>Q: <%= q.getQuestionText() %></h4>

    <p class="label">Your Answer:</p>
    <div class="answer-block">
        <%
            for (String userAns : userAnswers) {
        %>
        <%= userAns %><br/>
        <%
            }
        %>
    </div>

    <p class="label">Correct Answer:</p>
    <div class="answer-block">
        <%
            if (qType.equals("question-response") || qType.equals("picture-response") || qType.equals("fill-blank") || qType.equals("multiple-choice")) {
                for (int i = 0; i < correctAns.size(); i++) {
                    out.print(correctAns.get(i).getAnswerText());
                    if (i < correctAns.size() - 1) out.print(" / ");
                }
            } else if (qType.equals("matching")) {
                for (Answer ans : correctAns) {
                    String raw = ans.getAnswerText();
                    int dashIndex = raw.indexOf("-");
                    if (dashIndex != -1 && dashIndex < raw.length() - 1) {
                        String rightSide = raw.substring(dashIndex + 1);
        %>
        <%= rightSide %><br/>
        <%
                }
            }
        } else {
            for (Answer ans : correctAns) {
        %>
        <%= ans.getAnswerText() %><br/>
        <%
                }
            }
        %>
    </div>
</div>

<% } %>

<div style="text-align: center; margin-top: 40px;">
    <form action="homepage.jsp" method="get">
        <button type="submit" style="padding: 10px 20px; font-size: 16px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;">
            Return to Homepage
        </button>
    </form>
</div>

</body>
</html>
