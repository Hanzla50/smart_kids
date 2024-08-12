import 'package:flutter/material.dart';

import 'package:smart_kids_v1/pages/quiz/data/general_knowledge_questions.dart';
import 'package:smart_kids_v1/pages/quiz/general_knowledge_quiz/general_question_screen.dart';
import 'package:smart_kids_v1/pages/quiz/general_knowledge_quiz/general_result_screen.dart';
import 'package:smart_kids_v1/pages/quiz/start_screen.dart';

class GeneralQuiz extends StatefulWidget {
  GeneralQuiz({super.key});

  @override
  State<GeneralQuiz> createState() {
    return _GeneralQuiz();
  }
}

class _GeneralQuiz extends State<GeneralQuiz> {
  List<String> selectedAnswers = [];
  var activeScreen = 'start_screen';

  void switchScreen() {
    setState(() {
      activeScreen = 'general_question_screen';
      //activeScreen = QuestionScreen();
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);
    if (selectedAnswers.length == generalKnowledgeQuestions.length) {
      setState(() {
        activeScreen = 'general_result_screen';
      });
    }
  }

  void restartQuiz(){
    setState((){

      selectedAnswers = [];
      activeScreen = 'general_question_screen';
    });
  }
  @override
  Widget build(context) {
    Widget screenWidget = StartScreeen(switchScreen);
    if (activeScreen == 'general_question_screen') {
      screenWidget = GeneralQuestionScreen(
        onSelectAnswer: chooseAnswer,
      );
    }

    if (activeScreen == 'general_result_screen'){
      screenWidget = GeneralResultScreen(chosenAnswer: selectedAnswers, onRestart: restartQuiz,);
      
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Color.fromARGB(255, 100, 28, 168)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
