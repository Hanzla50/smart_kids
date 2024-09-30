import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart';

class Quiz_05_Math extends StatefulWidget { // COUNT OBJECTS
  @override
  _Quiz_05_MathState createState() => _Quiz_05_MathState();
}

class _Quiz_05_MathState extends State<Quiz_05_Math> {
  final text_to_speech _textToSpeech = text_to_speech();
  final List<String> images = [
    'assets/Math_Games/objects_1.png',
    'assets/Math_Games/objects_2.png',
    'assets/Math_Games/objects_3.png',
    'assets/Math_Games/objects_4.png',
    'assets/Math_Games/objects_5.png',
    'assets/Math_Games/objects_6.png',
    'assets/Math_Games/objects_7.png',
    'assets/Math_Games/objects_8.png',
    'assets/Math_Games/objects_9.png',
    'assets/Math_Games/objects_10.png',
  ];

  final List<List<int>> options = [
    [1, 2, 4],
    [9, 7, 4],
    [6, 8, 7],
    [5, 4, 3],
    [6, 5, 4],
    [2, 4, 3],
    [3, 5, 2],
    [6, 4, 5],
    [3, 4, 6],
    [9, 7, 8],
  ];

  final List<int> correctAnswers = [
    2, // Correct answer for objects_1.png
    9, // Correct answer for objects_2.png
    8, // C--------
    4,
    5,
    3,
    2,
    5,
    4,
    8,
  ];

  late String _selectedImage;
  late List<int> _selectedOptions;
  late int _correctAnswer;
  int? _draggedOption;

  @override
  void initState() {
    ScoreManager().resetScore();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
    _setLandscapeMode();
    _loadNewImage();
    _textToSpeech.speak('Count the Objects and choose right option');
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

  void _loadNewImage() {
    int index = Random().nextInt(images.length);
    setState(() {
      _selectedImage = images[index];
      _selectedOptions = options[index];
      _correctAnswer = correctAnswers[index];
      _draggedOption = null;
    });
    _textToSpeech.speak('Count the Objects and choose right option');
  }

  void _checkAnswer() {
    if (_draggedOption == _correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Correct!'),
        backgroundColor: Colors.green,
      ));
      _textToSpeech.speak('Good Job , thats the correct answer');
      ScoreManager().increaseScore(5); // Increment score for correct answer
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wrong!'),
        backgroundColor: Colors.red,
      ));
      _textToSpeech.speak('Oops, Thats not correct answer');
    }
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Quiz_05_Math2()),
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
                image: AssetImage(
                    'assets/board_background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 165,
            child: Image.asset(_selectedImage, height: 170),
          ),
          Positioned(
            top: 245,
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color:
                        Colors.white, // Keep the background white at all times
                  ),
                  child: Center(
                    child: Text(
                      _draggedOption?.toString() ??
                          '?', // '?' if no option is dragged yet
                      style: TextStyle(
                        fontSize: 34,
                        color: _draggedOption != null
                            ? Colors.green
                            : Colors
                                .redAccent, // Green for correct, black otherwise
                        fontFamily: 'madimiOne',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Positioned(
            top: 230,
            right: 300,
            child: Column(
              children: [
                Text('=',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontFamily: 'madimiOne',
                    )),
              ],
            ),
          ),
          Positioned(
            top: 230,
            left: 190,
            child: Row(
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
                color: Colors.redAccent.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizMenuScreen()),
                  );
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
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isHidden ? Colors.transparent : Colors.white,
        border: Border.all(
            color: isDragging ? Colors.white : Colors.white, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          option.toString(),
          style: TextStyle(
            fontFamily: 'madimiOne',
            fontSize: 34,
            color: isHidden ? Colors.transparent : Colors.green,
          ),
        ),
      ),
    );
  }
}


//______________________________________________________________________________________
//______________________________________________________________________________________

class Quiz_05_Math2 extends StatefulWidget { // COUNT AND MATCH
  const Quiz_05_Math2({super.key});

  @override
  _Quiz_05_Math2State createState() =>
      _Quiz_05_Math2State();
}

class _Quiz_05_Math2State extends State<Quiz_05_Math2> {
  final text_to_speech _textToSpeech = text_to_speech();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _initializeGame();

  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  List<int?> leftMatches = List.filled(3, null);
  List<int?> rightMatches = List.filled(3, null);
  List<Offset> leftDotPositions = List.filled(3, Offset.zero);
  List<Offset> rightDotPositions = List.filled(3, Offset.zero);
  bool isChecked = false;

