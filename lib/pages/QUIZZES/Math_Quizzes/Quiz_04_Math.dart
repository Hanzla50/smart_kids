import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart';

class Quiz_04_Math extends StatefulWidget { // Arrange Number Game
  @override
  _Quiz_04_MathState createState() => _Quiz_04_MathState();
}

class _Quiz_04_MathState extends State<Quiz_04_Math> {
  List<int> _numbers = [];
  List<int> _sortedNumbers = [];
  List<int?> _userArrangement = [null, null, null];
  String _instruction = '';
  bool _isAscending = true;
  final text_to_speech _textToSpeech = text_to_speech();

  @override
  void initState() {
    super.initState();
    ScoreManager().resetScore();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeGame();
  }
  Future<void> _initializeGame() async {
    Random random = Random();
    // Generate random numbers between 1 and 100
    _numbers = List<int>.generate(3, (_) => random.nextInt(100) + 1);
    _isAscending = random.nextBool();
    _sortedNumbers = List.from(_numbers)..sort();
    if (!_isAscending) {
      _sortedNumbers = _sortedNumbers.reversed.toList();
    }
    _instruction = _isAscending
        ? 'Arrange from small to large'
        : 'Arrange from large to small';
    _userArrangement = [null, null, null];
    setState(() {});

    // Guide the player by speaking the instruction
    await _textToSpeech.speak(_instruction);
  }

  void _onAccept(int index, int number) {
    setState(() {
      _userArrangement[index] = number;
    });

    // Check if all boxes are filled
    if (_userArrangement.every((number) => number != null)) {
      _giveFeedback();
    }
  }

