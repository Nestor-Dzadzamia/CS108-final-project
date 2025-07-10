package Models;

public class PossibleAnswer {
    private long possibleAnswerId;
    private long questionId;
    private String possibleAnswerText;

    public  PossibleAnswer() {

    }


    public PossibleAnswer(long l, String s) {
        this.questionId = l;
        this.possibleAnswerText = s;
    }

    public PossibleAnswer(long l, long l1, String s) {
        this.possibleAnswerId = l;
        this.questionId = l1;
        this.possibleAnswerText = s;
    }


    // Getters and Setters
    public long getPossibleAnswerId() { return possibleAnswerId; }
    public void setPossibleAnswerId(long possibleAnswerId) { this.possibleAnswerId = possibleAnswerId; }

    public long getQuestionId() { return questionId; }
    public void setQuestionId(long questionId) { this.questionId = questionId; }

    public String getPossibleAnswerText() { return possibleAnswerText; }
    public void setPossibleAnswerText(String possibleAnswerText) { this.possibleAnswerText = possibleAnswerText; }
}

