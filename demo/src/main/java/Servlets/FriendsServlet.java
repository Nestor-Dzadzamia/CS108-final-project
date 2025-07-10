package Servlets;

import DAO.*;
import Models.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/friends")
public class FriendsServlet extends HttpServlet {

    private UserDao userDao;
    private FriendshipDao friendshipDao;
    private FriendRequestDao friendRequestDao;
    private QuizDao quizDao;

    @Override
    public void init() {
        userDao = new UserDao();
        friendshipDao = new FriendshipDao();
        friendRequestDao = new FriendRequestDao();
        quizDao = new QuizDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String userId = request.getParameter("userId");
        String search = request.getParameter("search");

        try {
            // Show user profile
            if ("profile".equals(action) && userId != null) {
                User profileUser = userDao.getUserById(Long.parseLong(userId));
                if (profileUser != null) {
                    boolean areFriends = friendshipDao.areFriends(currentUser.getId(), profileUser.getId());
                    List<Quiz> userQuizzes = quizDao.getQuizzesByUser(profileUser.getId());

                    request.setAttribute("profileUser", profileUser);
                    request.setAttribute("areFriends", areFriends);
                    request.setAttribute("userQuizzes", userQuizzes);
                    request.setAttribute("isOwnProfile", currentUser.getId().equals(profileUser.getId()));
                }
            }

            // Search users
            List<User> searchResults = null;
            if (search != null && !search.trim().isEmpty()) {
                searchResults = userDao.searchUsers(search.trim(), currentUser.getId());
                request.setAttribute("searchQuery", search);
            }

            // Get friends and requests
            List<User> friends = userDao.getFriends(currentUser.getId());
            List<FriendRequest> pendingRequests = friendRequestDao.getPendingRequestsForUser(currentUser.getId());

            request.setAttribute("searchResults", searchResults);
            request.setAttribute("friends", friends);
            request.setAttribute("pendingRequests", pendingRequests);

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.getRequestDispatcher("friends.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String targetUserId = request.getParameter("targetUserId");
        String requestId = request.getParameter("requestId");

        try {
            if ("send".equals(action) && targetUserId != null) {
                long targetId = Long.parseLong(targetUserId);
                if (!friendshipDao.areFriends(currentUser.getId(), targetId)) {
                    // Create friend request
                    FriendRequest friendRequest = new FriendRequest();
                    friendRequest.setSenderId(currentUser.getId());
                    friendRequest.setReceiverId(targetId);
                    friendRequest.setStatus("pending");
                    friendRequestDao.createFriendRequest(friendRequest);
                    request.setAttribute("success", "Friend request sent!");
                }
            } else if ("accept".equals(action) && requestId != null) {
                long reqId = Long.parseLong(requestId);

                // Get the friend request details
                FriendRequest friendRequest = friendRequestDao.getFriendRequestById(reqId);
                if (friendRequest != null && friendRequest.getReceiverId() == currentUser.getId()) {
                    // Update request status to accepted
                    friendRequestDao.updateFriendRequestStatus(reqId, "accepted");

                    // Add friendship
                    friendshipDao.addFriendship(friendRequest.getSenderId(), friendRequest.getReceiverId());

                    request.setAttribute("success", "Friend request accepted!");
                }
            } else if ("reject".equals(action) && requestId != null) {
                long reqId = Long.parseLong(requestId);
                friendRequestDao.updateFriendRequestStatus(reqId, "rejected");
                request.setAttribute("success", "Friend request rejected.");
            } else if ("remove".equals(action) && targetUserId != null) {
                long targetId = Long.parseLong(targetUserId);
                friendshipDao.removeFriendship(currentUser.getId(), targetId);
                request.setAttribute("success", "Friend removed.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        response.sendRedirect("friends");
    }
}