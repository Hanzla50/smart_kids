import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:smart_kids_v1/pages/quiz/answer_button.dart';
import 'package:smart_kids_v1/pages/quiz/data/general_knowledge_questions.dart';

class GeneralQuestionScreen extends StatefulWidget {
  const GeneralQuestionScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;

  @override
  State<GeneralQuestionScreen> createState() {
    return _GeneralQuestionScreen();
  }
}

class _GeneralQuestionScreen extends State<GeneralQuestionScreen> {
  var currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswers) {
    widget.onSelectAnswer(selectedAnswers);
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = generalKnowledgeQuestions[currentQuestionIndex];
    
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (currentQuestion.text != null)
              Text(
                currentQuestion.text!,
                style: GoogleFonts.lato(
                    color: const Color.fromARGB(255, 201, 153, 251),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            if (currentQuestion.text != null) const SizedBox(height: 30),

            if (currentQuestion.image != null)
              Image.asset(
                currentQuestion.image!,
                height: 200, // Adjust height as needed
                fit: BoxFit.cover,
              ),
            if (currentQuestion.image != null) const SizedBox(height: 30),
            
            ...currentQuestion.getShuffledAnswers().map((answer) {
              return AnswerButton(
                  answerText: answer,
                  onTap: () {
                    answerQuestion(answer);
                  });
            })
          ],
        ),
      ),
    );
  }
}
