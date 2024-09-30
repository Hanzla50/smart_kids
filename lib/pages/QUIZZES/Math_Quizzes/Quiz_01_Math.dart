import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart'; // Import your text-to-speech class
import '../score_manager.dart'; // Import ScoreManager

class Quiz_01_Math extends StatefulWidget {
  @override
  _Quiz_01_MathState createState() => _Quiz_01_MathState();
}

class _Quiz_01_MathState extends State<Quiz_01_Math> {
  List<int> _numbers = [];
  int _targetNumber = 0;
  String _feedbackText = '';
  final text_to_speech _textToSpeech = text_to_speech();
  int _score = 0;
  int _attempts = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    ScoreManager().resetScore();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _textToSpeech.speak("Spot the number that the hen is showing");
    _initializeGame();
  }

  @override
  void dispose() {
    _textToSpeech.stop();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _initializeGame() async {
    if (_attempts >= _maxAttempts) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Quiz_01_Math2()),
      );
      return;
    }

    Random random = Random();
    _numbers = List<int>.generate(12, (_) => random.nextInt(90) + 10);
    _targetNumber = _numbers[random.nextInt(12)];
    _feedbackText = '';
    setState(() {});

    await _textToSpeech.speak("Spot the number $_targetNumber");
  }
Future<void> _checkNumber(int selectedNumber) async {
    setState(() {
      _attempts++; // Increment attempts regardless of correctness
      if (selectedNumber == _targetNumber) {
        _feedbackText = 'Correct!';
        _score++;
        ScoreManager().increaseScore(1); // Update collective score
      } else {
        _feedbackText = 'Wrong';
      }

      if (_attempts < _maxAttempts) {
        Future.delayed(Duration(seconds: 3), _initializeGame);
      } else {
        // Add a delay of 4 seconds before navigating
        Future.delayed(Duration(seconds: 4), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Quiz_01_Math2()),
          );
        });
      }
    });

    await _textToSpeech
        .speak(selectedNumber == _targetNumber ? "Correct" : "Wrong");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Math_Games/hen.png',
              height: 170,
            ),
          ),
          Positioned(
            top: 107,
            left: 0,
            right: 0,
            child: Text(
              '$_targetNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "madimiOne",
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _numbers.take(6).map((number) {
                      return _buildNumberBox(number);
                    }).toList(),
                  ),
                  const SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _numbers.skip(6).take(6).map((number) {
                      return _buildNumberBox(number);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 60,
            child: Center(
              child: Text(
                _feedbackText,
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:
                      _feedbackText == 'Correct!' ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 80,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Spot the Number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.withOpacity(0.6),
                  fontFamily: "madimiOne",
                ),
              ),
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildNumberBox(int number) {
    return GestureDetector(
      onTap: () => _checkNumber(number),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              fontFamily: "madimiOne",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}




//_______________________________________________________________________________
//_______________________________________________________________________________
class Quiz_01_Math2 extends StatefulWidget {
  @override
  _Quiz_01_Math2State createState() => _Quiz_01_Math2State();
}

class _Quiz_01_Math2State extends State<Quiz_01_Math2> {
  final text_to_speech _textToSpeech = text_to_speech();
  static const int totalBubbles = 7;
  static const int maxPops = 3;
  List<String> _numbers = [];
  List<Offset> _positions = [];
  late String _targetNumber;
  bool _gameOver = false;
  String _feedbackText = '';
  int _pops = 0;
  int _attempts = 0; // Track attempts
  final int _maxAttempts = 3; // Total attempts for the game
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), _initializeGame);
    });
  }

  @override
  void dispose() {
    _textToSpeech.stop();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _initializeGame() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    setState(() {
      _isInitialized = true;
    });
    _startNewRound();
  }

  void _startNewRound() {
    setState(() {
      _gameOver = false;
      _feedbackText = '';
      _numbers = _generateRandomNumbers(totalBubbles);
      _positions = _generateFixedPositions();
      _targetNumber = _numbers[Random().nextInt(_numbers.length)];
    });
    _speakTargetNumber();
  }

  List<String> _generateRandomNumbers(int count) {
    return List.generate(count, (_) => _generateRandomNumber());
  }

  List<Offset> _generateFixedPositions() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final double bubbleSize = 80.0;
    final double spacingFirstRow = (screenWidth - (3 * bubbleSize)) / 4;
    final double spacingSecondRow = (screenWidth - (4 * bubbleSize)) / 5;

    return [
      Offset(spacingFirstRow, screenHeight * 0.3),
      Offset(2 * spacingFirstRow + bubbleSize, screenHeight * 0.3),
      Offset(3 * spacingFirstRow + 2 * bubbleSize, screenHeight * 0.3),
      Offset(spacingSecondRow, screenHeight * 0.6),
      Offset(2 * spacingSecondRow + bubbleSize, screenHeight * 0.6),
      Offset(3 * spacingSecondRow + 2 * bubbleSize, screenHeight * 0.6),
      Offset(4 * spacingSecondRow + 3 * bubbleSize, screenHeight * 0.6),
    ];
  }

  String _generateRandomNumber() {
    return Random().nextInt(10).toString();
  }

  Future<void> _speakTargetNumber() async {
    await _textToSpeech.speak('Pop the number $_targetNumber');
  }

  void _checkAnswer(String selectedNumber) {
    if (_gameOver) return;
    _pops++;

    if (selectedNumber == _targetNumber) {
      setState(() {
        _feedbackText = 'Correct';
        ScoreManager().increaseScore(1); // Update collective score
      });
      _textToSpeech.speak('Correct');
    } else {
      setState(() {
        _feedbackText = 'Wrong';
      });
      _textToSpeech.speak('Wrong');
    }

    if (_pops >= maxPops) {
      _endGame();
    } else {
      Future.delayed(Duration(seconds: 2), () {
        if (!_gameOver) {
          _startNewRound();
        }
      });
    }
  }

  void _endGame() {
    setState(() {
      _gameOver = true; // Ensure game over state is set
    });
    // Navigate to the results screen
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ShowResult(
            scoreObtained: ScoreManager().score, // Get the cumulative score
            totalmarks: 6, // Adjust as needed
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _numbers.isEmpty || _positions.isEmpty) {
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
          ..._numbers.asMap().entries.map((entry) {
            int index = entry.key;
            String number = entry.value;

            return Positioned(
              top: _positions[index].dy,
              left: _positions[index].dx,
              child: GestureDetector(
                onTap: () => _checkAnswer(number),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: TextStyle(
                        fontFamily: 'madimiOne',
                        fontSize: 32,
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
          Positioned(
            top: 10,
            left: 80,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Pop Bubbles',
                style: TextStyle(
                  fontFamily: 'madimiOne',
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 24,
            child: Text(
              'Total Score: ${ScoreManager().score}',
              style: TextStyle(
                fontFamily: "madimiOne",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown.withOpacity(0.6),
              ),
            ),
          ),
          if (_gameOver)
            Positioned(
              bottom: 16,
              right: 24,
              child: Text(
                'Total Score: ${ScoreManager().score}',
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.withOpacity(0.6),
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
                color: _feedbackText == 'Correct' ? Colors.brown : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
