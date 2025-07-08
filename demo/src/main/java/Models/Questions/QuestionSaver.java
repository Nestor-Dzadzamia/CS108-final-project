package Models.Questions;

public class QuestionSaver {
    private long quizId;
    private String questionType;
    private String questionText;
    private String imageUrl;
    private long timeLimit;
    private int questionOrder;

    // Getters
    public long getQuizId() {
        return quizId;
    }

    public String getQuestionType() {
        return questionType;
    }

    public String getQuestionText() {
        return questionText;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public long getTimeLimit() {
        return timeLimit;
    }

    public int getQuestionOrder() {
        return questionOrder;
    }

    // Setters
    public void setQuizId(long quizId) {
        this.quizId = quizId;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public void setTimeLimit(long timeLimit) {
        this.timeLimit = timeLimit;
    }

    public void setQuestionOrder(int questionOrder) {
        this.questionOrder = questionOrder;
    }
}
