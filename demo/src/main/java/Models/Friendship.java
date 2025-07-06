package Models;

import java.sql.Timestamp;

public class Friendship {
    private long userId1;
    private long userId2;
    private Timestamp friendsSince;

    public Friendship() {}

    public Friendship(long userId1, long userId2, Timestamp friendsSince) {
        this.userId1 = userId1;
        this.userId2 = userId2;
        this.friendsSince = friendsSince;
    }

    public long getUserId1() {
        return userId1;
    }

    public void setUserId1(long userId1) {
        this.userId1 = userId1;
    }

    public long getUserId2() {
        return userId2;
    }

    public void setUserId2(long userId2) {
        this.userId2 = userId2;
    }

    public Timestamp getFriendsSince() {
        return friendsSince;
    }

    public void setFriendsSince(Timestamp friendsSince) {
        this.friendsSince = friendsSince;
    }
}
