import 'package:flutter/material.dart';
import 'package:smart_kids_v1/pages/quiz/data/math_questions.dart';
import 'package:smart_kids_v1/pages/quiz/models/quiz_questions.dart';
import 'package:smart_kids_v1/pages/quiz/question_screen.dart';
import 'package:smart_kids_v1/pages/quiz/start_screen.dart';
import 'package:smart_kids_v1/pages/quiz/data/questions.dart';
import 'package:smart_kids_v1/pages/quiz/result_screen.dart';

class Quiz extends StatefulWidget {
  // final String subject;
  Quiz({super.key, });

  
  @override
  State<Quiz> createState() {
    return _Quiz();
  }
}

class _Quiz extends State<Quiz> {
  List<String> selectedAnswers = [];
  // List<QuizQuestions> questions = [];
  var activeScreen = 'start_screen';

  // void initState() {
  //   super.initState();
  //   _loadQuestions();
  // }

  // void _loadQuestions() {
  //   if (widget.subject == 'math') {
  //     questions = math_questions;
  //   } else if (widget.subject == 'english') {
  //     questions = questions;
  //   }
  // }

  void switchScreen() {
    setState(() {
      activeScreen = 'questions_screen';
      // activeScreen = QuestionScreen();
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);
    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = 'result_screen';
      });
    }
  }

  void restartQuiz(){
    setState((){

      selectedAnswers = [];
      activeScreen = 'question_screen';
    });
  }
  @override
  Widget build(context) {
    Widget screenWidget = StartScreeen(switchScreen);
    if (activeScreen == 'questions_screen') {
      screenWidget = QuestionScreen(
        onSelectAnswer: chooseAnswer,
      );
    }

    if (activeScreen == 'result_screen'){
      screenWidget = ResultScreen(chosenAnswer: selectedAnswers, onRestart: restartQuiz,);
      
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
