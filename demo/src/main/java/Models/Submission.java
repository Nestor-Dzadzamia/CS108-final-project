package Models;

import java.sql.Timestamp;

public class Submission {
    private long submissionId;
    private long userId;
    private long quizId;
    private long numCorrectAnswers;
    private long numTotalAnswers;
    private long score;
    private long timeSpent;  // in seconds or milliseconds as per your app
    private Timestamp submittedAt;

    public Submission() {}

    public Submission(long submissionId, long userId, long quizId,
                      long numCorrectAnswers, long numTotalAnswers,
                      long score, long timeSpent, Timestamp submittedAt) {
        this.submissionId = submissionId;
        this.userId = userId;
        this.quizId = quizId;
        this.numCorrectAnswers = numCorrectAnswers;
        this.numTotalAnswers = numTotalAnswers;
        this.score = score;
        this.timeSpent = timeSpent;
        this.submittedAt = submittedAt;
    }

    // Getters and setters
    public long getSubmissionId() { return submissionId; }
    public void setSubmissionId(long submissionId) { this.submissionId = submissionId; }

    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public long getQuizId() { return quizId; }
    public void setQuizId(long quizId) { this.quizId = quizId; }

    public long getNumCorrectAnswers() { return numCorrectAnswers; }
    public void setNumCorrectAnswers(long numCorrectAnswers) { this.numCorrectAnswers = numCorrectAnswers; }

    public long getNumTotalAnswers() { return numTotalAnswers; }
    public void setNumTotalAnswers(long numTotalAnswers) { this.numTotalAnswers = numTotalAnswers; }

    public long getScore() { return score; }
    public void setScore(long score) { this.score = score; }

    public long getTimeSpent() { return timeSpent; }
    public void setTimeSpent(long timeSpent) { this.timeSpent = timeSpent; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
}
