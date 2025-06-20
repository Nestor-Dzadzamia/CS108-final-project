package Questions;

import java.util.Collections;
import java.util.Set;

public class QuestionResponse extends Question {
    public QuestionResponse(int id, int question_type_id, String question, String correctAnswer, int maxScore ){
        super(id,question_type_id,question);
    }
    @Override
    public Set<String> getCorrectAnswers() {
        return Collections.singleton("");
    }
    @Override
    public int getScore(String answer) {
        return 0;
    }

}

