
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreeen extends StatelessWidget {
  const StartScreeen(this.startQuiz, {super.key});

  final void  Function() startQuiz;



  @override
  Widget build(context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/quiz-logo.png',
              width: 200,
              color: const Color.fromARGB(150, 255, 255, 255),
            ),
            const SizedBox(height: 50),
            Text(
              'Smart Kids',
              style: GoogleFonts.lato(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton.icon(
                onPressed: startQuiz,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                icon: const Icon(Icons.arrow_right_alt),
                label: const Text(
                  'Start quiz',
                ))
          ],
        ),
      ),
    );
  }
}
