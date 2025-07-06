package Models;

public class PossibleAnswer {
    private long possibleAnswerId;
    private long questionId;
    private String possibleAnswerText;

    public PossibleAnswer(long possibleAnswerId, long questionId, String possibleAnswerText) {
        this.possibleAnswerId = possibleAnswerId;
        this.questionId = questionId;
        this.possibleAnswerText = possibleAnswerText;
    }

    public PossibleAnswer(long questionId, String possibleAnswerText) {
        this.questionId = questionId;
        this.possibleAnswerText = possibleAnswerText;
    }

    public long getPossibleAnswerId() {
        return possibleAnswerId;
    }

    public void setPossibleAnswerId(long possibleAnswerId) {
        this.possibleAnswerId = possibleAnswerId;
    }

    public long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(long questionId) {
        this.questionId = questionId;
    }

    public String getPossibleAnswerText() {
        return possibleAnswerText;
    }

    public void setPossibleAnswerText(String possibleAnswerText) {
        this.possibleAnswerText = possibleAnswerText;
    }

    @Override
    public String toString() {
        return "PossibleAnswer{" +
                "possibleAnswerId=" + possibleAnswerId +
                ", questionId=" + questionId +
                ", possibleAnswerText='" + possibleAnswerText + '\'' +
                '}';
    }
}
