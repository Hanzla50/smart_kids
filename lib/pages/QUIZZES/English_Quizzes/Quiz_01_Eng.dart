import 'dart:math';
import 'package:smart_kids_v1/ENGLISH_GAMES/Generate_Letter_Groups.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart'; // Import your text-to-speech class
import '../score_manager.dart'; // Import ScoreManager

class Quiz_01_Eng extends StatefulWidget { // Letter Bubble Game
  @override
  _Quiz_01_EngState createState() => _Quiz_01_EngState();
}
class _Quiz_01_EngState extends State<Quiz_01_Eng> {
  final text_to_speech _textToSpeech =text_to_speech(); // Initialize the text-to-speech instance
  static const int totalBubbles = 7; // Total number of bubbles
  static const int maxPops = 3; // Maximum number of bubbles that can be popped before ending the game
  List<String> _letters = [];
  List<Offset> _positions = [];
  late String _targetLetter;
  bool _gameOver = false;
  String _feedbackText = '';
  int _pops = 0; // Track the number of bubbles popped
  bool _isInitialized = false; // Track if the game is initialized

  @override
  void initState() {
   
    ScoreManager().resetScore();
    super.initState();
    // Set up landscape mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    // Start the game after a small delay to ensure the UI is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        _initializeGame();
      });
    });
  }
  void _initializeGame() {
    setState(() {
      _isInitialized = true;
    });
    
    _startNewRound();
  }
  void _startNewRound() {
    // Ensure the game state is reset correctly
    setState(() {
      _gameOver = false;
      _feedbackText = '';
      _letters = _generateRandomLetters(totalBubbles);
      _positions = _generateFixedPositions();
      _targetLetter = _letters[Random().nextInt(_letters.length)];
    });

    _speakTargetLetter();
  }

  List<String> _generateRandomLetters(int count) {
    return List.generate(count, (_) => _generateRandomLetter());
  }

  List<Offset> _generateFixedPositions() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate horizontal spacing to center the bubbles
    final double bubbleSize = 80.0;

    // First row (3 bubbles)
    final double spacingFirstRow = (screenWidth - (3 * bubbleSize)) / 4;

    // Second row (4 bubbles)
    final double spacingSecondRow = (screenWidth - (4 * bubbleSize)) / 5;

    return [
      // First row (3 bubbles)
      Offset(spacingFirstRow, screenHeight * 0.3),
      Offset(2 * spacingFirstRow + bubbleSize, screenHeight * 0.3),
      Offset(3 * spacingFirstRow + 2 * bubbleSize, screenHeight * 0.3),

      // Second row (4 bubbles)
      Offset(spacingSecondRow, screenHeight * 0.6),
      Offset(2 * spacingSecondRow + bubbleSize, screenHeight * 0.6),
      Offset(3 * spacingSecondRow + 2 * bubbleSize, screenHeight * 0.6),
      Offset(4 * spacingSecondRow + 3 * bubbleSize, screenHeight * 0.6),
    ];
  }

  String _generateRandomLetter() {
    return String.fromCharCode(Random().nextInt(26) + 65); // A-Z
  }

  Future<void> _speakTargetLetter() async {
    await _textToSpeech.speak('Pop the letter $_targetLetter');
  }

  void _checkAnswer(String selectedLetter) {
    if (_gameOver) return;

    _pops++;

    if (selectedLetter == _targetLetter) {
      setState(() {
        _feedbackText = 'Correct';
      });
      _textToSpeech.speak('Correct');
      ScoreManager().increaseScore(2); // Update collective score
    } else {
      setState(() {
        _feedbackText = 'Wrong';
      });
      _textToSpeech.speak('Wrong');
    }

    if (_pops >= maxPops) {
        Future.delayed(Duration(seconds: 3), () {
        // Instantiate the GenerateLetterGroups class
        GenerateLetterGroups generateLetterGroups = GenerateLetterGroups(
          isUpperCase: false, gameType: 'Quiz', // This is a placeholder; adjust as per your logic
        );
        List<String> letterGroups =
            generateLetterGroups.generateLetterGroups();
        Random random = Random();
        int randomIndex =
            random.nextInt(5); 
        String selectedLetters = letterGroups[randomIndex];
        // Navigate to the Quiz_01_Eng2 screen with the selectedLetters
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Quiz_01_Eng2(selectedLetters: selectedLetters),
          ),
        );
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        if (!_gameOver) {
          _startNewRound();
        }
      });
    }
  }

  

  void _resetGame() {
    setState(() {
      _gameOver = false;
      _pops = 0;
    });
    _startNewRound();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _letters.isEmpty || _positions.isEmpty) {
      // Show a loading indicator if the game is not initialized
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
          ..._letters.asMap().entries.map((entry) {
            int index = entry.key;
            String letter = entry.value;

            return Positioned(
              top: _positions[index].dy,
              left: _positions[index].dx,
              child: GestureDetector(
                onTap: () => _checkAnswer(letter),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontFamily: 'madimiOne',
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

            Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _textToSpeech.stop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => QuizMenuScreen(),
                    ),
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
          Positioned(
            top: 16,
            right: 380,
            child: Text(
              _feedbackText,
              style: TextStyle(
                fontFamily: "madimiOne",
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _feedbackText == 'Correct' ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//___________________________________________________________________________________
//___________________________________________________________________________________

class Quiz_01_Eng2 extends StatefulWidget { // Upper case with Lower Case Matching
  final String selectedLetters;

  Quiz_01_Eng2({required this.selectedLetters});

  @override
  _Quiz_01_Eng2State createState() => _Quiz_01_Eng2State();
}

class _Quiz_01_Eng2State extends State<Quiz_01_Eng2> {
  bool _isInitialized = false; // Track if the game is initialized

  late Map<String, String> leftItems;
  late Map<String, String> rightItems;
  final text_to_speech _textToSpeech =
      text_to_speech(); // Initialize the text-to-speech instance
  String _feedbackText = ''; // Variable to hold feedback text
  @override
  void initState() {
    super.initState();
    _textToSpeech.speak('Question no 2, Match uppercase letters, with the lowercase letters');
    // Hide the status bar and force landscape mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeGame();
  }


  void _initializeGame() {
    _isInitialized = true; // Track if the game is initialized

    List<String> letters = widget.selectedLetters.split('');

    // Initialize leftItems with empty values
    leftItems = {for (var letter in letters) letter: ''};

    // Initialize rightItems with shuffled letters in lowercase
    rightItems = {for (var letter in letters) letter.toLowerCase(): letter};
    rightItems = Map.fromEntries(rightItems.entries.toList()..shuffle());
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
      _feedbackText = ''; // Clear feedback text on reset
    });
  }

  void _checkAnswers() {
    bool allMatched = true;
    leftItems.forEach((key, value) {
      if (key.toLowerCase() != value) {
        allMatched = false;
      }
    });
    // Speak the result
    if (allMatched) {
      _textToSpeech.speak('Great job! You matched it');
      _feedbackText = 'Great job! You matched it';
      ScoreManager().increaseScore(4); // Update collective score
    } 
    else {
      _textToSpeech.speak('Some Matches are incorrect');
      _feedbackText = 'Some Matches are incorrect';
    }
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ShowResult(
            scoreObtained: ScoreManager().score, // Get the cumulative score
            totalmarks: 10, // Adjust as needed
          ),
        ),
      );
    });
    setState(() {}); // Refresh the UI to show feedback text
  }

  Widget _buildDraggableItem(String item, Color color) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.green, width: 3.0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          item,
          style: TextStyle(
            fontSize: 30,
            color: Colors.orangeAccent,
            fontFamily: 'coco_bold',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/game_background_3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main game area
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Feedback text
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      _feedbackText,
                      style: TextStyle(
                        fontFamily: 'madimiOne',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _feedbackText.contains('Great job')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
                // First row: Uppercase letters (ABC)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: leftItems.keys.map((item) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.green, width: 3.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 28,
                                  fontFamily: 'coco_bold',
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0), // Add space between rows
                // Second row: Empty boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: leftItems.keys.map((item) {
                          return DragTarget<String>(
                            onWillAccept: (data) => leftItems[item] == '',
                            onAccept: (data) {
                              setState(() {
                                leftItems[item] = data!;
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.green, width: 3.0),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: candidateData.isNotEmpty
                                      ? [
                                          BoxShadow(
                                              color: Colors.green,
                                              blurRadius: 5)
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    leftItems[item]!,
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 28,
                                      fontFamily: 'coco_bold',
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0), // Add space between rows
                // Third row: Lowercase letters
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: rightItems.keys.map((item) {
                          return Draggable<String>(
                            data: item,
                            child: _buildDraggableItem(item, Colors.white),
                            feedback: Material(
                              color: Colors.green,
                              child: _buildDraggableItem(item, Colors.green),
                            ),
                            childWhenDragging:
                                _buildDraggableItem(item, Colors.green),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Check Answers Button
            Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _checkAnswers();
                  _textToSpeech.stop();
                  
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
         // Back Arrow Button
           Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _textToSpeech.stop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => QuizMenuScreen(),
                    ),
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
          // Match the Letter Text
          Positioned(
            top: 14,
            left: 74,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Match letters',
                style: TextStyle(
                  fontFamily: 'coco_bold', // Change font family
                  color: Colors.orange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Refresh Button
        ],
      ),
    );
  }
}
