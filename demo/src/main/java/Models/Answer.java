package Models;

public class Answer {
    private long answerId;
    private long questionId;
    private String answerText;
    private long matchOrder; // For ordered multi-answer

    // Getters and Setters
    public long getAnswerId() { return answerId; }
    public void setAnswerId(long answerId) { this.answerId = answerId; }

    public long getQuestionId() { return questionId; }
    public void setQuestionId(long questionId) { this.questionId = questionId; }

    public String getAnswerText() { return answerText; }
    public void setAnswerText(String answerText) { this.answerText = answerText; }

    public long getMatchOrder() { return matchOrder; }
    public void setMatchOrder(long matchOrder) { this.matchOrder = matchOrder; }
}