  void _giveFeedback() async {
    if (_isCorrect()) {
      ScoreManager().increaseScore(5); // Increment score for correct answer
      await _textToSpeech
          .speak('Well done! You arranged the numbers correctly.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wrong!'),
        backgroundColor: Colors.red,
      ));
      await _textToSpeech.speak('Oops! This is not correct.');
    }
    
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Quiz_04_Math2()),
      );
    });
  }

  bool _isCorrect() {
    return _userArrangement.every((number) => number != null) &&
        List.generate(
                3, (index) => _userArrangement[index] == _sortedNumbers[index])
            .every((element) => element);
  }

  void _resetBoxes() {
    setState(() {
      _userArrangement = [null, null, null];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Instruction Text
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Text(
              _instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "madimiOne",
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),

          // Number Boxes for Arrangement (Top Row)
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Hen Image behind the number box
                    Image.asset(
                      'assets/Math_Games/squirrel.png',
                      width: 210,
                      height: 210,
                      color: Colors.black.withOpacity(0),
                      colorBlendMode: BlendMode.darken,
                    ),
                    // Drop Target Box
                    DragTarget<int>(
                      onAccept: (number) => _onAccept(index, number),
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _userArrangement[index] != null
                                ? Colors.brown.withOpacity(0)
                                : Colors.brown.withOpacity(0),
                          ),
                          child: Center(
                            child: Text(
                              _userArrangement[index]?.toString() ?? '',
                              style: const TextStyle(
                                fontFamily: "madimiOne",
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ),

          // Draggable Number Boxes (Bottom Row)
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _numbers.map((number) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Draggable Number Box
                    Draggable<int>(
                      data: number,
                      childWhenDragging: _buildNumberBox(null),
                      feedback: _buildNumberBox(number, isFeedback: true),
                      child: _buildNumberBox(number),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),         
          // Reset Button (Bottom Right)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _resetBoxes,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Back Button (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _textToSpeech.stop();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizMenuScreen()),
                  );                },
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

  // Define _buildNumberBox method to handle the creation of number boxes
  Widget _buildNumberBox(int? number, {bool isFeedback = false}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(20),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: number != null ? Colors.green : Colors.brown,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          number?.toString() ?? '',
          style: TextStyle(
            fontFamily: "madimiOne",
            fontSize: isFeedback ? 32 : 24, // Slightly larger font for feedback
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

//_______________________________________________________________________________________
//________________________________________________________________________________________

class Quiz_04_Math2 extends StatefulWidget {
  @override
  _Quiz_04_Math2State createState() => _Quiz_04_Math2State();
}

class _Quiz_04_Math2State extends State<Quiz_04_Math2> {
  final text_to_speech _textToSpeech = text_to_speech();
  final List<List<String>> imagePairs = [
    ['assets/Math_Games/objects_1.png', 'assets/Math_Games/objects_2.png'],
    ['assets/Math_Games/objects_3.png', 'assets/Math_Games/objects_4.png'],
    ['assets/Math_Games/objects_5.png', 'assets/Math_Games/objects_6.png'],
    ['assets/Math_Games/objects_7.png', 'assets/Math_Games/objects_8.png'],
    ['assets/Math_Games/objects_9.png', 'assets/Math_Games/objects_10.png'],
    ['assets/Math_Games/objects_3.png', 'assets/Math_Games/objects_7.png'],
    ['assets/Math_Games/objects_8.png', 'assets/Math_Games/objects_4.png'],
  ];

  final List<int> objectCounts = [
    2, 9, // Counts for first pair
    8, 4, // Counts for second pair
    5, 3, // Counts for third pair
    2, 5, // Counts for fourth pair
    4, 8, // Counts for fifth pair
    8, 2, // Counts for sixth pair
    4, 5, // Counts for seventh pair
  ];

  late String _gameTitle;
  late List<String> _selectedImages;
  late int _correctAnswer; // 0 for first image, 1 for second image

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
    _setLandscapeMode();
    _loadNewGame();
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

  void _loadNewGame() {
    int index = Random().nextInt(imagePairs.length);
    _selectedImages = imagePairs[index];

    // Randomly select "Select More" or "Select Less"
    _gameTitle = Random().nextBool() ? "Select More" : "Select Less";

    // Ensure we access the correct object counts
    int count1 = objectCounts[index * 2];
    int count2 = objectCounts[index * 2 + 1];

    // Determine correct answer based on the game title
    if (_gameTitle == "Select More") {
      _correctAnswer = (count1 < count2) ? 1 : 0; // 1 means select second image
    } else {
      _correctAnswer = (count1 > count2) ? 1 : 0; // 1 means select second image
    }

    setState(() {});

    // Speak the game title
    _textToSpeech.speak(_gameTitle);
  }

  void _checkAnswer(int selectedImage) {
    if (selectedImage == _correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
      ));
      ScoreManager().increaseScore(5); // Increment score for correct answer
      _textToSpeech.speak('Good job, that’s the correct answer');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Try Again!'),
        backgroundColor: Colors.red,
      ));
      _textToSpeech.speak('Oops, that’s not correct');
    }
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
@override
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40, // Adjust the top position to bring it lower
            left: 250, // Add some left padding
            right: 250, // Add some right padding
            child: Container(
              height: 60, // Set a fixed height for the title bar
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20), // Rounded corners
                border:
                    Border.all(color: Colors.green, width: 4), // Orange border
              ),
              padding: EdgeInsets.all(0),
              child: Center(
                child: Text(
                  _gameTitle,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 150, // Adjust the top position to fit below the title bar
            left: 60,
            child: Column(
              children: [
                Container(
                  width: 340, // Set a width for the box
                  height: 180, // Set a height for the box
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    border: Border.all(
                        color: Colors.green, width: 3), // Orange border
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        _checkAnswer(0), // Check if first image is selected
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20), // Match the container
                      child: Image.asset(_selectedImages[0], height: 160),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150, // Adjust the top position to fit below the title bar
            right: 50,
            child: Column(
              children: [
                Container(
                  width: 340, // Set a width for the box
                  height: 180, // Set a height for the box
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    border: Border.all(
                        color: Colors.green, width: 3), // Orange border
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        _checkAnswer(1), // Check if second image is selected
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20), // Match the container
                      child: Image.asset(_selectedImages[1], height: 160),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(padding: EdgeInsets.all(10)),
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
}