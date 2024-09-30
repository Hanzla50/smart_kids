import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import '/text_to_speech.dart';
import 'dart:math'; // Import for Random

class Quiz_02_Math extends StatefulWidget {
  // Sort Number Game
  String selectedNumbers; // Expecting 10 numbers as a string

  Quiz_02_Math({required this.selectedNumbers});

  @override
  _Quiz_02_MathState createState() => _Quiz_02_MathState();
}

class _Quiz_02_MathState extends State<Quiz_02_Math> {
  late Map<String, String> leftItems;
  late Map<String, String> rightItems;
  final text_to_speech _textToSpeech =
      text_to_speech(); // Initialize the text-to-speech instance
  String _feedbackText = ''; // Variable to hold feedback text
  int _score = 0; // Variable to track the score
  int _gamesPlayed = 1; // Counter for games played

  @override
  void initState() {
    super.initState();
    _textToSpeech.speak('Arrange the numbers in the correct order');

    // Hide the status bar and force landscape mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeGame();
  }

  @override
  void dispose() {
    // Restore the status bar and reset orientation when the widget is disposed
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
    List<String> numbersRange = widget.selectedNumbers.split('-');
    int start = int.parse(numbersRange[0]);
    int end = int.parse(numbersRange[1]);

    if (start > end) {
      print('Invalid range: start is greater than end.');
      return;
    }

    // Create a list of numbers as strings from start to end (inclusive)
    List<String> numbers =
        List.generate(end - start + 1, (index) => (start + index).toString());

    print('Generated numbers: $numbers'); // Debugging print

    // Remove the last number from the list
    if (numbers.isNotEmpty) {
      print('Removing last number: ${numbers.last}');
      numbers.removeLast();
    }
    if (numbers.last == '9') {
      numbers.add('10');
    }
    // Remove duplicates and sort numbers
    numbers = numbers.toSet().toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    print('Numbers after sorting and removal: $numbers'); // Debugging print

    // Initialize leftItems with empty values for target drop zones
    leftItems = {for (var number in numbers) number: ''};

    // Initialize rightItems with shuffled numbers for draggable items
    rightItems = {for (var number in numbers) number: number};
    rightItems = Map.fromEntries(rightItems.entries.toList()..shuffle());

    setState(() {}); // Refresh the UI to show changes
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
      _feedbackText = ''; // Clear feedback text on reset
    });
  }

  void _checkAnswers() {
    _gamesPlayed++; // Increment games played counter
    bool allInOrder = true;
    List<String> keys = leftItems.keys.toList();

    // Check if numbers are in ascending order
    for (int i = 0; i < keys.length - 1; i++) {
      if (leftItems[keys[i]]!.isNotEmpty &&
          leftItems[keys[i + 1]]!.isNotEmpty) {
        if (int.parse(leftItems[keys[i]]!) >
            int.parse(leftItems[keys[i + 1]]!)) {
          allInOrder = false;
          break;
        }
      } else {
        allInOrder = false;
        break;
      }
    }

    // Speak the result and set feedback text
    if (allInOrder) {
      _textToSpeech.speak('Great job! You arranged them correctly');
      _feedbackText = 'Great job! You arranged them correctly';
      _score += 5; // Increase score by 5 for a correct answer

      
    } else {
      _textToSpeech.speak('Oops, Please try again');
      _feedbackText = 'Oops, Please try again';
    }
    // Navigate to ShowResult after 2 games
    if (_gamesPlayed >= 3) {
      _gamesPlayed=2;
      Future.delayed(Duration(seconds: 4), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowResult(
              scoreObtained: _score, totalmarks: 10, // Adjust as needed
            ),
          ),
        );
      });
    }

    // Reset the game after a short delay
    Future.delayed(Duration(seconds: 4), () {
      if (_gamesPlayed < 2) {
        _newGame(); // Reset the game if less than 2 games played
      }
    });

    setState(() {}); // Refresh the UI to show feedback text
  }

  void _newGame() {
    setState(() {
      // Define available ranges
      final List<String> numberRanges = [
        "21-30",
        "31-40",
        "51-60",
        // Add more ranges as needed
      ];

      // Select a random range from the predefined list
      final random = Random();
      widget.selectedNumbers =
          numberRanges[random.nextInt(numberRanges.length)];

      _initializeGame(); // Initialize the game with the new range
      _feedbackText = ''; // Clear feedback text on reset
    });
  }

  Widget _buildDraggableItem(String item, Color color) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(10),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        border: Border.all(color: Colors.greenAccent, width: 3.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          item, // Ensure that `item` is a string representation of the number
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'madimiOne',
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
                // Feedback text
                Positioned(
                  top: 10,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      _feedbackText,
                      style: TextStyle(
                        fontFamily: "madimiOne",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _feedbackText.contains('Great job')
                            ? Colors.greenAccent
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Add space between rows
                // Score display
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Question: $_gamesPlayed/2', // Display current score
                    style: TextStyle(
                      fontFamily: 'madimiOne',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Second row: Empty boxes (Target drop zones)
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
                                margin: const EdgeInsets.all(3),
                                padding: const EdgeInsets.all(10),
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.greenAccent, width: 3.0),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: candidateData.isNotEmpty
                                      ? [
                                          BoxShadow(
                                              color: Colors.greenAccent,
                                              blurRadius: 5)
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    leftItems[item]!.isEmpty
                                        ? ''
                                        : leftItems[item]!, // Display correctly
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 30,
                                      fontFamily: 'madimiOne',
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
                // Third row: Draggable numbers (Shuffled numbers)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: rightItems.keys.map((item) {
                          return Draggable<String>(
                            data: item,
                            child:
                                _buildDraggableItem(item, Colors.greenAccent),
                            feedback: Material(
                              color: Colors.white,
                              child:
                                  _buildDraggableItem(item, Colors.greenAccent),
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
          // Arrange Numbers Title
          Positioned(
            top: 14,
            left: 80,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Arrange Numbers',
                style: TextStyle(
                  fontFamily: 'madimiOne', // Change font family
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 24,
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
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _checkAnswers, // Check answers action
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
          // Refresh Button
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _resetGame, // Refresh game action
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
}
