package Models.Questions;

public class Question {
    private long questionId;
    private long quizId;
    private String questionType;
    private String questionText;
    private String imageUrl;
    private long timeLimit;
    private int questionOrder;

    // Getters and Setters
    public long getQuestionId() { return questionId; }
    public void setQuestionId(long questionId) { this.questionId = questionId; }

    public long getQuizId() { return quizId; }
    public void setQuizId(long quizId) { this.quizId = quizId; }

    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public long getTimeLimit() { return timeLimit; }
    public void setTimeLimit(long timeLimit) { this.timeLimit = timeLimit; }

    public int getQuestionOrder() { return questionOrder; }
    public void setQuestionOrder(int questionOrder) { this.questionOrder = questionOrder; }
}
