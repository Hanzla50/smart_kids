import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart';
import 'dart:math'; // Import for random selection

class Quiz_06_Eng extends StatefulWidget {
  @override
  _Quiz_06_EngState createState() =>
      _Quiz_06_EngState();
}

class _Quiz_06_EngState extends State<Quiz_06_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
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
    'assets/Eng_Games_Pics/bear.png': 'B for',
    'assets/Eng_Games_Pics/cat.png': 'C for',
    'assets/Eng_Games_Pics/lion.png': 'L for',
    'assets/Eng_Games_Pics/dog.png': 'D for',
    'assets/Eng_Games_Pics/owl.png': 'O for',
    'assets/Eng_Games_Pics/duck.png': 'D for',
    'assets/Eng_Games_Pics/eagle.png': 'E for',
    'assets/Eng_Games_Pics/apple.png': 'A for',
    'assets/Eng_Games_Pics/mango.png': 'M for',
    'assets/Eng_Games_Pics/corn.png': 'C for',
    'assets/Eng_Games_Pics/banana.png': 'B for',
    'assets/Eng_Games_Pics/carrot.png': 'C for',
    'assets/Eng_Games_Pics/pepper.png': 'P for',
    'assets/Eng_Games_Pics/potato.png': 'P for',
    'assets/Eng_Games_Pics/tomato.png': 'T for',
    'assets/Eng_Games_Pics/orange.png': 'O for',
  };

  late List<String> _shuffledWords;
  late List<String> _selectedPictures;
  Map<String, String?> _matchedPairs = {};
  String _feedbackText = ''; // Variable to hold feedback text

  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    _initializeGame(resetPictures: true);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  void _initializeGame({bool resetPictures = false}) {
    _textToSpeech.speak('Match the letter with the correct picture');
    setState(() {
      if (resetPictures) {
        // Reset the selected pictures and shuffled words
        _selectedPictures = _getRandomPictures();
        _shuffledWords = _selectedPictures.map((pic) => _words[pic]!).toList();
        _shuffledWords.shuffle();
      }
      _matchedPairs.clear(); // Clear the matched pairs
      _feedbackText = ''; // Clear feedback text
    });
  }

  List<String> _getRandomPictures() {
    final random = Random();
    List<String> selected = [];

    while (selected.length < 3) {
      String pic = _pictures[random.nextInt(_pictures.length)];
      if (!selected.contains(pic)) {
        selected.add(pic);
      }
    }
    return selected;
  }

  bool _areAllBoxesFilled() {
    return _selectedPictures
        .every((imagePath) => _matchedPairs.containsKey(imagePath));
  }

  void _checkAnswer() {
    if (!_areAllBoxesFilled()) {
      setState(() {});
      return;
    }

    bool isCorrect = true;
   
    for (String imagePath in _selectedPictures) {
      if (_words[imagePath] != _matchedPairs[imagePath]) {
        isCorrect = false;
        break;
      }
   
    }
    setState(() {
      _feedbackText = isCorrect
          ? 'Great job! All matches are correct' 
          : 'Oops! Some matches are incorrect';
      _textToSpeech.speak(_feedbackText);
    });
    if(isCorrect){
      ScoreManager().increaseScore(5); // Increment score for correct answer
    }
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Quiz_06_Eng2(),
        ),
      );
    });
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 10,
            right: 100,
            child: Text(
              _feedbackText,
              style: TextStyle(
                fontFamily: "madimiOne",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _feedbackText.contains('Great job')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
          Row(
            children: [
              // Left side: Draggable words
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _shuffledWords.map((word) {
                    return Draggable<String>(
                      data: word,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _buildWordContainer(word, Colors.black),
                      ),
                      childWhenDragging: _buildWordContainer(word, Colors.grey),
                      child: _buildWordContainer(word, Colors.orangeAccent),
                    );
                  }).toList(),
                ),
              ),
              // Right side: DragTarget boxes
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _selectedPictures.map((imagePath) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // DragTarget box with rounded border
                        DragTarget<String>(
                          onAccept: (receivedWord) {
                            setState(() {
                              _matchedPairs[imagePath] = receivedWord;
                              _checkAnswer();
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _matchedPairs[imagePath] != null
                                    ? Color.fromRGBO(1, 212, 119, 1)
                                    : Color.fromRGBO(1, 212, 119, 1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _matchedPairs[imagePath] ?? '',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "MadimiOne",
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10),
                        // Image display
                        Image.asset(
                          imagePath,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(1, 212, 119, 1),
                shape: BoxShape.circle,
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
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(1, 212, 119, 1),
                shape: BoxShape.circle,
              ),
              child: TextButton(
                onPressed: () => _initializeGame(resetPictures: false),
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
        ],
      ),
    );
  }

  Widget _buildWordContainer(String word, Color color) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Text(
        word,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "MadimiOne",
        ),
      ),
    );
  }
}


