package Models;

import java.sql.Timestamp;

public class UserAnswer {
    private long userAnswerId;
    private long submissionId;
    private long questionId;
    private String answerText;
    private boolean isCorrect;
    private Timestamp answeredAt;

    public UserAnswer() {}

    public UserAnswer(long userAnswerId, long submissionId, long questionId,
                      String answerText, boolean isCorrect, Timestamp answeredAt) {
        this.userAnswerId = userAnswerId;
        this.submissionId = submissionId;
        this.questionId = questionId;
        this.answerText = answerText;
        this.isCorrect = isCorrect;
        this.answeredAt = answeredAt;
    }

    // Getters and setters
    public long getUserAnswerId() { return userAnswerId; }
    public void setUserAnswerId(long userAnswerId) { this.userAnswerId = userAnswerId; }

    public long getSubmissionId() { return submissionId; }
    public void setSubmissionId(long submissionId) { this.submissionId = submissionId; }

    public long getQuestionId() { return questionId; }
    public void setQuestionId(long questionId) { this.questionId = questionId; }

    public String getAnswerText() { return answerText; }
    public void setAnswerText(String answerText) { this.answerText = answerText; }

    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }

    public Timestamp getAnsweredAt() { return answeredAt; }
    public void setAnsweredAt(Timestamp answeredAt) { this.answeredAt = answeredAt; }
}
