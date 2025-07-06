package Models;

public class QuizTag {
    private long quizId;
    private long tagId;

    public QuizTag() {}

    public QuizTag(long quizId, long tagId) {
        this.quizId = quizId;
        this.tagId = tagId;
    }

    public long getQuizId() {
        return quizId;
    }

    public void setQuizId(long quizId) {
        this.quizId = quizId;
    }

    public long getTagId() {
        return tagId;
    }

    public void setTagId(long tagId) {
        this.tagId = tagId;
    }
}
