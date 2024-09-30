import 'package:smart_kids_v1/ENGLISH_GAMES/Generate_Letter_Groups.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_01_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_02_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_03_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_05_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_04_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_06_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_07_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_08_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/English_Quizzes/Quiz_09_Eng.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_01_Math.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_02_Math.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_03_Math.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_04_Math.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_05_Math.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_06_Math.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Math_Quizzes/Quiz_07_Math.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math'; // Import for Random

class QuizMenuScreen extends StatefulWidget {
  @override
  _QuizMenuScreenState createState() => _QuizMenuScreenState();
}

class _QuizMenuScreenState extends State<QuizMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure the app is always in portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set the status bar color to white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Status bar color
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for white background
      systemNavigationBarColor: Colors.white, // Optional: Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.dark, // Optional: Dark icons for navigation bar
    ));

    // Allow the status bar to be visible
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(1, 212, 119, 1),

        title: Text(
          'Quizzes',
          style: TextStyle(
            fontFamily: "MadimiOne",
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        titleSpacing: 5,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.fromRGBO(1, 212, 119, 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 5), // Space between heading and menu items
            Expanded(
              child: ListView.builder(
                itemCount: 23,
                itemBuilder: (context, index) {
                  final images = [
                    'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                    'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                    'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                    'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                    'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                    'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                     'assets/English_Games/english_quiz_icon.png',
                    'assets/Math_Games/math_quiz_icon.png',
                    'assets/General_know_Games/gn_quiz_icon.png',
                     'assets/English_Games/english_quiz_icon.png',
                      'assets/English_Games/english_quiz_icon.png',

                 
                  ];
                  final titles = [
                    'English Quiz 01',
                    'Math Quiz 01',
                    'General Knowledge Quiz 01',
                    'English Quiz 02',
                    'Math Quiz 02',
                    'General Knowledge Quiz 02',
                    'English Quiz 03',
                    'Math Quiz 03',
                    'General Knowledge Quiz 03',
                    'English Quiz 04',
                    'Math Quiz 04',
                    'General Knowledge Quiz 04',
                    'English Quiz 05',
                    'Math Quiz 05',
                    'General Knowledge Quiz 05',
                    'English Quiz 06',
                    'Math Quiz 06',
                    'General Knowledge Quiz 06',
                     'English Quiz 07',
                    'Math Quiz 07',
                    'General Knowledge Quiz 07',
                     'English Quiz 08',
                    'English Quiz 09',

                  ];
                  final subtitles = [
                    'Letter Guessing and Letter Matching',
                    'Spot and Guess Numbers',
                    'General Knowledge',
                    'Missing Letters and Arrange Letters',
                    'Sort Numbers',
                    'General Knowledge',
                    'Sort Letters',
                    'Even Odds and Identify Numbers',
                    'General Knowledge',
                    'Identify letters and Vowels',
                    'Arrange Numbers and Less More',
                    'General Knowledge',
                    'Missing Letter and Word',
                    'Count Objects',
                    'World History',
                     'Match Letter and Words',
                    'Addition Practice',
                    'General Knowledge',
                    'Opposite and Rhyming words',
                    'Subtraction Practice',
                    'General Knowledge',
                    'Spell Numbers and Count Syllables',
                    'Make Sentences from words',

                  ];

                  return _buildMenuCard(
                    context,
                    index + 1,
                    images[index],
                    titles[index],
                    subtitles[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    int number,
    String imagePath,
    String title,
    String subtitle,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to the respective quiz screen based on the card tapped
        if (number == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_01_Eng()),
          );
        }
        if (number == 2) { 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_01_Math()),
          );
        }
        if (number == 4) {
          GenerateLetterGroups generateLetterGroups = GenerateLetterGroups(
            isUpperCase: false,
            gameType: 'Quiz', // This is a placeholder; adjust as per your logic
          );
          List<String> letterGroups =
              generateLetterGroups.generateLetterGroups();
          Random random = Random();
          int randomIndex = random.nextInt(5);
          String selectedLetters = letterGroups[randomIndex];
          // Navigate to the Quiz_01_Eng2 screen with the selectedLetters
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Quiz_02_Eng(sequence: selectedLetters),
            ),
          );
        }
        if (number == 5) {
          // Define available ranges
          final List<String> numberRanges = [
            "11-20",
            "21-30",
            "31-40",
            "51-60",
            // Add more ranges as needed
          ];

          // Select a random range from the predefined list
          final random = Random();
          String selectedRange =
              numberRanges[random.nextInt(numberRanges.length)];

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Quiz_02_Math(
                      selectedNumbers: selectedRange,
                    )),
          );
        }
         if (number == 7) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_03_Eng()),
          );
        }
         if (number == 8) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_03_Math()),
          );
        }
         if (number == 10) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_04_Eng()),
          );
        }
         if (number == 11) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_04_Math()),
          );
        }
        if (number == 13) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_05_Eng()),
          );
        }
        if (number == 14) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_05_Math()),
          );
        }
        if (number == 16) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_06_Eng()),
          );
        }
           if (number == 17) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_06_Math()),
          );
        }
         if (number == 19) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_07_Eng()),
          );
        }
           if (number == 20) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_07_Math()),
          );
        }
        if (number == 22) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_08_Eng()),
          );
        }
        if (number == 23) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_09_Eng()),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(1, 212, 119, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: TextStyle(
                fontFamily: 'madimiOne',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Card(
                  color: Colors.amber,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontFamily: 'madimiOne',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 5),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontFamily: 'madimiOne',
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Icon(
                    Icons.help,
                    color: Colors.white.withOpacity(0.5),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
