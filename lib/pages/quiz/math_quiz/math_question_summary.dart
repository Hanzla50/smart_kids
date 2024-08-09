import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MathQuestionSummary extends StatelessWidget {
  const MathQuestionSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            return SItem(data);
          }).toList(),
        ),
      ),
    );
  }
}


class SItem extends StatelessWidget {
  const SItem(this.itemData, {super.key});

  final Map<String, Object> itemData;

  @override
  Widget build(BuildContext context) {
    final isCorrectAnswer = itemData['user_answer'] == itemData['correct_answer'];
    final int? questionIndex = itemData['math_question_index'] as int?;
    
    if (questionIndex == null) {
      // Handle the null case appropriately, e.g., skip this item or show an error message
      return const SizedBox.shrink(); // Return an empty widget
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QIdentifier(
          isCorrectAnswer: isCorrectAnswer,
          questionIndex: questionIndex,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemData['math_question'] as String,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                itemData['user_answer'] as String,
                style: const TextStyle(
                  color: Color.fromARGB(255, 202, 171, 252),
                ),
              ),
              Text(
                itemData['correct_answer'] as String,
                style: const TextStyle(
                  color: Color.fromARGB(255, 181, 254, 246),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QIdentifier extends StatelessWidget{
  const QIdentifier({super.key, required this.isCorrectAnswer, required this.questionIndex});

  final int questionIndex;
  final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    final questionNumber = questionIndex + 1;
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCorrectAnswer ? const Color.fromARGB(255, 150, 198, 241)
        : const Color.fromARGB(255, 249, 133, 241 ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        questionNumber.toString(),
        style:  const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 22, 2, 56),
        ),
      ),

    );
  }
}