import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '/text_to_speech.dart';

class Quiz_05_Eng extends StatefulWidget {  // Missing Pic Letter
  @override
  _Quiz_05_EngState createState() =>
      _Quiz_05_EngState();
}

class _Quiz_05_EngState extends State<Quiz_05_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
  final FlutterTts _flutterTts = FlutterTts();
  late String _missingLetter;
  late String _word;
  late List<String> _options;
  late String _imagePath;
  bool _isDropped = false;
  String _feedbackText = ''; // Variable to hold feedback text
  int _attempts = 0;
  final int _maxAttempts = 3;

  final List<String> _pictures = [
    'assets/Eng_Games_Pics/bear.png',
    'assets/Eng_Games_Pics/cat.png',
    'assets/Eng_Games_Pics/lion.png',
    'assets/Eng_Games_Pics/dog.png',
    'assets/Eng_Games_Pics/owl.png',
    'assets/Eng_Games_Pics/duck.png',
    'assets/Eng_Games_Pics/eagle.png',
    'assets/Eng_Games_Pics/apple.png',
    'assets/Eng_Games_Pics/mango.png',
    'assets/Eng_Games_Pics/corn.png',
    'assets/Eng_Games_Pics/banana.png',
    'assets/Eng_Games_Pics/carrot.png',
    'assets/Eng_Games_Pics/pepper.png',
    'assets/Eng_Games_Pics/potato.png',
    'assets/Eng_Games_Pics/tomato.png',
    'assets/Eng_Games_Pics/orange.png',
  ];
  final Map<String, String> _words = {
    'assets/Eng_Games_Pics/bear.png': 'bear',
    'assets/Eng_Games_Pics/cat.png': 'cat',
    'assets/Eng_Games_Pics/lion.png': 'lion',
    'assets/Eng_Games_Pics/dog.png': 'dog',
    'assets/Eng_Games_Pics/owl.png': 'owl',
    'assets/Eng_Games_Pics/duck.png': 'duck',
    'assets/Eng_Games_Pics/eagle.png': 'eagle',
    'assets/Eng_Games_Pics/apple.png': 'apple',
    'assets/Eng_Games_Pics/mango.png': 'mango',
    'assets/Eng_Games_Pics/corn.png': 'corn',
    'assets/Eng_Games_Pics/banana.png': 'banana',
    'assets/Eng_Games_Pics/carrot.png': 'carrot',
    'assets/Eng_Games_Pics/pepper.png': 'pepper',
    'assets/Eng_Games_Pics/potato.png': 'potato',
    'assets/Eng_Games_Pics/tomato.png': 'tomato',
    'assets/Eng_Games_Pics/orange.png': 'orange',
  };

  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    _initializeGame();
    _textToSpeech.speak('Identify the missing letter');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _initializeGame() {
   
    final random = Random();
    _imagePath = _pictures[random.nextInt(_pictures.length)];
    _word = _words[_imagePath]!;

    _missingLetter = _word[0];
    final missingWord = '_${_word.substring(1)}';

    List<String> letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
    letters.remove(_missingLetter);
    letters.shuffle();

    // Ensure we have only three unique options including the missing letter
    // Take first 2 letters from the shuffled list and add the missing letter
    List<String> selectedLetters = [_missingLetter];
    while (selectedLetters.length < 3) {
      String letter = letters.removeLast();
      if (!selectedLetters.contains(letter)) {
        selectedLetters.add(letter);
      }
    }

    // Shuffle the options
    _options = selectedLetters..shuffle();

    _isDropped = false;
    setState(() {});
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
      _feedbackText = ''; // Clear feedback text on reset
    });
  }

  void _checkAnswer(String selectedLetter) {
    _attempts++; // Increment attempts regardless of correctness
    if (selectedLetter == _missingLetter) {
      _textToSpeech.speak('Great job! That’s the correct letter');
      _feedbackText = 'Great job! That’s the correct letter';
      _isDropped = true;
      ScoreManager().increaseScore(5); // Increment score for correct answer
    } else {
      _textToSpeech.speak('Oops! That’s not right');
      _feedbackText = 'Oops! That’s not right';
    }
    if (_attempts >= _maxAttempts) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Quiz_05_Eng2(),
            ),
        
        );
      });
    }
      else{
      Future.delayed(Duration(seconds: 4), _initializeGame);
      }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final missingWord = _word.replaceFirst(_missingLetter, '_');

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_imagePath, height: 200),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 320),
                    DragTarget<String>(
                      onAccept: (receivedLetter) {
                        _checkAnswer(receivedLetter);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _word.split('').map((letter) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              padding: const EdgeInsets.all(10),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.green, width: 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  _isDropped || letter != _missingLetter
                                      ? letter
                                      : '_',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.green,
                                    fontFamily: 'coco_bold',
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 50,
            child: Text(
              _feedbackText,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'MadimiOne',
                fontWeight: FontWeight.bold,
                color: _feedbackText.contains('Great job')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _options.map((letter) {
                return Draggable<String>(
                  data: letter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'coco_bold',
                        ),
                      ),
                    ),
                  ),
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.green,
                            fontFamily: 'coco_bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border: Border.all(color: Colors.green, width: 3.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
                  _textToSpeech.stop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => QuizMenuScreen(),
                    ),
                  );
                  
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
          // Reset Button
          
        ],
      ),
    );
  }
}

