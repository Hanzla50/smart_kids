class QuizQuestions{
  const QuizQuestions(this.text, this.answers);

  final String text;
  final List<String> answers;


  List<String> getShuffledAnswers(){
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList; 
  }
}
class MathQuestions{
  const MathQuestions(this.text, this.answers);

  final String text;
  final List<String> answers;


  List<String> getShuffledAnswers(){
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList; 
  }
}

class GeneralKnowledgeQuestions {
  const GeneralKnowledgeQuestions(
    this.text,
    this.image,
    this.answers,
  );

  final String text;
  final String image;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
