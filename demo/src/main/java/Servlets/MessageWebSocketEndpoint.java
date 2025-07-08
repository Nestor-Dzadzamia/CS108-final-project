package Servlets;


import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/messageSocket")
public class MessageWebSocketEndpoint {

    // Store active sessions by user ID
    private static final Map<Long, Set<Session>> userSessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket connection opened: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject jsonMessage = gson.fromJson(message, JsonObject.class);
            String type = jsonMessage.get("type").getAsString();

            if ("connect".equals(type)) {
                Long userId = jsonMessage.get("userId").getAsLong();
                userSessions.computeIfAbsent(userId, k -> ConcurrentHashMap.newKeySet()).add(session);
                System.out.println("User " + userId + " connected via WebSocket");
            }
        } catch (Exception e) {
            System.err.println("Error processing WebSocket message: " + e.getMessage());
        }
    }

    @OnClose
    public void onClose(Session session) {
        // Remove session from all user mappings
        userSessions.values().forEach(sessions -> sessions.remove(session));
        userSessions.entrySet().removeIf(entry -> entry.getValue().isEmpty());
        System.out.println("WebSocket connection closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error for session " + session.getId() + ": " + throwable.getMessage());
        throwable.printStackTrace();
    }

    // Method to send message to specific user
    public static void sendMessageToUser(Long userId, String message) {
        Set<Session> sessions = userSessions.get(userId);
        if (sessions != null) {
            sessions.removeIf(session -> {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                        return false;
                    } else {
                        return true; // Remove closed sessions
                    }
                } catch (IOException e) {
                    System.err.println("Error sending message to user " + userId + ": " + e.getMessage());
                    return true; // Remove failed sessions
                }
            });

            // Clean up empty session sets
            if (sessions.isEmpty()) {
                userSessions.remove(userId);
            }
        }
    }

    // Helper method to create message notification JSON
    public static String createMessageNotification(String type, String senderName, String content, String quizTitle, Long quizId) {
        JsonObject notification = new JsonObject();
        notification.addProperty("type", type);
        notification.addProperty("senderName", senderName);
        notification.addProperty("content", content);
        notification.addProperty("timestamp", new Date().toString());

        if (quizTitle != null) {
            notification.addProperty("quizTitle", quizTitle);
        }
        if (quizId != null) {
            notification.addProperty("quizId", quizId);
        }

        return gson.toJson(notification);
    }

    // Method to get connected users count (for debugging)
    public static int getConnectedUsersCount() {
        return userSessions.size();
    }
}