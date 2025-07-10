package Models;

import java.sql.Timestamp;

public class FriendRequest {
    private long requestId;
    private long senderId;
    private long receiverId;
    private String status; // "pending", "accepted", "rejected"
    private Timestamp sentAt;
    private String senderName; // Added field for sender's username

    public FriendRequest() {}

    public FriendRequest(long requestId, long senderId, long receiverId, String status, Timestamp sentAt) {
        this.requestId = requestId;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.status = status;
        this.sentAt = sentAt;
    }

    public long getRequestId() {
        return requestId;
    }

    public void setRequestId(long requestId) {
        this.requestId = requestId;
    }

    public long getSenderId() {
        return senderId;
    }

    public void setSenderId(long senderId) {
        this.senderId = senderId;
    }

    public long getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(long receiverId) {
        this.receiverId = receiverId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (!status.equals("pending") && !status.equals("accepted") && !status.equals("rejected")) {
            throw new IllegalArgumentException("Status must be 'pending', 'accepted', or 'rejected'");
        }
        this.status = status;
    }

    public Timestamp getSentAt() {
        return sentAt;
    }

    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }

    // New getter and setter for senderName
    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }
}