<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Messages</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
            color: white;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .main-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 100px;
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
        }

        .section-title {
            color: #333;
            font-size: 1.5rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #667eea;
        }

        .messages-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .compose-panel {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            height: fit-content;
        }

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .messages-list {
            max-height: 600px;
            overflow-y: auto;
            padding-right: 10px;
        }

        .message-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .message-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .message-meta {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message-type {
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
        }

        .message-type.challenge {
            background: #ffc107;
            color: #856404;
        }

        .message-type.note {
            background: #17a2b8;
            color: white;
        }

        .sender-name {
            font-weight: bold;
            color: #495057;
        }

        .message-date {
            color: #6c757d;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .message-content {
            line-height: 1.6;
        }

        .challenge-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
        }

        .quiz-link {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 10px;
            transition: background 0.3s ease;
        }

        .quiz-link:hover {
            background: #218838;
            color: white;
            text-decoration: none;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }

        .empty-state h3 {
            margin-bottom: 10px;
            color: #495057;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
        }

        .form-select, .form-textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-section {
            display: none;
            margin-top: 20px;
        }

        .form-section.active {
            display: block;
        }

        .btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn:hover {
            background: #5a6fd8;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .back-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            padding: 12px;
            border-radius: 50%;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .back-btn:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
        }

        .connection-status {
            position: fixed;
            bottom: 24px;
            right: 32px;
            background: rgba(255,255,255,0.85);
            color: #333;
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.09);
            font-size: 1.1rem;
            z-index: 2000;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        .connection-status.connected { background: #d4edda; color: #155724; }
        .connection-status.disconnected { background: #f8d7da; color: #721c24; }

        .notification {
            position: fixed;
            top: 16px;
            right: 36px;
            background: #fff;
            color: #333;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.13);
            padding: 16px 24px;
            opacity: 0;
            pointer-events: none;
            z-index: 3000;
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: opacity 0.4s;
        }
        .notification.show { opacity: 1; pointer-events: auto; }
        .new-message { animation: newmsg-pop 0.5s; }
        @keyframes newmsg-pop {
            0% { transform: scale(0.98) translateY(-10px); background: #f0e6ff; }
            100% { transform: scale(1) translateY(0); }
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
<div id="connectionStatus" class="connection-status disconnected">
    <i class="fas fa-wifi"></i> Disconnected
</div>
<script>
    let socket;
    let currentUser = ${sessionScope.user.id};
    let reconnectAttempts = 0;
    const maxReconnectAttempts = 5;

    function connectWebSocket() {
        const wsUrl = window.location.protocol === 'https:' ?
            'wss://' + window.location.host + '/demo_war_exploded/messageSocket' :
            'ws://' + window.location.host + '/demo_war_exploded/messageSocket';

        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            updateConnectionStatus(true);
            reconnectAttempts = 0;
            socket.send(JSON.stringify({
                type: 'connect',
                userId: currentUser
            }));
        };

        // Auto reload page on every new message (real-time bug-proof)
        socket.onmessage = function() {
            location.reload();
        };

        socket.onclose = function() {
            updateConnectionStatus(false);
            if (reconnectAttempts < maxReconnectAttempts) {
                reconnectAttempts++;
                setTimeout(connectWebSocket, 3000 * reconnectAttempts);
            }
        };

        socket.onerror = function(error) {
            console.error('WebSocket error:', error);
        };
    }

    function updateConnectionStatus(connected) {
        const statusElement = document.getElementById('connectionStatus');
        if (statusElement) {
            if (connected) {
                statusElement.className = 'connection-status connected';
                statusElement.innerHTML = '<i class="fas fa-wifi"></i> Connected';
            } else {
                statusElement.className = 'connection-status disconnected';
                statusElement.innerHTML = '<i class="fas fa-wifi"></i> Disconnected';
            }
        }
    }

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

    if (Notification.permission !== 'granted' && Notification.permission !== 'denied') {
        Notification.requestPermission();
    }

    document.getElementById('messageType').addEventListener('change', toggleMessageForm);
    document.getElementById('messageType').addEventListener('change', function() {
        document.getElementById('content').value = '';
        document.getElementById('quizId').value = '';
    });

    document.addEventListener('DOMContentLoaded', function() {
        connectWebSocket();
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

    window.addEventListener('beforeunload', function() {
        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.close();
        }
    });
</script>
</body>
</html>
