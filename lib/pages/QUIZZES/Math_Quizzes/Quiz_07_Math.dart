import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart';

class Quiz_07_Math extends StatefulWidget {
  @override
  _Quiz_07_MathState createState() => _Quiz_07_MathState();
}

class _Quiz_07_MathState extends State<Quiz_07_Math> {
  int _attempts = 1;
  final int _maxAttempts = 2;
  final text_to_speech _textToSpeech = text_to_speech();
  final List<List<String>> imagePairs = [
    ['assets/Math_Games/objects_2.png', 'assets/Math_Games/objects_1.png'],
    ['assets/Math_Games/objects_3.png', 'assets/Math_Games/objects_4.png'],
    ['assets/Math_Games/objects_5.png', 'assets/Math_Games/objects_6.png'],
    ['assets/Math_Games/objects_8.png', 'assets/Math_Games/objects_7.png'],
    ['assets/Math_Games/objects_10.png', 'assets/Math_Games/objects_9.png'],
    ['assets/Math_Games/objects_3.png', 'assets/Math_Games/objects_7.png'],
    ['assets/Math_Games/objects_8.png', 'assets/Math_Games/objects_4.png'],
  ];
  final List<List<int>> options = [
    [8, 9, 7],
    [4, 5, 3],
    [1, 3, 2],
    [4, 3, 5],
    [4, 3, 5],
    [5, 6, 4],
    [2, 1, 3],

    // Corresponding options for each pair
  ];
  final List<int> correctAnswers = [
    7, // 1 + 2
    4, // 3 + 4
    2, // 5 + 6
    3, // 7 + 8
    4, // 9 + 10
    6, // 3 + 7
    1, //4 + 8
    // Add corresponding answers
  ];

  late List<String> _selectedImages;
  late int _correctAnswer;
  late List<int> _selectedOptions;
  int? _draggedOption;

  @override
  void initState() {
    ScoreManager().resetScore();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
    _setLandscapeMode();
    _loadNewImages();
    _textToSpeech.speak('Subtract the objects and choose the right option');
  }

  @override
  void dispose() {
    _setPortraitMode();
    super.dispose();
  }

  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _loadNewImages() {
    int index = Random().nextInt(imagePairs.length);
    setState(() {
      _selectedImages = imagePairs[index];
      _correctAnswer = correctAnswers[index];
      _selectedOptions = options[index];
      _draggedOption = null;
    });
    _textToSpeech.speak('Subtract the objects and choose the right option');
  }

  void _checkAnswer() {
    _attempts++; 
    if (_draggedOption == _correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
      ));
      _textToSpeech.speak('Good job, Correct answer');
      ScoreManager().increaseScore(5); // Increment score for correct answer
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Try Again!'),
        backgroundColor: Colors.red,
      ));
      _textToSpeech.speak('Oops, that’s not correct, ');
    }
    if (_attempts <= _maxAttempts) {
      Future.delayed(Duration(seconds: 3), _loadNewImages);
    } else {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowResult(
              scoreObtained: ScoreManager().score,
              totalmarks: 10,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Math_Games/board_background_3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //______________________________________________________
          // board
          Positioned(
            top: 40,
            left: 115,
            child: Column(
              children: [
                Image.asset(_selectedImages[0], height: 170),
              ],
            ),
          ),
          const Positioned(
            top: 140,
            left: 350,
            child: Column(
              children: [
                Text('-',
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                      fontFamily: 'madimiOne',
                    )),
              ],
            ),
          ),
          const Positioned(
            top: 150,
            right: 290,
            child: Column(
              children: [
                Text('=',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.orangeAccent,
                      fontFamily: 'madimiOne',
                    )),
              ],
            ),
          ),
          Positioned(
            top: 190,
            left: 135,
            child: Column(
              children: [
                Image.asset(_selectedImages[1], height: 170),
              ],
            ),
          ),
          Positioned(
            top: 163,
            right: 205,
            child: DragTarget<int>(
              onWillAccept: (receivedOption) => true,
              onAccept: (receivedOption) {
                setState(() {
                  _draggedOption = receivedOption;
                });
                _checkAnswer();
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      _draggedOption?.toString() ?? '?',
                      style: TextStyle(
                        fontSize: 34,
                        color: _draggedOption != null
                            ? Colors.brown
                            : Colors.redAccent,
                        fontFamily: 'madimiOne',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 60,
            right: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _selectedOptions.map((option) {
                return Draggable<int>(
                  data: option,
                  child: _buildOptionBox(option),
                  feedback: Material(
                    color: Colors.white.withOpacity(0),
                    child: _buildOptionBox(option, isDragging: true),
                  ),
                  childWhenDragging: _buildOptionBox(option,
                      isDragging: false, isHidden: true),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _textToSpeech.stop();
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
        ],
      ),
    );
  }

  Widget _buildOptionBox(int option,
      {bool isDragging = false, bool isHidden = false}) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: isHidden ? Colors.transparent : Colors.redAccent,
        border: Border.all(
            color: isDragging ? Colors.white.withOpacity(0) : Colors.white,
            width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          option.toString(),
          style: TextStyle(
            fontFamily: 'madimiOne',
            fontSize: 34,
            color: isHidden ? Colors.transparent : Colors.white,
          ),
        ),
      ),
    );
  }
}
