import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '/text_to_speech.dart'; // Import your text-to-speech class

class Quiz_03_Eng extends StatefulWidget { // Sort Letter Train
  @override
  _Quiz_03_EngState createState() => _Quiz_03_EngState();
}

class _Quiz_03_EngState extends State<Quiz_03_Eng> {
  late Map<String, String?> leftItems;
  late Map<String, String> rightItems;
  final text_to_speech _textToSpeech =
      text_to_speech(); // Initialize the text-to-speech instance

  String _feedbackText = ''; // Variable to hold feedback text
  Set<String> _misplacedLetters = {}; // Set to store misplaced letters
  int _score = 0; // Variable to hold the score

  @override
  void initState() {
    super.initState();
    _textToSpeech.speak('Quiz No 3, Arrange the letters in the correct order');

    // Hide the status bar and force landscape mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeGame();
  }
  void _initializeGame() {
    // Generate all letters from A to Z
    List<String> letters =
        List.generate(26, (index) => String.fromCharCode(index + 65)); // A = 65

    // Initialize leftItems with empty values
    leftItems = {for (var letter in letters) letter: null};

    // Initialize rightItems with shuffled letters
    rightItems = {for (var letter in letters) letter: letter};
    rightItems = Map.fromEntries(rightItems.entries.toList()..shuffle());

    _score = 0; // Reset score when initializing the game
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
      _feedbackText = ''; // Clear feedback text on reset
      _misplacedLetters.clear(); // Clear misplaced letters on reset
    });
  }

  void _checkAnswers() {
    bool allInOrder = true;
    bool allBoxesFilled = true;
    _misplacedLetters
        .clear(); // Clear the misplaced letters set before checking
    _score = 0; // Reset score before checking

    List<String> leftItemsList = leftItems.keys.toList();
    for (int i = 0; i < leftItemsList.length; i++) {
      String expectedLetter = leftItemsList[i];
      String? currentItem = leftItems[expectedLetter];

      if (currentItem == null || currentItem.isEmpty) {
        allBoxesFilled = false;
      } else if (currentItem != expectedLetter) {
        allInOrder = false;
        _misplacedLetters
            .add(expectedLetter); // Mark the expected letter as misplaced
      } else {
        _score++; // Increment score for each correctly placed letter
      }
      
    }

    // Speak the result
    if (!allBoxesFilled) {
      _textToSpeech.speak(
          'The pink boxes shows misplaced letters');
      _feedbackText = 'Some empty Boxes Left';
    } else if (allInOrder) {
      _textToSpeech.speak('Great job! You Sorted correctly');
      _feedbackText = 'Great job! You Sorted correctly';
    } else {
      _textToSpeech.speak(
          'The pink boxes show misplaced letters');
      _feedbackText = 'Oops, some letters are misplaced';
    }
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ShowResult(
            scoreObtained: _score, // Get the cumulative score
            totalmarks: 26, // Adjust as needed
          ),
        ),
      );
    });
    setState(
        () {}); // Refresh the UI to show feedback and highlight misplaced letters
       
  }

  Widget _buildDraggableItem(String item, Color color, bool isMisplaced) {
    // Highlight with yellow background if the item is in _misplacedLetters
    Color backgroundColor =
        isMisplaced ? Colors.pinkAccent.withOpacity(0.8) : color;

    return Container(
      margin: const EdgeInsets.all(2), // Reduced margin
      padding: const EdgeInsets.all(4), // Reduced padding
      width: 60, // Reduced width
      height: 60, // Reduced height
      decoration: BoxDecoration(
        color: backgroundColor,
        border:
            Border.all(color: Colors.amber, width: 2.0), // Reduced border width
        borderRadius: BorderRadius.circular(20), // Reduced border radius
      ),
      child: Center(
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 26, // Reduced font size
            color: Colors.teal,
            fontFamily: 'arial',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> leftItemsList = leftItems.keys.toList();
    List<String> rightItemsList = rightItems.keys.toList();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // Feedback text
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _feedbackText,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "madimiOne",
                      fontWeight: FontWeight.bold,
                      color: _feedbackText.contains('Great job')
                          ? Colors.teal
                          : Colors.pinkAccent,
                    ),
                  ),
                ),
                // First row: Empty boxes (left side)
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(13, (index) {
                      String item = leftItemsList[index];
                      bool isMisplaced = _misplacedLetters.contains(item);
                      return Expanded(
                        child: DragTarget<String>(
                          onWillAccept: (data) => leftItems[item] == null,
                          onAccept: (data) {
                            setState(() {
                              leftItems[item] = data!;
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return _buildDraggableItem(leftItems[item] ?? '',
                                Colors.white, isMisplaced);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                // Second row: Empty boxes (right side)
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(13, (index) {
                      String item = leftItemsList[index + 13];
                      bool isMisplaced = _misplacedLetters.contains(item);
                      return Expanded(
                        child: DragTarget<String>(
                          onWillAccept: (data) => leftItems[item] == null,
                          onAccept: (data) {
                            setState(() {
                              leftItems[item] = data!;
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return _buildDraggableItem(leftItems[item] ?? '',
                                Colors.white, isMisplaced);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                // Third row: Lowercase letters (left side)
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(14, (index) {
                      String item = rightItemsList[index];
                      return Expanded(
                        child: Draggable<String>(
                          data: item,
                          child: _buildDraggableItem(item, Colors.amber, false),
                          feedback: Material(
                            color: Colors.white,
                            child:
                                _buildDraggableItem(item, Colors.white, false),
                          ),
                          childWhenDragging:
                              _buildDraggableItem(item, Colors.teal, false),
                        ),
                      );
                    }),
                  ),
                ),
                // Fourth row: Lowercase letters (right side)
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(12, (index) {
                      String item = rightItemsList[index + 14];
                      return Expanded(
                        child: Draggable<String>(
                          data: item,
                          child: _buildDraggableItem(item, Colors.amber, false),
                          feedback: Material(
                            color: Colors.amber,
                            child:
                                _buildDraggableItem(item, Colors.green, false),
                          ),
                          childWhenDragging:
                              _buildDraggableItem(item, Colors.green, false),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // Back Arrow Button
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(1),
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
          // Check Answers Button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(1),
                border:
                    Border.all(color: Colors.black.withOpacity(0.7), width: 0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _checkAnswers,
                child: const Icon(Icons.check_box, color: Colors.white),
              ),
            ),
          ),
          // Reset Button
          Positioned(
            top: 16,
            right: 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(1),
                border:
                    Border.all(color: Colors.black.withOpacity(0.7), width: 0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _resetGame,
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
