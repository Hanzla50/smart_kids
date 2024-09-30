import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../text_to_speech.dart'; // Import your text-to-speech class

class ShowResult extends StatefulWidget {
  final text_to_speech _textToSpeech =
      text_to_speech(); // Initialize the text-to-speech instance
  final int scoreObtained;
  final int totalmarks;

  ShowResult({required this.scoreObtained, required this.totalmarks});

  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  @override
  void initState() {
    super.initState();
    // Enable immersive sticky mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Speak the obtained score when the screen is displayed
    final percentage = calculatePercentage();
    speakScore(percentage);
  }

  // Method to calculate the percentage score
  int calculatePercentage() {
    if (widget.totalmarks == 0) return 0; // Avoid division by zero
    return ((widget.scoreObtained / widget.totalmarks) * 100).toInt();
  }

  // Method to determine the category based on the percentage
  String determineCategory(int percentage) {
    if (percentage >= 75) {
      return 'Good';
    } else if (percentage >= 50) {
      return 'Average';
    } else {
      return 'Bad';
    }
  }

  // Method to speak the obtained score
  void speakScore(int percentage) {
    String speechText = "You have got $percentage percent marks in the quiz.";
    widget._textToSpeech.speak(speechText);
    
  }

  @override
  Widget build(BuildContext context) {
    final percentage = calculatePercentage();
    final category = determineCategory(percentage);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/board_background.png', // Replace with your background image path
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                 widget._textToSpeech.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizMenuScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Result',
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$percentage% Score',
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 28,
                  color: Colors.orangeAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$category',
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Marks: ${widget.scoreObtained} / ${widget.totalmarks}',
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
