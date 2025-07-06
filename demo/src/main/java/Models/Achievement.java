package Models;

import java.sql.Timestamp;

public class Achievement {
    private long achievementId;
    private String achievementName;
    private String achievementDescription;
    private String iconUrl;
    private Timestamp awardedAt;  // nullable, used when user achievement is retrieved

    // Default constructor
    public Achievement() {}

    // Constructor without awardedAt (for general achievement info)
    public Achievement(long achievementId, String achievementName, String achievementDescription, String iconUrl) {
        this(achievementId, achievementName, achievementDescription, iconUrl, null);
    }

    // Full constructor (including awardedAt)
    public Achievement(long achievementId, String achievementName, String achievementDescription, String iconUrl, Timestamp awardedAt) {
        this.achievementId = achievementId;
        this.achievementName = achievementName;
        this.achievementDescription = achievementDescription;
        this.iconUrl = iconUrl;
        this.awardedAt = awardedAt;
    }

    // Getters and setters

    public long getAchievementId() {
        return achievementId;
    }

    public void setAchievementId(long achievementId) {
        this.achievementId = achievementId;
    }

    public String getAchievementName() {
        return achievementName;
    }

    public void setAchievementName(String achievementName) {
        this.achievementName = achievementName;
    }

    public String getAchievementDescription() {
        return achievementDescription;
    }

    public void setAchievementDescription(String achievementDescription) {
        this.achievementDescription = achievementDescription;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public Timestamp getAwardedAt() {
        return awardedAt;
    }

    public void setAwardedAt(Timestamp awardedAt) {
        this.awardedAt = awardedAt;
    }
}
