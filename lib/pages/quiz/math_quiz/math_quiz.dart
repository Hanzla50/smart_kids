import 'package:flutter/material.dart';
import 'package:smart_kids_v1/pages/quiz/data/math_questions.dart';
import 'package:smart_kids_v1/pages/quiz/math_quiz/math_questions_screen.dart';
import 'package:smart_kids_v1/pages/quiz/math_quiz/math_results_screen.dart';
import 'package:smart_kids_v1/pages/quiz/start_screen.dart';

class MathQuiz extends StatefulWidget {
  const MathQuiz({super.key});

  @override
  State<MathQuiz> createState() {
    return _MathQuiz();
  }
}

class _MathQuiz extends State<MathQuiz> {
  List<String> selectedAnswers = [];
  var activeScreen = 'start_screen';

  void switchScreen() {
    setState(() {
      activeScreen = 'q_screen';
      //activeScreen = QuestionScreen();
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);
    if (selectedAnswers.length == math_questions.length) {
      setState(() {
        activeScreen = 'r_screen';
      });
    }
  }

  void restartQuiz(){
    setState((){

      selectedAnswers = [];
      activeScreen = 'q_screen';
    });
  }
  @override
  Widget build(context) {
    Widget screenWidget = StartScreeen(switchScreen);
    if (activeScreen == 'q_screen') {
      screenWidget = MathQuestionScreen(
        onSelectAnswer: chooseAnswer,
      );
    }

    if (activeScreen == 'r_screen'){
      screenWidget = MathResultScreen(chosenAnswer: selectedAnswers, onRestart: restartQuiz,);
      
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
