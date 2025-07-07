package Models;

import java.sql.Timestamp;

public class Quiz {
    private long quizId;
    private String quizTitle;
    private String description;
    private Long createdBy;
    private boolean randomized;
    private boolean isMultiplePage;
    private boolean immediateCorrection;
    private boolean allowPractice;
    private Timestamp createdAt;
    private Long quizCategory;
    private Long totalTimeLimit;
    private long submissionsNumber;

    public Quiz() { } // no-arg

    public Quiz(long quizId, String quizTitle, String description, Long createdBy,
                boolean randomized, boolean isMultiplePage, boolean immediateCorrection,
                boolean allowPractice, Timestamp createdAt, Long quizCategory,
                Long totalTimeLimit, long submissionsNumber) {
        this.quizId = quizId;
        this.quizTitle = quizTitle;
        this.description = description;
        this.createdBy = createdBy;
        this.randomized = randomized;
        this.isMultiplePage = isMultiplePage;
        this.immediateCorrection = immediateCorrection;
        this.allowPractice = allowPractice;
        this.createdAt = createdAt;
        this.quizCategory = quizCategory;
        this.totalTimeLimit = totalTimeLimit;
        this.submissionsNumber = submissionsNumber;
    }


    public long getQuizId() { return quizId; }
    public void setQuizId(long quizId) { this.quizId = quizId; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public boolean isRandomized() { return randomized; }
    public void setRandomized(boolean randomized) { this.randomized = randomized; }

    public boolean isMultiplePage() { return isMultiplePage; }
    public void setMultiplePage(boolean multiplePage) { isMultiplePage = multiplePage; }

    public boolean isImmediateCorrection() { return immediateCorrection; }
    public void setImmediateCorrection(boolean immediateCorrection) { this.immediateCorrection = immediateCorrection; }

    public boolean isAllowPractice() { return allowPractice; }
    public void setAllowPractice(boolean allowPractice) { this.allowPractice = allowPractice; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Long getQuizCategory() { return quizCategory; }
    public void setQuizCategory(Long quizCategory) { this.quizCategory = quizCategory; }

    public Long getTotalTimeLimit() { return totalTimeLimit; }
    public void setTotalTimeLimit(Long totalTimeLimit) { this.totalTimeLimit = totalTimeLimit; }

    public long getSubmissionsNumber() { return submissionsNumber; }
    public void setSubmissionsNumber(long submissionsNumber) { this.submissionsNumber = submissionsNumber; }
}
