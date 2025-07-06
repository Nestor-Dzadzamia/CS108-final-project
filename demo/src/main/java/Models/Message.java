package Models;

import java.sql.Timestamp;

public class Message {
    private long messageId;
    private long senderId;
    private long receiverId;
    private String messageType; // friend_request, challenge, note
    private String content;
    private Long quizId;          // nullable
    private Long friendRequestId; // nullable
    private Timestamp sentAt;
    private boolean isRead;

    public Message() {}

    public Message(long messageId, long senderId, long receiverId, String messageType, String content,
                   Long quizId, Long friendRequestId, Timestamp sentAt, boolean isRead) {
        this.messageId = messageId;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.messageType = messageType;
        this.content = content;
        this.quizId = quizId;
        this.friendRequestId = friendRequestId;
        this.sentAt = sentAt;
        this.isRead = isRead;
    }

    // Getters and setters
    public long getMessageId() { return messageId; }
    public void setMessageId(long messageId) { this.messageId = messageId; }

    public long getSenderId() { return senderId; }
    public void setSenderId(long senderId) { this.senderId = senderId; }

    public long getReceiverId() { return receiverId; }
    public void setReceiverId(long receiverId) { this.receiverId = receiverId; }

    public String getMessageType() { return messageType; }
    public void setMessageType(String messageType) { this.messageType = messageType; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Long getQuizId() { return quizId; }
    public void setQuizId(Long quizId) { this.quizId = quizId; }

    public Long getFriendRequestId() { return friendRequestId; }
    public void setFriendRequestId(Long friendRequestId) { this.friendRequestId = friendRequestId; }

    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
}