  final List<Map<String, dynamic>> wordSets = [
    {
      'leftImages': [
        'assets/Math_Games/objects_1.png',
        'assets/Math_Games/objects_2.png',
        'assets/Math_Games/objects_3.png',
      ],
      'rightWords': ['9', '2', '8'], // 2 9 8
      'correctMatches': [1, 0, 2],
    },
     {
      'leftImages': [
        'assets/Math_Games/objects_4.png',
        'assets/Math_Games/objects_5.png',
        'assets/Math_Games/objects_6.png',
      ],
      'rightWords': ['5', '3', '4'],   // 4 5 3
      'correctMatches': [2, 0, 1],
    },
    {
      'leftImages': [
        'assets/Math_Games/objects_7.png',
        'assets/Math_Games/objects_8.png',
        'assets/Math_Games/objects_9.png',
      ],
      'rightWords': ['5', '2', '4'],  // 2 5 4
      'correctMatches': [1, 0, 2],
    },
    {
      'leftImages': [
        'assets/Math_Games/objects_10.png',
        'assets/Math_Games/objects_4.png',
        'assets/Math_Games/objects_8.png',
      ],
      'rightWords': ['4', '8', '5'], // 8  4  5
      'correctMatches': [1, 0, 2],
    },
  ];

  List<String> leftImages = [];
  List<String> rightWords = [];
  List<int> correctMatches = [];

  Offset? startOffset;
  Offset? endOffset;
  int? selectedLeftDotIndex;
  int? selectedRightDotIndex;
  bool isDraggingFromLeft = true;

  void resetGame() {
    setState(() {
      leftMatches = List.filled(3, null);
      rightMatches = List.filled(3, null);
      startOffset = null;
      endOffset = null;
      isChecked = false;
    });
  }

  void _initializeGame() {
    _textToSpeech.speak('Count the Objects and Match with the correct option');
    Map<String, dynamic> selectedSet =
        wordSets[_random.nextInt(wordSets.length)];

    setState(() {
      leftImages = List<String>.from(selectedSet['leftImages']);
      rightWords = List<String>.from(selectedSet['rightWords']);
      correctMatches = List<int>.from(selectedSet['correctMatches']);
    });

    resetGame();
  }

  void _resetBoxes() {
    _textToSpeech.speak('Count the Objects and Match with the correct option');
    resetGame();
  }

  void _checkAnswers() {
    setState(() {
      isChecked = true;

      bool allCorrect = true;
      for (int i = 0; i < leftMatches.length; i++) {
        if (leftMatches[i] != correctMatches[i]) {
          allCorrect = false;
          break;
        }
      }
      if (allCorrect) {
        print('Great Job, All the matches are correct');
        _textToSpeech.speak('Good Job , ALl the matches are correct');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Correct!'),
          backgroundColor: Colors.green,
        ));
        ScoreManager().increaseScore(5); // Increment score for correct answer
      } else {
        print('Oops, the red line matches are incorrect');
        _textToSpeech.speak('Oops, the red line matches are incorrect');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong!'),
          backgroundColor: Colors.red,
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Math_Games/board_background_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(leftImages.length, (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  leftImages[index],
                                  width: 240,
                                  height: 100,
                                ),
                                const SizedBox(width: 0),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      final RenderBox box = context
                                          .findRenderObject() as RenderBox;
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
                                              leftMatches[
                                                  selectedLeftDotIndex!] = i;
                                              rightMatches[i] =
                                                  selectedLeftDotIndex;
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
                      const SizedBox(width: 50),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(rightWords.length, (index) {
                            return Row(
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      final RenderBox box = context
                                          .findRenderObject() as RenderBox;
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
                                          startOffset =
                                              rightDotPositions[index];
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
                                          for (int i = 0;
                                              i < leftDotPositions.length;
                                              i++) {
                                            if ((leftDotPositions[i] -
                                                        endOffset!)
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
                                const SizedBox(width: 100),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Colors.white,
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
                          color:
                              (isChecked && rightIndex == correctMatches[index])
                                  ? Colors.white
                                  : (isChecked
                                      ? Colors.redAccent
                                      : Colors.white),
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
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
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
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: _checkAnswers,
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
        color: Colors.white,
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
