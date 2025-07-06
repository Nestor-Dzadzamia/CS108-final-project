package DAO;

import DB.DBConnection;
import Models.FriendRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FriendRequestDao {

    public FriendRequest createFriendRequest(FriendRequest request) throws SQLException {
        String sql = "INSERT INTO friend_requests (sender_id, receiver_id, status) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, request.getSenderId());
            stmt.setLong(2, request.getReceiverId());
            stmt.setString(3, request.getStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating friend request failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    request.setRequestId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating friend request failed, no ID obtained.");
                }
            }
        }

        return request;
    }

    public FriendRequest getFriendRequestById(long requestId) throws SQLException {
        String sql = "SELECT * FROM friend_requests WHERE request_id = ?";
        FriendRequest request = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, requestId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    request = mapResultSetToFriendRequest(rs);
                }
            }
        }

        return request;
    }

    public List<FriendRequest> getPendingRequestsForUser(long receiverId) throws SQLException {
        String sql = "SELECT * FROM friend_requests WHERE receiver_id = ? AND status = 'pending' ORDER BY sent_at DESC";
        List<FriendRequest> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, receiverId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFriendRequest(rs));
                }
            }
        }

        return list;
    }

    public boolean updateFriendRequestStatus(long requestId, String newStatus) throws SQLException {
        if (!newStatus.equals("pending") && !newStatus.equals("accepted") && !newStatus.equals("rejected")) {
            throw new IllegalArgumentException("Status must be 'pending', 'accepted', or 'rejected'");
        }

        String sql = "UPDATE friend_requests SET status = ? WHERE request_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setLong(2, requestId);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteFriendRequest(long requestId) throws SQLException {
        String sql = "DELETE FROM friend_requests WHERE request_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, requestId);

            return stmt.executeUpdate() > 0;
        }
    }

    private FriendRequest mapResultSetToFriendRequest(ResultSet rs) throws SQLException {
        FriendRequest request = new FriendRequest();
        request.setRequestId(rs.getLong("request_id"));
        request.setSenderId(rs.getLong("sender_id"));
        request.setReceiverId(rs.getLong("receiver_id"));
        request.setStatus(rs.getString("status"));
        request.setSentAt(rs.getTimestamp("sent_at"));
        return request;
    }
}
