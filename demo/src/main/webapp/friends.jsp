<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Friends - QuizApp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .friends-container { max-width: 1000px; margin: 2rem auto; }
        .section { margin-bottom: 2rem; padding: 1.5rem; background: white; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .user-card, .friend-card { margin-bottom: 1rem; transition: transform 0.2s; }
        .user-card:hover, .friend-card:hover { transform: translateY(-2px); }
        .profile-header { background: linear-gradient(135deg, #4e54c8, #8f94fb); color: white; padding: 2rem; border-radius: 10px; }
        .stat-box { text-align: center; padding: 1rem; background: #f8f9fa; border-radius: 8px; margin: 0.5rem; }
    </style>
</head>
<body>
<div class="container">
    <div class="friends-container">
        <h2 class="mb-4">
            <c:choose>
                <c:when test="${not empty profileUser}">
                    ${profileUser.username}'s Profile
                </c:when>
                <c:otherwise>
                    Friends & Users
                </c:otherwise>
            </c:choose>
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <!-- User Profile Section -->
        <c:if test="${not empty profileUser}">
            <div class="section">
                <div class="profile-header text-center">
                    <h3>${profileUser.username}</h3>
                    <p>Member since: ${profileUser.timeCreated != null ? profileUser.timeCreated.toString().substring(0,10) : "N/A"}</p>

                    <c:if test="${!isOwnProfile && !areFriends}">
                        <form method="post" action="friends" style="margin-top: 1rem;">
                            <input type="hidden" name="action" value="send">
                            <input type="hidden" name="targetUserId" value="${profileUser.id}">
                            <button type="submit" class="btn btn-light">Add Friend</button>
                        </form>
                    </c:if>

                    <c:if test="${areFriends}">
                        <span class="badge bg-success fs-6 mt-2">✓ Friends</span>
                    </c:if>
                </div>

                <div class="row mt-3">
                    <div class="col-md-3">
                        <div class="stat-box">
                            <h4>${profileUser.numQuizzesCreated}</h4>
                            <small>Quizzes Created</small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box">
                            <h4>${profileUser.numQuizzesTaken}</h4>
                            <small>Quizzes Taken</small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box">
                            <h4>${profileUser.wasTop1 ? "Yes" : "No"}</h4>
                            <small>Top Achiever</small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-box">
                            <h4>${profileUser.takenPractice ? "Yes" : "No"}</h4>
                            <small>Practice Mode</small>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty userQuizzes}">
                    <h5 class="mt-4">Quizzes by ${profileUser.username}</h5>
                    <div class="row">
                        <c:forEach var="quiz" items="${userQuizzes}">
                            <div class="col-md-6 mb-2">
                                <div class="card">
                                    <div class="card-body">
                                        <h6>${quiz.quizTitle}</h6>
                                        <p class="card-text small">${quiz.description}</p>
                                        <small class="text-muted">Taken ${quiz.submissionsNumber} times</small>
                                        <br><a href="quiz-summary.jsp?quizId=${quiz.quizId}" class="btn btn-sm btn-primary mt-1">View Quiz</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <div class="text-center mt-3">
                    <a href="friends" class="btn btn-secondary">Back to Friends</a>
                </div>
            </div>
        </c:if>

        <!-- Main Friends Interface (only show if not viewing a profile) -->
        <c:if test="${empty profileUser}">
            <!-- Search Section -->
            <div class="section">
                <h4>Find Users</h4>
                <form method="get" action="friends">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search by username or email..." value="${searchQuery}">
                        <button class="btn btn-primary" type="submit">Search</button>
                    </div>
                </form>

                <c:if test="${not empty searchResults}">
                    <h6 class="mt-3">Search Results</h6>
                    <div class="row">
                        <c:forEach var="user" items="${searchResults}">
                            <div class="col-md-6 mb-2">
                                <div class="card user-card">
                                    <div class="card-body">
                                        <h6>${user.username}</h6>
                                        <small class="text-muted">
                                            Quizzes: ${user.numQuizzesCreated} created, ${user.numQuizzesTaken} taken
                                        </small>
                                        <div class="mt-2">
                                            <a href="friends?action=profile&userId=${user.id}" class="btn btn-sm btn-outline-primary">View Profile</a>
                                            <form method="post" action="friends" style="display:inline;">
                                                <input type="hidden" name="action" value="send">
                                                <input type="hidden" name="targetUserId" value="${user.id}">
                                                <button type="submit" class="btn btn-sm btn-success">Add Friend</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${not empty searchQuery and empty searchResults}">
                    <div class="alert alert-info mt-3">No users found matching "${searchQuery}".</div>
                </c:if>
            </div>

            <!-- Friend Requests Section -->
            <c:if test="${not empty pendingRequests}">
                <div class="section">
                    <h4>Friend Requests</h4>
                    <c:forEach var="request" items="${pendingRequests}" varStatus="status">
                        <div class="card friend-card">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">${requestSenders[status.index].username}</h6>
                                    <small class="text-muted">Sent: ${request.sentAt}</small>
                                </div>
                                <div>
                                    <form method="post" action="friends" style="display:inline;">
                                        <input type="hidden" name="action" value="accept">
                                        <input type="hidden" name="requestId" value="${request.requestId}">
                                        <button class="btn btn-success btn-sm">Accept</button>
                                    </form>
                                    <form method="post" action="friends" style="display:inline;">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="requestId" value="${request.requestId}">
                                        <button class="btn btn-danger btn-sm">Reject</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Friends List Section -->
            <div class="section">
                <h4>Your Friends</h4>
                <c:if test="${not empty friends}">
                    <div class="row">
                        <c:forEach var="friend" items="${friends}">
                            <div class="col-md-6 mb-2">
                                <div class="card friend-card">
                                    <div class="card-body">
                                        <h6>${friend.username}</h6>
                                        <small class="text-muted">
                                            Quizzes: ${friend.numQuizzesCreated} created, ${friend.numQuizzesTaken} taken
                                        </small>
                                        <div class="mt-2">
                                            <a href="friends?action=profile&userId=${friend.id}" class="btn btn-sm btn-outline-primary">View Profile</a>
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeFriend(${friend.id}, '${friend.username}')">Remove</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${empty friends}">
                    <div class="alert alert-info">You don't have any friends yet. Use the search above to find users!</div>
                </c:if>
            </div>

            <!-- Navigation -->
            <div class="text-center">
                <a href="homepage.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
        </c:if>
    </div>
</div>

<!-- Remove Friend Modal -->
<div class="modal fade" id="removeFriendModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Remove Friend</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Remove <span id="friendName"></span> from your friends list?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form method="post" action="friends" style="display:inline;">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="targetUserId" id="friendIdToRemove">
                    <button type="submit" class="btn btn-danger">Remove</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function removeFriend(friendId, friendName) {
        document.getElementById('friendName').textContent = friendName;
        document.getElementById('friendIdToRemove').value = friendId;
        new bootstrap.Modal(document.getElementById('removeFriendModal')).show();
    }
</script>
</body>
</html>