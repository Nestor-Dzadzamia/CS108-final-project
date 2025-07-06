package Models;

public class CorrectAnswer {
    private long answerId;
    private long questionId;
    private String answerText;
    private Long matchOrder;  // can be null

    public CorrectAnswer(long answerId, long questionId, String answerText, Long matchOrder) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.answerText = answerText;
        this.matchOrder = matchOrder;
    }

    public CorrectAnswer(long questionId, String answerText, Long matchOrder) {
        this.questionId = questionId;
        this.answerText = answerText;
        this.matchOrder = matchOrder;
    }

    public long getAnswerId() {
        return answerId;
    }

    public void setAnswerId(long answerId) {
        this.answerId = answerId;
    }

    public long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(long questionId) {
        this.questionId = questionId;
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public Long getMatchOrder() {
        return matchOrder;
    }

    public void setMatchOrder(Long matchOrder) {
        this.matchOrder = matchOrder;
    }

    @Override
    public String toString() {
        return "CorrectAnswer{" +
                "answerId=" + answerId +
                ", questionId=" + questionId +
                ", answerText='" + answerText + '\'' +
                ", matchOrder=" + matchOrder +
                '}';
    }
}
