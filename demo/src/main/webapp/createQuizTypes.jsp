<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Long questionCount = (Long) session.getAttribute("question_count");
    if (questionCount == null || questionCount <= 0) {
        questionCount = 1L;
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

        .total-answers-section, .ordered-checkbox {
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
            const orderedCheckboxBlock = document.getElementById('ordered-checkbox-' + index);

            // Show total answers for these types
            if (type === 'multiple-choice' || type === 'multiple-multiple-choice') {
                totalAnswerBlock.style.display = 'block';
            } else {
                totalAnswerBlock.style.display = 'none';
            }

            // Show ordered checkbox ONLY for multi-answer
            if (type === 'multi-answer') {
                orderedCheckboxBlock.style.display = 'block';
            } else {
                orderedCheckboxBlock.style.display = 'none';
            }
        }
    </script>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="text-center mb-4">Step 1: Choose Question Types</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>

    <div class="mb-3">
        <span class="toggle-icon" onclick="toggleInstructions()">&#x25B6; Show Instructions</span>
        <div id="instructions">
            <ul>
                <li>Select a type for each question.</li>
                <li>Select total number of correct answers (1–20).</li>
                <li>For <strong>Multiple Choice</strong>, correct answers = 1.</li>
                <li>For <strong>Multiple Choice With Multiple Answers</strong>, max correct = total - 1.</li>
                <li>Only those two types require both <strong>Correct Answers</strong> and <strong>Total Answers</strong>.</li>
                <li>For <strong>Multi Answer</strong>, you can mark if answers must be in a specific order.</li>
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
                <label class="form-label">Number of Correct Answers</label>
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

            <!-- Total Answers (only for multiple-choice types) -->
            <div class="mb-3 total-answers-section" id="total-answers-<%= i %>">
                <label class="form-label">Total Number of Answers</label>
                <input
                        type="number"
                        min="4"
                        max="8"
                        name="question_<%= i %>_total_answers"
                        class="form-control"
                        oninvalid="this.setCustomValidity('Enter total answers (4–8).')"
                        oninput="this.setCustomValidity('')"
                >
            </div>

            <!-- ✅ Ordered checkbox (only for multi-answer) -->
            <div class="form-check ordered-checkbox" id="ordered-checkbox-<%= i %>">
                <input class="form-check-input"
                       type="checkbox"
                       id="question-<%= i %>-ordered"
                       name="question_<%= i %>_ordered"
                       value="true">
                <label class="form-check-label" for="question-<%= i %>-ordered">
                    Is answer order important?
                </label>
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