//________________________________________________________________________________________
//________________________________________________________________________________________


class Quiz_05_Eng2 extends StatefulWidget {  // Form WOrd From picture
  @override
  _Quiz_05_Eng2State createState() =>
      _Quiz_05_Eng2State();
}

class _Quiz_05_Eng2State extends State<Quiz_05_Eng2> {
  final text_to_speech _textToSpeech = text_to_speech();
  final FlutterTts _flutterTts = FlutterTts();
  late String _word;
  late List<String> _shuffledLetters;
  late List<String> _arrangedLetters;
  late String _imagePath;
  String _feedbackText = ''; // Variable to hold feedback text

  final List<String> _pictures = [
    'assets/Eng_Games_Pics/bear.png',
    'assets/Eng_Games_Pics/cat.png',
    'assets/Eng_Games_Pics/lion.png',
    'assets/Eng_Games_Pics/dog.png',
    'assets/Eng_Games_Pics/owl.png',
    'assets/Eng_Games_Pics/duck.png',
    'assets/Eng_Games_Pics/eagle.png',
    'assets/Eng_Games_Pics/apple.png',
    'assets/Eng_Games_Pics/mango.png',
    'assets/Eng_Games_Pics/corn.png',
    'assets/Eng_Games_Pics/banana.png',
    'assets/Eng_Games_Pics/carrot.png',
    'assets/Eng_Games_Pics/pepper.png',
    'assets/Eng_Games_Pics/potato.png',
    'assets/Eng_Games_Pics/tomato.png',
    'assets/Eng_Games_Pics/orange.png',
  ];

  final Map<String, String> _words = {
    'assets/Eng_Games_Pics/bear.png': 'bear',
    'assets/Eng_Games_Pics/cat.png': 'cat',
    'assets/Eng_Games_Pics/lion.png': 'lion',
    'assets/Eng_Games_Pics/dog.png': 'dog',
    'assets/Eng_Games_Pics/owl.png': 'owl',
    'assets/Eng_Games_Pics/duck.png': 'duck',
    'assets/Eng_Games_Pics/eagle.png': 'eagle',
    'assets/Eng_Games_Pics/apple.png': 'apple',
    'assets/Eng_Games_Pics/mango.png': 'mango',
    'assets/Eng_Games_Pics/corn.png': 'corn',
    'assets/Eng_Games_Pics/banana.png': 'banana',
    'assets/Eng_Games_Pics/carrot.png': 'carrot',
    'assets/Eng_Games_Pics/pepper.png': 'pepper',
    'assets/Eng_Games_Pics/potato.png': 'potato',
    'assets/Eng_Games_Pics/tomato.png': 'tomato',
    'assets/Eng_Games_Pics/orange.png': 'orange',
  };

  @override
  void initState() {
    super.initState();
    _initializeGame();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  void _initializeGame() {
    _textToSpeech.speak('Arrange the letters to form the correct word');
    final random = Random();
    _imagePath = _pictures[random.nextInt(_pictures.length)];
    _word = _words[_imagePath]!;

    _resetGame();
  }

  void _resetGame() {
    _shuffledLetters = _word.split('')..shuffle();
    _arrangedLetters = List<String>.filled(_word.length, '');
    _feedbackText = '';
    setState(() {});
  }

  void _checkAnswer() {
    String arrangedWord = _arrangedLetters.join('');
    if (arrangedWord == _word) {
      _textToSpeech.speak('Great job! You formed the correct word');
      _feedbackText = 'Great job! Correct Word';
      ScoreManager().increaseScore(5); // Increment score for correct answer
    } else {
      _textToSpeech.speak('Oops! That’s not right');
      _feedbackText = 'Oops! That’s not right';
    }

     Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowResult(
            scoreObtained: ScoreManager().score,
            totalmarks: 20,
          ),
        ),
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 10,
            right: 100,
            child:Text(
            _feedbackText,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'MadimiOne',
              fontWeight: FontWeight.bold,
              color: _feedbackText.contains('Great job')
                  ? Colors.teal
                  : Colors.redAccent,
            ),
          ),
          ),
          SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_imagePath, height: 200),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _arrangedLetters.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String letter = entry.value;

                    return DragTarget<String>(
                      onAccept: (receivedLetter) {
                        setState(() {
                          _arrangedLetters[idx] = receivedLetter;
                        });
                        if (!_arrangedLetters.contains('')) {
                          _checkAnswer();
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(10),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.amber, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              letter.isEmpty ? '_' : letter,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.amber,
                                fontFamily: 'coco_bold',
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _shuffledLetters.map((letter) {
                    return Draggable<String>(
                      data: letter,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'coco_bold',
                            ),
                          ),
                        ),
                      ),
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.amber,
                                fontFamily: 'coco_bold',
                              ),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          border: Border.all(color: Colors.amber, width: 3.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 0),
                
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _textToSpeech.stop();
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
           Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: _resetGame,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(4),
                  minimumSize: Size(24, 24),
                ),
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: _initializeGame,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(4),
                  minimumSize: Size(24, 24),
                ),
                child: Icon(
                  Icons.navigate_next_outlined,
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
