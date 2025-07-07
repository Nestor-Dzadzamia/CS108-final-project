<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Integer questionCount = (Integer) session.getAttribute("question_count");
    if (questionCount == null || questionCount <= 0) {
        questionCount = 1;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Choose Question Types</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        .question-block {
            margin-bottom: 2rem;
            padding: 1rem;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        #instructions {
            display: none;
            border: 1px solid #ccc;
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }

        .toggle-icon {
            cursor: pointer;
            font-weight: bold;
        }

        .total-answers-section {
            display: none;
        }
    </style>
    <script>
        function toggleInstructions() {
            const block = document.getElementById('instructions');
            block.style.display = block.style.display === 'none' ? 'block' : 'none';
        }

        function updateAnswerFields(index) {
            const type = document.getElementById('qtype-' + index).value;
            const totalAnswerBlock = document.getElementById('total-answers-' + index);

            if (type === 'multiple-choice' || type === 'multiple-multiple-choice') {
                totalAnswerBlock.style.display = 'block';
            } else {
                totalAnswerBlock.style.display = 'none';
            }
        }
    </script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center mb-4">
        Step 1: Choose Question Types
    </h2>

    <!-- Toggleable Instructions -->
    <div class="mb-3">
        <span class="toggle-icon" onclick="toggleInstructions()">&#x25B6; Show Instructions</span>
        <div id="instructions">
            <ul>
                <li>Select a type for each question.</li>
                <li>Select total number of correct answers(1-20) for each question.</li>
                <li>For <strong>Multiple Choice questions</strong>, correct answer should be <strong>1</strong>.</li>
                <li>For <strong>Multiple Choice With Multiple Answers questions</strong>, correct answers must be between <strong>2 to (total - 1)</strong>.</li>
                <li>For <strong>Multiple Choice type questions</strong>, total answers must be between <strong>4 and 8</strong>.</li>
                <li>Only those two types require both <strong>Correct Answers</strong> and <strong>Total Answers</strong>.</li>
            </ul>
        </div>
    </div>

    <form action="create-quiz-types" method="post">
        <% for (int i = 1; i <= questionCount; i++) { %>
        <div class="question-block bg-white">
            <h5>Question <%= i %></h5>

            <!-- Question Type -->
            <div class="mb-3">
                <label for="qtype-<%= i %>" class="form-label">Question Type</label>
                <select name="question_<%= i %>_type" id="qtype-<%= i %>" class="form-select"
                        onchange="updateAnswerFields(<%= i %>)" required>
                    <option value="">-- Select Type --</option>
                    <option value="question-response">Question Response</option>
                    <option value="fill-blank">Fill in the Blank</option>
                    <option value="multiple-choice">Multiple Choice</option>
                    <option value="picture-response">Picture Response</option>
                    <option value="multi-answer">Multi Answer</option>
                    <option value="multiple-multiple-choice">Multiple Choice with Multiple Answers</option>
                    <option value="matching">Matching</option>
                </select>
            </div>

            <!-- Number of Correct Answers -->
            <div class="mb-3">
                <label class="form-label">Number of Correct Answers </label>
                <input
                        type="number"
                        min="1"
                        max="20"
                        name="question_<%= i %>_num_correct"
                        class="form-control"
                        required
                        oninvalid="this.setCustomValidity('Please enter a number between 1 and 20.')"
                        oninput="this.setCustomValidity('')"
                >
            </div>

            <!-- Total Answers: Only for multiple-choice types -->
            <div class="mb-3 total-answers-section" id="total-answers-<%= i %>">
                <label class="form-label">Total Number of Answers</label>
                <input
                        type="number"
                        min="4"
                        max="8"
                        name="question_<%= i %>_total_answers"
                        class="form-control"
                        oninvalid="this.setCustomValidity('Please enter a valid total number of answers (4–8).')"
                        oninput="this.setCustomValidity('')"
                >
            </div>
        </div>
        <% } %>

        <div class="text-center mt-4">
            <button type="submit" class="btn btn-primary">Continue to Add Questions</button>
        </div>
    </form>
</div>
</body>
</html>
