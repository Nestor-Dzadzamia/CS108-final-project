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
    <link rel="stylesheet" href="Styles/message.css">
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
        noteForm.classList.remove('active');
        challengeForm.classList.remove('active');
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