//_________________________________________________________________________
//_________________________________________________________________________

class Quiz_06_Eng2 extends StatefulWidget {
  @override
  _Quiz_06_Eng2State createState() =>
      _Quiz_06_Eng2State();
}

class _Quiz_06_Eng2State extends State<Quiz_06_Eng2> {
  final text_to_speech _textToSpeech = text_to_speech();
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

  late List<String> _shuffledWords;
  late List<String> _selectedPictures;
  Map<String, String?> _matchedPairs = {};
  String _feedbackText = ''; // Variable to hold feedback text

  @override
  void initState() {
    super.initState();
    _initializeGame(resetPictures: true);
    _textToSpeech.speak('Match the words with the correct picture');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    _textToSpeech.stop();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    super.dispose();
  }

  void _initializeGame({bool resetPictures = false}) {
    setState(() {
      if (resetPictures) {
        // Reset the selected pictures and shuffled words
        _selectedPictures = _getRandomPictures();
        _shuffledWords = _selectedPictures.map((pic) => _words[pic]!).toList();
        _shuffledWords.shuffle();
      }
      _matchedPairs.clear(); // Clear the matched pairs
      _feedbackText = ''; // Clear feedback text
    });
  }

  List<String> _getRandomPictures() {
    final random = Random();
    List<String> selected = [];

    while (selected.length < 3) {
      String pic = _pictures[random.nextInt(_pictures.length)];
      if (!selected.contains(pic)) {
        selected.add(pic);
      }
    }
    return selected;
  }

  bool _areAllBoxesFilled() {
    return _selectedPictures
        .every((imagePath) => _matchedPairs.containsKey(imagePath));
  }

  void _checkAnswer() {
    if (!_areAllBoxesFilled()) {
      setState(() {});
      return;
    }

    bool isCorrect = true;
    for (String imagePath in _selectedPictures) {
      if (_words[imagePath] != _matchedPairs[imagePath]) {
        isCorrect = false;
        break;
      }
      
    }
    setState(() {
      _feedbackText = isCorrect
          ? 'Great job! All matches are correct'
          : 'Oops! Some matches are incorrect';
      _textToSpeech.speak(_feedbackText);
    });
     if (isCorrect) {
      ScoreManager().increaseScore(5); // Increment score for correct answer
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 10,
            right: 100,
            child: Text(
              _feedbackText,
              style: TextStyle(
                fontFamily: "madimiOne",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _feedbackText.contains('Great job')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
          Row(
            children: [
              // Left side: Draggable words
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _shuffledWords.map((word) {
                    return Draggable<String>(
                      data: word,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _buildWordContainer(word, Colors.black),
                      ),
                      childWhenDragging: _buildWordContainer(word, Colors.grey),
                      child: _buildWordContainer(word, Colors.orangeAccent),
                    );
                  }).toList(),
                ),
              ),
              // Right side: DragTarget boxes
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _selectedPictures.map((imagePath) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // DragTarget box with rounded border
                        DragTarget<String>(
                          onAccept: (receivedWord) {
                            setState(() {
                              _matchedPairs[imagePath] = receivedWord;
                              _checkAnswer();
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _matchedPairs[imagePath] != null
                                    ? Colors.teal
                                    : Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.teal,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _matchedPairs[imagePath] ?? '',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "MadimiOne",
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10),
                        // Image display
                        Image.asset(
                          imagePath,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: TextButton(
                onPressed: () {
                  _textToSpeech.stop();
                  Navigator.of(context).pop();
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
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: TextButton(
                onPressed: () => _initializeGame(resetPictures: false),
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
        ],
      ),
    );
  }

  Widget _buildWordContainer(String word, Color color) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.amber,
          width: 2,
        ),
      ),
      child: Text(
        word,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
          fontFamily: "MadimiOne",
        ),
      ),
    );
  }
}
