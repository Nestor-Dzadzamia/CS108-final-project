package Servlets;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/messageSocket")
public class MessageWebSocketEndpoint {

    private static final Map<Long, Set<Session>> userSessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket opened: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject json = gson.fromJson(message, JsonObject.class);
            if ("connect".equals(json.get("type").getAsString())) {
                long userId = json.get("userId").getAsLong();
                userSessions.computeIfAbsent(userId, k -> ConcurrentHashMap.newKeySet()).add(session);
                System.out.println("User " + userId + " connected to WebSocket.");
            }
        } catch (Exception e) {
            System.err.println("WebSocket error parsing message: " + e.getMessage());
        }
    }

    @OnClose
    public void onClose(Session session) {
        userSessions.values().forEach(sessions -> sessions.remove(session));
        userSessions.entrySet().removeIf(entry -> entry.getValue().isEmpty());
        System.out.println("WebSocket closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
        throwable.printStackTrace();
    }

    public static void sendMessageToUser(Long userId, String message) {
        System.out.println("Attempting WS send to user " + userId + ": " + message);
        Set<Session> sessions = userSessions.get(userId);
        if (sessions != null) {
            sessions.removeIf(session -> {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                        return false;
                    } else {
                        return true;
                    }
                } catch (IOException e) {
                    System.err.println("Error sending to user " + userId + ": " + e.getMessage());
                    return true;
                }
            });
            if (sessions.isEmpty()) {
                userSessions.remove(userId);
            }
        }
    }
}
