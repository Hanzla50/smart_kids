import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_kids_v1/pages/quiz/data/math_questions.dart';
import 'package:smart_kids_v1/pages/quiz/math_quiz/math_question_summary.dart';

class MathResultScreen extends StatelessWidget {
  const MathResultScreen({
    super.key,
    required this.chosenAnswer,
    required this.onRestart,
  });

  final void Function() onRestart;
  final List<String> chosenAnswer;

  Future<void> updateQuizReport(int correctAnswers, int totalQuestions) async {
    final prefs = await SharedPreferences.getInstance();
    int quizzesDone = prefs.getInt('math_quizzes_done') ?? 0;
    int totalScore = prefs.getInt('math_total_score') ?? 0;

    quizzesDone += 1;
    totalScore += correctAnswers;

    await prefs.setInt('math_quizzes_done', quizzesDone);
    await prefs.setInt('math_total_score', totalScore);
    await prefs.setDouble('math_total_percentage', (totalScore / (quizzesDone * totalQuestions)) * 100);
  }

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add(
        {
          'math_question_index': i,
          'math_question': math_questions[i].text,
          'correct_answer': math_questions[i].answers[0],
          'user_answer': chosenAnswer[i],
        },
      );
    }
    return summary;
  }

  @override
  Widget build(context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = math_questions.length;
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    // Update quiz report
    updateQuizReport(numCorrectQuestions, numTotalQuestions);

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 230, 200, 253),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            MathQuestionSummary(summaryData),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz!'),
            ),
          ],
        ),
      ),
    );
  }
}
