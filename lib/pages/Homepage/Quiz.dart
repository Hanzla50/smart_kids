import 'package:flutter/material.dart';

import 'package:smart_kids_v1/pages/Homepage/home_page.dart';
import 'package:smart_kids_v1/pages/quiz/general_knowledge_quiz/general_quiz.dart';
import 'package:smart_kids_v1/pages/quiz/math_quiz/math_quiz.dart';
import 'package:smart_kids_v1/pages/quiz/quiz.dart';

class HomeTask extends StatelessWidget {
  const HomeTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Task'), // Text in AppBar
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Dictionary_Glossary/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Add space between AppBar and content
              SizedBox(height: 30),
              // Main Row Content
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageWithText(
                    context,
                    "assets/images/quiz.png",
                    "Quiz",
                    Quiz_menu(),
                  ),
                  _buildImageWithText(
                    context,
                    "assets/images/quiz.png",
                    "Assessments",
                    Assesments(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithText(
    BuildContext context,
    String imagePath,
    String labelText,
    Widget nextPage,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(imagePath, width: 120),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Text(
                      labelText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // Space between image and text (optional)
        ],
      ),
    );
  }
}


class Quiz_menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0), // Remove app bar space
            child: AppBar(
              elevation: 0, // Remove app bar shadow
              backgroundColor: Colors.transparent, // Make app bar transparent
            ),
          ),
          extendBodyBehindAppBar: true, // Extend body behind app bar
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/Dictionary_Glossary/background.png',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                          16.0, 24.0, 0.0, 8.0), // Adjusted padding
                      child: Text(
                        'Quiz',
                        style: TextStyle(
                          fontFamily: 'MadimiOne', // Change font family
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0, // Adjusted font size
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // First row with two images and text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildImageWithText(context,
                                  "assets/images/Early.png", "English", Quiz()),
                              SizedBox(height: 20),
                              _buildImageWithText(
                                  context,
                                  "assets/images/Dictionary.png",
                                  "Math",
                                  MathQuiz()),
                            ],
                          ),
                          SizedBox(height: 30),
                          //Second row with two images and text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildImageWithText(context,"assets/images/subject.png", "General Knowledge", GeneralQuiz()),
                              SizedBox(height: 20),
                              // _buildImageWithText(context,"assets/images/art.png", "Art", ArtMenu()),
                            ],
                          ),
                          // SizedBox(height: 30),
                          // // Third row with two images and text
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     _buildImageWithText("assets/images/game.png", "Games", Gamespage()),
                          //     SizedBox(height: 20),
                          //     _buildImageWithText("assets/images/quiz.png", "Quizzes", Quiz_menu()),
                          //   ],
                          // ),
                          // SizedBox(height: 30),
                          // Row(

                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     _buildImageWithText("assets/images/to_do_list_logo.png", "Daily_Schedule", Daily_Schedule()),
                          //     SizedBox(height: 20),
                          //     _buildImageWithText("assets/images/white.png", "", Daily_Schedule()),

                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    const Homepage(studentName: '')));
                          },
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .white, // Background color of the circle
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                size: 30.0,
                                color: Colors.green, // Color of the arrow icon
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithText(BuildContext context, String imagePath,
      String labelText, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(imagePath, width: 120),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Text(
                      labelText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Assesments extends StatelessWidget {
  const Assesments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assesments'),
      ),
    );
  }
}
