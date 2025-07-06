package Models;

import java.sql.Timestamp;

public class UserAchievement {
    private long userId;
    private long achievementId;
    private Timestamp awardedAt;

    public UserAchievement() {}

    public UserAchievement(long userId, long achievementId, Timestamp awardedAt) {
        this.userId = userId;
        this.achievementId = achievementId;
        this.awardedAt = awardedAt;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getAchievementId() {
        return achievementId;
    }

    public void setAchievementId(long achievementId) {
        this.achievementId = achievementId;
    }

    public Timestamp getAwardedAt() {
        return awardedAt;
    }

    public void setAwardedAt(Timestamp awardedAt) {
        this.awardedAt = awardedAt;
    }
}
