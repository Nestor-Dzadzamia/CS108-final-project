package Questions;

import java.util.Set;

public abstract class Question {
    int id;
    int question_type_id;
    String question;
    public Question(int id, int question_type_id, String question ){
        this.question = question;
        this.id = id;
        this.question_type_id = question_type_id;
    }
    public String getQuestion() {
        return question;
    }
    public abstract Set<String> getCorrectAnswers() ;
    public abstract int getScore(String answer);
}
