<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - Quiz App</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .header p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
        }

        .main-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2rem;
        }

        .messages-section {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            max-height: 70vh;
            overflow-y: auto;
        }

        .messages-section::-webkit-scrollbar {
            width: 8px;
        }

        .messages-section::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .messages-section::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 10px;
        }

        .messages-section::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #2d3748;
        }

        .message-card {
            background: #f8fafc;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .message-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .message-card.unread {
            background: linear-gradient(135deg, #e6f3ff 0%, #f0f9ff 100%);
            border-left: 4px solid #3b82f6;
        }

        .message-card.unread::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, #3b82f6, #06b6d4);
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .message-meta {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .message-type {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .message-type.challenge {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .message-type.note {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .sender-name {
            font-weight: 600;
            color: #1f2937;
        }

        .message-date {
            color: #6b7280;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .message-content {
            margin-bottom: 1rem;
        }

        .challenge-info {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            padding: 1.5rem;
            border-radius: 12px;
            border: 1px solid #f59e0b;
            position: relative;
        }

        .challenge-info::before {
            content: '🏆';
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
        }

        .quiz-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.75rem 1.5rem;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        .quiz-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
        }

        .compose-panel {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #374151;
        }

        .form-select,
        .form-textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .btn {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6b7280, #4b5563);
        }

        .btn-secondary:hover {
            box-shadow: 0 8px 25px rgba(107, 114, 128, 0.3);
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 1px solid #10b981;
        }

        .alert-error {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border: 1px solid #ef4444;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }

        .form-section {
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .form-section.active {
            display: block;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .back-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
            color: white;
            border: none;
            padding: 1rem;
            border-radius: 50%;
            font-size: 1.25rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(139, 92, 246, 0.4);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .back-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 1rem;
            }

            .header h1 {
                font-size: 2rem;
            }

            .compose-panel {
                position: static;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-comments"></i> Messages</h1>
        <p>Connect with friends and challenge them to quizzes</p>
    </div>

    <div class="main-content">
        <div class="messages-section">
            <h2 class="section-title">
                <i class="fas fa-inbox"></i> Your Messages
            </h2>

            <!-- Success/Error Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Messages List -->
            <div class="messages-list">
                <c:choose>
                    <c:when test="${empty messages}">
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>No messages yet</h3>
                            <p>Start a conversation with your friends!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="message" items="${messages}">
                            <div class="message-card ${message.read ? '' : 'unread'}">
                                <div class="message-header">
                                    <div class="message-meta">
                                        <span class="message-type ${message.messageType}">${message.messageType}</span>
                                        <span class="sender-name">${message.senderName}</span>
                                    </div>
                                    <div class="message-date">
                                        <i class="fas fa-clock"></i>
                                        <fmt:formatDate value="${message.sentAt}" pattern="MMM dd, yyyy HH:mm"/>
                                    </div>
                                </div>

                                <div class="message-content">
                                    <c:choose>
                                        <c:when test="${message.messageType eq 'challenge'}">
                                            <div class="challenge-info">
                                                <p><strong>${message.senderName}</strong> ${message.content}</p>
                                                <c:if test="${not empty message.quizTitle}">
                                                    <p><strong>Quiz:</strong> ${message.quizTitle}</p>
                                                    <a href="quiz?id=${message.quizId}" class="quiz-link">
                                                        <i class="fas fa-play"></i>
                                                        Take Quiz
                                                    </a>
                                                </c:if>
                                            </div>
                                        </c:when>
                                        <c:when test="${message.messageType eq 'note'}">
                                            <p>${message.content}</p>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="compose-panel">
            <h3 class="section-title">
                <i class="fas fa-paper-plane"></i> Send New Message
            </h3>

            <c:choose>
                <c:when test="${empty friends}">
                    <div class="empty-state">
                        <i class="fas fa-user-plus"></i>
                        <h4>No friends yet</h4>
                        <p>You need to have friends to send messages.</p>
                        <a href="friends" class="btn" style="margin-top: 1rem;">
                            <i class="fas fa-user-plus"></i>
                            Add Friends
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <form method="post" action="message" id="messageForm">
                        <div class="form-group">
                            <label for="receiverId" class="form-label">To:</label>
                            <select name="receiverId" id="receiverId" class="form-select" required>
                                <option value="">Select a friend...</option>
                                <c:forEach var="friend" items="${friends}">
                                    <option value="${friend.id}">${friend.username}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="messageType" class="form-label">Message Type:</label>
                            <select name="messageType" id="messageType" class="form-select" required>
                                <option value="">Select type...</option>
                                <option value="note">📝 Note</option>
                                <option value="challenge">🏆 Challenge</option>
                            </select>
                        </div>

                        <!-- Note Form -->
                        <div id="noteForm" class="form-section">
                            <div class="form-group">
                                <label for="content" class="form-label">Message:</label>
                                <textarea name="content" id="content" class="form-textarea" placeholder="Type your message here..." maxlength="1000"></textarea>
                            </div>
                            <button type="submit" name="action" value="sendNote" class="btn">
                                <i class="fas fa-paper-plane"></i>
                                Send Note
                            </button>
                        </div>

                        <!-- Challenge Form -->
                        <div id="challengeForm" class="form-section">
                            <div class="form-group">
                                <label for="quizId" class="form-label">Select Quiz:</label>
                                <select name="quizId" id="quizId" class="form-select">
                                    <option value="">Select a quiz...</option>
                                    <c:forEach var="quiz" items="${quizzes}">
                                        <option value="${quiz.quizId}">${quiz.quizTitle}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" name="action" value="sendChallenge" class="btn">
                                <i class="fas fa-trophy"></i>
                                Send Challenge
                            </button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<a href="homepage.jsp" class="back-btn">
    <i class="fas fa-arrow-left"></i>
</a>

<script>
    function toggleMessageForm() {
        const messageType = document.getElementById('messageType').value;
        const noteForm = document.getElementById('noteForm');
        const challengeForm = document.getElementById('challengeForm');

        // Hide all forms
        noteForm.classList.remove('active');
        challengeForm.classList.remove('active');

        // Show selected form
        if (messageType === 'note') {
            noteForm.classList.add('active');
            document.getElementById('content').required = true;
            document.getElementById('quizId').required = false;
        } else if (messageType === 'challenge') {
            challengeForm.classList.add('active');
            document.getElementById('content').required = false;
            document.getElementById('quizId').required = true;
        }
    }

    document.getElementById('messageType').addEventListener('change', toggleMessageForm);

    document.getElementById('messageType').addEventListener('change', function() {
        document.getElementById('content').value = '';
        document.getElementById('quizId').value = '';
    });

    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.message-card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';

            setTimeout(() => {
                card.style.transition = 'all 0.5s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
</script>
</body>
</html>