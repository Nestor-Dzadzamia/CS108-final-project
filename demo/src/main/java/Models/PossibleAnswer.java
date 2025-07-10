package Models;

public class PossibleAnswer {
    private long possibleAnswerId;
    private long questionId;
    private String possibleAnswerText;

    // Getters and Setters
    public long getPossibleAnswerId() { return possibleAnswerId; }
    public void setPossibleAnswerId(long possibleAnswerId) { this.possibleAnswerId = possibleAnswerId; }

    public long getQuestionId() { return questionId; }
    public void setQuestionId(long questionId) { this.questionId = questionId; }

    public String getPossibleAnswerText() { return possibleAnswerText; }
    public void setPossibleAnswerText(String possibleAnswerText) { this.possibleAnswerText = possibleAnswerText; }
}

