import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '/text_to_speech.dart';

class Quiz_07_Eng extends StatefulWidget { // Opposite Words
  const Quiz_07_Eng({super.key});

  @override
  _Quiz_07_EngState createState() =>
      _Quiz_07_EngState();
}

class _Quiz_07_EngState extends State<Quiz_07_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
  final Random _random = Random();

  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    // Lock orientation to landscape
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // Initialize the game with random pairs
    _initializeGame();
  }


  List<int?> leftMatches = List.filled(4, null);
  List<int?> rightMatches = List.filled(4, null);
  List<Offset> leftDotPositions = List.filled(4, Offset.zero);
  List<Offset> rightDotPositions = List.filled(4, Offset.zero);
  bool isChecked = false; // Track when the check button is pressed

  // Predefined word sets
  final List<Map<String, dynamic>> wordSets = [
    {
      'leftWords': ['Hot', 'Day', 'Big', 'Good'],
      'rightWords': ['bad', 'Small', 'Night', 'cold'],
      'correctMatches': [3, 2, 1, 0], // Maps left to right
    },
    {
      'leftWords': ['Fast', 'High', 'Happy', 'Full'],
      'rightWords': ['Low', 'Slow', 'Empty', 'Sad'],
      'correctMatches': [1, 0, 3, 2],
    },
    {
      'leftWords': ['Heavy', 'Strong', 'Clean', 'Soft'],
      'rightWords': ['Hard', 'Weak', 'Light', 'Dirty'],
      'correctMatches': [2, 1, 3, 0],
    },
    {
      'leftWords': ['Tall', 'Young', 'Hot', 'Heavy'],
      'rightWords': ['Cold', 'Light', 'Short', 'Old'],
      'correctMatches': [2, 3, 0, 1],
    },
    {
      'leftWords': ['Happy', 'Wet', 'Beautiful', 'Rich'],
      'rightWords': ['ugly', 'Poor', 'Sad', 'Dry'],
      'correctMatches': [2, 3, 0, 1],
    },
    {
      'leftWords': ['Sweet', 'Bright', 'Open', 'Early'],
      'rightWords': ['Late', 'Close', 'Dark', 'Bitter'],
      'correctMatches': [3, 2, 1, 0],
    }
  ];

  List<String> leftWords = [];
  List<String> rightWords = [];
  List<int> correctMatches = [];

  Offset? startOffset;
  Offset? endOffset;
  int? selectedLeftDotIndex;
  int? selectedRightDotIndex;
  bool isDraggingFromLeft = true;

  void resetGame() {
    setState(() {
      leftMatches = List.filled(4, null);
      rightMatches = List.filled(4, null);
      startOffset = null;
      endOffset = null;
      isChecked = false; // Reset the check flag when game is reset
    });
  }

  void _initializeGame() {
    _textToSpeech.speak('Quiz no 7, Draw the line to Match the Opposite words');

    // Pick a random word set
    Map<String, dynamic> selectedSet =
        wordSets[_random.nextInt(wordSets.length)];

    setState(() {
      leftWords = List<String>.from(selectedSet['leftWords']);
      rightWords = List<String>.from(selectedSet['rightWords']);
      correctMatches = List<int>.from(selectedSet['correctMatches']);
    });

    resetGame();
  }

  void _resetBoxes() {
    resetGame();
  }

  void _checkAnswers() {
    // Set the flag to true when the check button is pressed
    setState(() {
      isChecked = true;

      // Check if all matches are correct
      bool allCorrect = true;
      for (int i = 0; i < leftMatches.length; i++) {
        if (leftMatches[i] != correctMatches[i]) {
          allCorrect = false;
          break;
        }
      }

      // Provide feedback via text-to-speech
      if (allCorrect) {
        _textToSpeech.speak('Great Job, All the matches are correct');
        ScoreManager().increaseScore(5); // Increment score for correct answer
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('All Correct!'),
          backgroundColor: Colors.cyan,
        ));
      } else {
        _textToSpeech.speak(
            'oops, the red line matches are incorrect');
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Some Matches Incorrect!'),
          backgroundColor: Colors.redAccent,
        ));
      }
    });
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Quiz_07_Eng2(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // White background color
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;

            return Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(leftWords.length, (index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.cyan, // Background color
                                  borderRadius: BorderRadius.circular(
                                      25), // Rounded corners
                                  border: Border.all(
                                    color: Colors.cyan,
                                    width: 2,
                                  ), // Border around the word
                                ),
                                child: Text(
                                  leftWords[index],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "madimiOne",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset position =
                                        box.localToGlobal(Offset.zero);
                                    setState(() {
                                      leftDotPositions[index] =
                                          position + const Offset(10, 10);
                                    });
                                  });
                                  return GestureDetector(
                                    onPanStart: (details) {
                                      setState(() {
                                        selectedLeftDotIndex = index;
                                        startOffset = leftDotPositions[index];
                                        endOffset = details.globalPosition;
                                        isDraggingFromLeft = true;
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      setState(() {
                                        endOffset = details.globalPosition;
                                      });
                                    },
                                    onPanEnd: (details) {
                                      setState(() {
                                        bool connected = false;
                                        for (int i = 0;
                                            i < rightDotPositions.length;
                                            i++) {
                                          if ((rightDotPositions[i] -
                                                      endOffset!)
                                                  .distance <
                                              40) {
                                            if (leftMatches[
                                                    selectedLeftDotIndex!] !=
                                                null) {
                                              rightMatches[leftMatches[
                                                      selectedLeftDotIndex!]!] =
                                                  null;
                                            }
                                            if (rightMatches[i] != null) {
                                              leftMatches[rightMatches[i]!] =
                                                  null;
                                            }
                                            leftMatches[selectedLeftDotIndex!] =
                                                i;
                                            rightMatches[i] =
                                                selectedLeftDotIndex;
                                            connected = true;
                                            break;
                                          }
                                        }
                                        startOffset = null;
                                        endOffset = null;
                                        selectedLeftDotIndex = null;
                                      });
                                    },
                                    child: const Dot(),
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(rightWords.length, (index) {
                          return Row(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset position =
                                        box.localToGlobal(Offset.zero);
                                    setState(() {
                                      rightDotPositions[index] =
                                          position + const Offset(10, 10);
                                    });
                                  });
                                  return GestureDetector(
                                    onPanStart: (details) {
                                      setState(() {
                                        selectedRightDotIndex = index;
                                        startOffset = rightDotPositions[index];
                                        endOffset = details.globalPosition;
                                        isDraggingFromLeft = false;
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      setState(() {
                                        endOffset = details.globalPosition;
                                      });
                                    },
                                    onPanEnd: (details) {
                                      setState(() {
                                        bool connected = false;
                                        for (int i = 0;
                                            i < leftDotPositions.length;
                                            i++) {
                                          if ((leftDotPositions[i] - endOffset!)
                                                  .distance <
                                              40) {
                                            if (rightMatches[
                                                    selectedRightDotIndex!] !=
                                                null) {
                                              leftMatches[rightMatches[
                                                      selectedRightDotIndex!]!] =
                                                  null;
                                            }
                                            if (leftMatches[i] != null) {
                                              rightMatches[leftMatches[i]!] =
                                                  null;
                                            }
                                            rightMatches[
                                                selectedRightDotIndex!] = i;
                                            leftMatches[i] =
                                                selectedRightDotIndex;
                                            connected = true;
                                            break;
                                          }
                                        }
                                        startOffset = null;
                                        endOffset = null;
                                        selectedRightDotIndex = null;
                                      });
                                    },
                                    child: const Dot(),
                                  );
                                },
                              ),
                              const SizedBox(width: 40),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  rightWords[index],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "madimiOne",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                ...leftMatches.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rightIndex = entry.value;
                  if (rightIndex != null) {
                    return CustomPaint(
                      painter: LinePainter(
                        start: leftDotPositions[index],
                        end: rightDotPositions[rightIndex],
                        // Only check correctness when the user presses the check button
                        color:
                            (isChecked && rightIndex == correctMatches[index])
                                ? Colors.amber
                                : (isChecked ? Colors.redAccent : Colors.amber),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                if (startOffset != null && endOffset != null)
                  CustomPaint(
                    painter: LinePainter(
                      start: startOffset!,
                      end: endOffset!,
                      color: Colors.amber,
                    ),
                  ),
                
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: _resetBoxes, // Refresh button action
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
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _textToSpeech.stop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => QuizMenuScreen(),
                          ),
                        );                               },
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
                // Check button at the bottom left
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: _checkAnswers, // Check button action
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
              ],
            );
          },
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  LinePainter({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}


//___________________________________________________________________________________

class Quiz_07_Eng2 extends StatefulWidget {
  const Quiz_07_Eng2({super.key});
  @override
  _Quiz_07_Eng2State createState() =>
      _Quiz_07_Eng2State();
}

class _Quiz_07_Eng2State extends State<Quiz_07_Eng2> {
  final text_to_speech _textToSpeech = text_to_speech();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Lock orientation to landscape
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // Initialize the game with random pairs
    _initializeGame();
  }

  @override
  void dispose() {
    // Unlock orientation when exiting the game screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  List<int?> leftMatches = List.filled(4, null);
  List<int?> rightMatches = List.filled(4, null);
  List<Offset> leftDotPositions = List.filled(4, Offset.zero);
  List<Offset> rightDotPositions = List.filled(4, Offset.zero);
  bool isChecked = false; // Track when the check button is pressed

  // Predefined word sets
  final List<Map<String, dynamic>> wordSets = [
  {
    'leftWords': ['Cat', 'Fish', 'Mouse', 'Car'],
    'rightWords': ['Jar', 'House', 'Dish', 'Mat'],
    'correctMatches': [3, 2, 1, 0],
  },
  {
    'leftWords': ['Star', 'Fox', 'Tree', 'Moon'],
    'rightWords': ['Box', 'Spoon', 'Jar', 'Bee'],
    'correctMatches': [2, 0, 3, 1],
  },
  {
    'leftWords': ['Moon', 'Fan', 'Ball', 'Chair'],
    'rightWords': ['Bear', 'wall', 'Can', 'Spoon'],
    'correctMatches': [3, 2, 1, 0],
  },
  {
    'leftWords': ['Sun', 'Fish', 'Cake', 'Top'],
    'rightWords': ['Bake', 'Hop', 'Run', 'Dish'],
    'correctMatches': [2, 3, 0, 1],
  },
  {
    'leftWords': ['Light', 'Boat', 'Pin', 'Frog'],
    'rightWords': ['Fin', 'Dog', 'Bright', 'Coat'],
    'correctMatches': [2, 3, 0, 1],
  },
  {
    'leftWords': ['Plane', 'Red', 'Duck', 'Rock'],
    'rightWords': ['Truck', 'Sock', 'Train', 'Bed'],
    'correctMatches': [2, 3, 0, 1],
  }
];

  List<String> leftWords = [];
  List<String> rightWords = [];
  List<int> correctMatches = [];

  Offset? startOffset;
  Offset? endOffset;
  int? selectedLeftDotIndex;
  int? selectedRightDotIndex;
  bool isDraggingFromLeft = true;

  void resetGame() {
    setState(() {
      leftMatches = List.filled(4, null);
      rightMatches = List.filled(4, null);
      startOffset = null;
      endOffset = null;
      isChecked = false; // Reset the check flag when game is reset
    });
  }

  void _initializeGame() {
    _textToSpeech.speak('Draw the line to Match the Rhyming words');

    // Pick a random word set
    Map<String, dynamic> selectedSet =
        wordSets[_random.nextInt(wordSets.length)];

    setState(() {
      leftWords = List<String>.from(selectedSet['leftWords']);
      rightWords = List<String>.from(selectedSet['rightWords']);
      correctMatches = List<int>.from(selectedSet['correctMatches']);
    });

    resetGame();
  }

  void _resetBoxes() {
    resetGame();
  }

  void _checkAnswers() {
    // Set the flag to true when the check button is pressed
    setState(() {
      isChecked = true;

      // Check if all matches are correct
      bool allCorrect = true;
      for (int i = 0; i < leftMatches.length; i++) {
        if (leftMatches[i] != correctMatches[i]) {
          allCorrect = false;
          break;
        }
      }
      // Provide feedback via text-to-speech
      if (allCorrect) {
        _textToSpeech.speak('Great Job, All the matches are correct');
        ScoreManager().increaseScore(5); // Increment score for correct answer
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Correct!'),
          backgroundColor: Colors.lightGreenAccent,
        ));
      } else {
        _textToSpeech.speak(
            'oops, the red line matches are incorrect');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Some Matches Incorrect!'),
          backgroundColor: Colors.redAccent,
        ));
            
      }
    });
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
      body: Container(
        color: Colors.white, // White background color
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;

            return Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(leftWords.length, (index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent, // Background color
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Rounded corners
                                  border: Border.all(
                                    color: Colors.orangeAccent,
                                    width: 2,
                                  ), // Border around the word
                                ),
                                child: Text(
                                  leftWords[index],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "madimiOne",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset position =
                                        box.localToGlobal(Offset.zero);
                                    setState(() {
                                      leftDotPositions[index] =
                                          position + const Offset(10, 10);
                                    });
                                  });
                                  return GestureDetector(
                                    onPanStart: (details) {
                                      setState(() {
                                        selectedLeftDotIndex = index;
                                        startOffset = leftDotPositions[index];
                                        endOffset = details.globalPosition;
                                        isDraggingFromLeft = true;
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      setState(() {
                                        endOffset = details.globalPosition;
                                      });
                                    },
                                    onPanEnd: (details) {
                                      setState(() {
                                        bool connected = false;
                                        for (int i = 0;
                                            i < rightDotPositions.length;
                                            i++) {
                                          if ((rightDotPositions[i] -
                                                      endOffset!)
                                                  .distance <
                                              40) {
                                            if (leftMatches[
                                                    selectedLeftDotIndex!] !=
                                                null) {
                                              rightMatches[leftMatches[
                                                      selectedLeftDotIndex!]!] =
                                                  null;
                                            }
                                            if (rightMatches[i] != null) {
                                              leftMatches[rightMatches[i]!] =
                                                  null;
                                            }
                                            leftMatches[selectedLeftDotIndex!] =
                                                i;
                                            rightMatches[i] =
                                                selectedLeftDotIndex;
                                            connected = true;
                                            break;
                                          }
                                        }
                                        startOffset = null;
                                        endOffset = null;
                                        selectedLeftDotIndex = null;
                                      });
                                    },
                                    child: const Dot(),
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(rightWords.length, (index) {
                          return Row(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset position =
                                        box.localToGlobal(Offset.zero);
                                    setState(() {
                                      rightDotPositions[index] =
                                          position + const Offset(10, 10);
                                    });
                                  });
                                  return GestureDetector(
                                    onPanStart: (details) {
                                      setState(() {
                                        selectedRightDotIndex = index;
                                        startOffset = rightDotPositions[index];
                                        endOffset = details.globalPosition;
                                        isDraggingFromLeft = false;
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      setState(() {
                                        endOffset = details.globalPosition;
                                      });
                                    },
                                    onPanEnd: (details) {
                                      setState(() {
                                        bool connected = false;
                                        for (int i = 0;
                                            i < leftDotPositions.length;
                                            i++) {
                                          if ((leftDotPositions[i] - endOffset!)
                                                  .distance <
                                              40) {
                                            if (rightMatches[
                                                    selectedRightDotIndex!] !=
                                                null) {
                                              leftMatches[rightMatches[
                                                      selectedRightDotIndex!]!] =
                                                  null;
                                            }
                                            if (leftMatches[i] != null) {
                                              rightMatches[leftMatches[i]!] =
                                                  null;
                                            }
                                            rightMatches[
                                                selectedRightDotIndex!] = i;
                                            leftMatches[i] =
                                                selectedRightDotIndex;
                                            connected = true;
                                            break;
                                          }
                                        }
                                        startOffset = null;
                                        endOffset = null;
                                        selectedRightDotIndex = null;
                                      });
                                    },
                                    child: const Dot(),
                                  );
                                },
                              ),
                              const SizedBox(width: 40),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Colors.greenAccent,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  rightWords[index],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "madimiOne",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                ...leftMatches.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rightIndex = entry.value;
                  if (rightIndex != null) {
                    return CustomPaint(
                      painter: LinePainter(
                        start: leftDotPositions[index],
                        end: rightDotPositions[rightIndex],
                        // Only check correctness when the user presses the check button
                        color:
                            (isChecked && rightIndex == correctMatches[index])
                                ? Colors.greenAccent
                                : (isChecked
                                    ? Colors.redAccent
                                    : Colors.greenAccent),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                if (startOffset != null && endOffset != null)
                  CustomPaint(
                    painter: LinePainter(
                      start: startOffset!,
                      end: endOffset!,
                      color: Colors.greenAccent,
                    ),
                  ),
              
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: _resetBoxes, // Refresh button action
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
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(1),
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
                // Check button at the bottom left
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: _checkAnswers, // Check button action
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
              ],
            );
          },
        ),
      ),
    );
  }
}



