import 'package:smart_kids_v1/ENGLISH_GAMES/Generate_Letter_Groups.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '/text_to_speech.dart'; // Import your text-to-speech class
import '../score_manager.dart'; // Import ScoreManager

class Quiz_02_Eng extends StatefulWidget { // Missing letter Game
  final String sequence;

  Quiz_02_Eng({required this.sequence});

  @override
  _Quiz_02_EngState createState() => _Quiz_02_EngState();
}
class _Quiz_02_EngState extends State<Quiz_02_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
  late String _missingLetter;
  late List<String> _options;
  String _feedbackText = '';
  bool _isDropped = false;
  int _pops = 0; // Track the number of bubbles popped
  int maxPops=3; // Maximum number of bubbles that can be popped before ending the game
  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    _textToSpeech.speak('Quiz No 2, Identify the missing letter');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeGame();
  }

  void _initializeGame() {
    List<String> letters = widget.sequence.split('');

    int missingIndex =
        (letters.length - 1) ~/ 2; // You can randomize this index
    _missingLetter = letters[missingIndex];
    letters[missingIndex] =
        '_'; // Replace the missing letter with an underscore

    // Generate multiple-choice options
    List<String> vowelOptions = ['A', 'E', 'I', 'O', 'U'];
    vowelOptions.remove(_missingLetter);

    // Select four random vowels from the remaining vowels
    vowelOptions.shuffle();
    _options = [_missingLetter, ...vowelOptions.take(4)]..shuffle();

    _isDropped = false;
    _feedbackText = '';
    setState(() {}); // Refresh UI
  }

  void _checkAnswer(String selectedLetter) {
    _pops++;
    if (selectedLetter == _missingLetter) {
      ScoreManager().increaseScore(5); // Update collective score
      _textToSpeech.speak('Great job! That’s the correct letter');
      _feedbackText = 'Correct! Well done!';
      _isDropped = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
      ));
    } else {
      _textToSpeech.speak('Oops! That’s not right');
      _feedbackText = 'Oops! Try again.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect!'),
        backgroundColor: Colors.redAccent,
      ));
    }    
    setState(() {});
      Future.delayed(Duration(seconds: 4), () {
        // Instantiate the GenerateLetterGroups class
        GenerateLetterGroups generateLetterGroups = GenerateLetterGroups(
          isUpperCase: false,
          gameType: 'Quiz', // This is a placeholder; adjust as per your logic
        );
        List<String> letterGroups = generateLetterGroups.generateLetterGroups();
        Random random = Random();
        int randomIndex = random.nextInt(5);
        String selectedLetters = letterGroups[randomIndex];
        // Navigate to the Quiz_01_Eng2 screen with the selectedLetters
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Quiz_02_Eng2(selectedLetters: selectedLetters),
          ),
        );
      });    

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
                image: AssetImage('assets/game_background_4.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                DragTarget<String>(
                  onAccept: (receivedLetter) {
                    _checkAnswer(receivedLetter);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.sequence.split('').map((letter) {
                        return Row(
                          children: [
                            Text(
                              _isDropped || letter != _missingLetter
                                  ? letter
                                  : '_',
                              style: const TextStyle(
                                fontSize: 50,
                                fontFamily: 'coco_bold',
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Add space between letters
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
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
                          color: Colors.green,
                          border: Border.all(color: Colors.green, width: 3.0),
                          borderRadius: BorderRadius.circular(20),
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
                            border: Border.all(color: Colors.green, width: 3.0),
                            borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          Positioned(
            top: 14,
            left: 74,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Missing Letter',
                style: TextStyle(
                  fontFamily: 'coco_bold',
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
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
         
        ],
      ),
    );
  }
}


//_____________________________________________________________________________________
//_____________________________________________________________________________________

class Quiz_02_Eng2 extends StatefulWidget {
  final String selectedLetters;

  Quiz_02_Eng2({required this.selectedLetters});

  @override
  _Quiz_02_Eng2State createState() => _Quiz_02_Eng2State();
}

class _Quiz_02_Eng2State extends State<Quiz_02_Eng2> {
  late Map<String, String> leftItems;
  late Map<String, String> rightItems;
  final text_to_speech _textToSpeech =
      text_to_speech(); // Initialize the text-to-speech instance

  String _feedbackText = ''; // Variable to hold feedback text

  @override
  void initState() {
    super.initState();
    _textToSpeech.speak('Question no 2, Arrange the letters in the correct order');

    // Hide the status bar and force landscape mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeGame();
  }

  @override

  void _initializeGame() {
    List<String> letters = widget.selectedLetters.split('');

    // Initialize leftItems with empty values
    leftItems = {for (var letter in letters) letter: ''};

    // Initialize rightItems with shuffled letters
    rightItems = {for (var letter in letters) letter: letter};
    rightItems = Map.fromEntries(rightItems.entries.toList()..shuffle());
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
      _feedbackText = ''; // Clear feedback text on reset
    });
  }

  void _checkAnswers() {
    bool allInOrder = true;
    List<String> keys = leftItems.keys.toList();

    for (int i = 0; i < keys.length - 1; i++) {
      if (leftItems[keys[i]]!.isNotEmpty &&
          leftItems[keys[i + 1]]!.isNotEmpty) {
        if (leftItems[keys[i]]!.compareTo(leftItems[keys[i + 1]]!) > 0) {
          allInOrder = false;
          break;
        }
      } else {
        allInOrder = false;
        break;
      }
    }

    // Speak the result
    if (allInOrder) {
      ScoreManager().increaseScore(5); // Update collective score
      _textToSpeech.speak('Great job! You arranged them correctly');
      _feedbackText = 'Great job! You arranged them correctly';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.amber,
      ));
    } else {
      _textToSpeech.speak('Oops, Some Letters are misordered');
      _feedbackText = 'Oops, Please try again';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect!'),
        backgroundColor: Colors.redAccent,
      ));
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
      margin:const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.teal, width: 3.0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
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
          
          // Main game area
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                const SizedBox(height: 16), // Add space between rows
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
                                margin:const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.amber, width: 3.0),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: candidateData.isNotEmpty
                                      ? [
                                          BoxShadow(
                                              color: Colors.teal,
                                              blurRadius: 5)
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    leftItems[item]!,
                                    style:const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 30,
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
                SizedBox(height: 16), // Add space between rows
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
                            child: _buildDraggableItem(item,Colors.teal),
                            feedback: Material(
                              color: Colors.white,
                              child: _buildDraggableItem(item, Colors.teal),
                            ),
                            childWhenDragging:
                                _buildDraggableItem(item, Colors.white),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
           Positioned(
            top: 10,
            left: 80,
            child: Container(
              padding:const  EdgeInsets.all(8),
              child: const Text(
                'Arrange Letters',
                style: TextStyle(
                  fontFamily: 'madimiOne', // Change font family
                  color: Colors.teal,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Check Answers Button
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _checkAnswers,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.check_box,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // Back Arrow Button
          Positioned(
            top: 22,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: () {
                  _textToSpeech.stop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>QuizMenuScreen(),
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
        
        ],
      ),
    );
  }
}
