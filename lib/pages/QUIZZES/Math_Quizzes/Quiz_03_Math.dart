import 'package:smart_kids_v1/pages/QUIZZES/Quiz_Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../score_manager.dart'; // Import your ScoreManager class
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import '/text_to_speech.dart';

class Quiz_03_Math extends StatefulWidget { // Separate Numbers
  @override
  _Quiz_03_MathState createState() => _Quiz_03_MathState();
}

class _Quiz_03_MathState extends State<Quiz_03_Math> {
  final text_to_speech _textToSpeech = text_to_speech();
  List<String> _items = [];
  List<String> _letters = [];
  List<String> _draggedLetters = [];
  String _feedbackText = '';

  @override
  void initState() {
    super.initState();
      ScoreManager().resetScore();
    _textToSpeech.speak('Drag and drop all the numbers into the basket');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeGame();
  }

  void _initializeGame() {
    List<String> letters = [];
    Random random = Random();
    const alphabet = 'abcdefghijklmnopqrstuvwxyz';
    while (letters.length < 8) {
      String letter = alphabet[random.nextInt(alphabet.length)];
      if (!letters.contains(letter)) {
        letters.add(letter);
      }
    }

    List<String> numbers = [];
    while (numbers.length < 7) {
      String number = (random.nextInt(9) + 1).toString();
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }

    _items = [...letters, ...numbers]..shuffle();
    _letters = letters;
    _draggedLetters.clear();
    _feedbackText = '';
    setState(() {});
  }

  void _checkCompletion() {
    bool allNumbers =
        _draggedLetters.every((item) => int.tryParse(item) != null);
    if (_draggedLetters.isEmpty) {
      setState(() {
        _feedbackText = 'The basket is empty!';
      });
      _textToSpeech.speak('The basket is empty. Please drag some letters.');
    } else if (_draggedLetters.length < 8) {
      setState(() {
        _feedbackText = 'Please add more letters!';
      });
      _textToSpeech.speak('Please add more letters.');
    }

    if (_draggedLetters.length == 7 && allNumbers) {
      _textToSpeech.speak('Great job! All the numbers identified correctly.');
      setState(() {
        _feedbackText = 'Correct! Well done';
        ScoreManager().increaseScore(5); // Increment score for correct answer
      });
    } else {
      _textToSpeech
          .speak('Oops! The Basket is missing Some Numbers');
      setState(() {
        _feedbackText = 'Oops! Some Numbers are missing';
      });
    }

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Quiz_03_Math2()),
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
                image: AssetImage('assets/basket_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _items.take(5).map((item) {
                      return _buildDraggableItem(item);
                    }).toList(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _items.skip(5).take(5).map((item) {
                      return _buildDraggableItem(item);
                    }).toList(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _items.skip(10).map((item) {
                      return _buildDraggableItem(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _draggedLetters.clear();
                    _feedbackText = '';
                  });
                  _textToSpeech
                      .speak('Basket emptied. Please drag some letters.');
                },
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
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _checkCompletion,
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
            top: 170,
            right: 35,
            child: DragTarget<String>(
              onAccept: (receivedItem) {
                setState(() {
                  if (_draggedLetters.length < 7 &&
                      !_draggedLetters.contains(receivedItem)) {
                    _draggedLetters.add(receivedItem);
                  }
                });
                if (_draggedLetters.length == 7) {
                  _checkCompletion();
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _draggedLetters.isEmpty
                          ? 'Drag items here'
                          : _draggedLetters.join(' '),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'madimiOne',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 80,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Separate Numbers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  fontFamily: "madimiOne",
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 14,
            right: 90,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _feedbackText,
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _feedbackText.contains('Correct')
                      ? Colors.greenAccent
                      : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(String item) {
    return Draggable<String>(
      data: item,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        width: 70,
        height: 75,
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          border: Border.all(color: Colors.greenAccent, width: 3.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'arial',
            ),
          ),
        ),
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 70,
        height: 75,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
//___________________________________________________________________________________
//___________________________________________________________________________________

class Quiz_03_Math2 extends StatefulWidget {
  @override
  _Quiz_03_Math2State createState() => _Quiz_03_Math2State(); // Even ODDS
}

class _Quiz_03_Math2State extends State<Quiz_03_Math2> {
  final text_to_speech _textToSpeech = text_to_speech();
  List<int> _numbers = [];
  List<int> _evens = [];
  List<int> _odds = [];
  List<int> _draggedNumbers = [];
  String _feedbackText = '';
  String _title = '';

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _initializeGame() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Generate numbers from 1 to 90
    List<int> allNumbers = List.generate(90, (index) => index + 1);

    // Separate into odd and even numbers
    List<int> evens = allNumbers.where((number) => number % 2 == 0).toList();
    List<int> odds = allNumbers.where((number) => number % 2 != 0).toList();

    // Shuffle the lists
    evens.shuffle();
    odds.shuffle();

    // Select 5 numbers from each list
    List<int> selectedEvens = evens.take(5).toList();
    List<int> selectedOdds = odds.take(5).toList();

    // Combine and shuffle the selected numbers
    _numbers = [...selectedEvens, ...selectedOdds]..shuffle();

    // Set the title randomly
    _title = Random().nextBool() ? 'Even Numbers' : 'Odd Numbers';

    // Update the evens and odds lists for checking
    _evens = selectedEvens;
    _odds = selectedOdds;

    // Clear the dragged numbers and reset feedback
    _draggedNumbers.clear();
    _feedbackText = '';

    // Refresh UI
    setState(() {});
    _textToSpeech.speak('Give $_title the bear');

  }

  void _checkCompletion() {
    if (_draggedNumbers.length == 5) {
      final correctNumbers = _title == 'Even Numbers' ? _evens : _odds;

      if (_draggedNumbers.toSet().containsAll(correctNumbers.toSet())) {
        _textToSpeech.speak('Great job! All $_title are identified correctly.');
        setState(() {
          _feedbackText = 'Correct! Well done!';
          ScoreManager().increaseScore(5); // Increment score for correct answer
        });
      } else {
        _textToSpeech.speak('Oops! Some $_title are missing.');
        setState(() {
          _feedbackText = 'Oops! Some $_title are missing.';
        });
      }
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

  void _clearBasket() {
    setState(() {
      _draggedNumbers.clear();
      _feedbackText = ''; // Optionally clear feedback text
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
                image: AssetImage('assets/Math_Games/bear_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First row of numbers
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _numbers.take(5).map((number) {
                    return _buildDraggable(number);
                  }).toList(),
                ),
                // Second row of numbers
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _numbers.skip(5).map((number) {
                    return _buildDraggable(number);
                  }).toList(),
                ),
                // Score display
                
              ],
            ),
          ),
          Positioned(
            top: 14,
            right: 30,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _feedbackText,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "madimiOne",
                  fontWeight: FontWeight.bold,
                  color: _feedbackText.contains('Correct')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
          Positioned(
            right: 54,
            top: 195,
            child: DragTarget<int>(
              onAccept: (receivedNumber) {
                setState(() {
                  if (_draggedNumbers.length < 5 &&
                      !_draggedNumbers.contains(receivedNumber)) {
                    _draggedNumbers.add(receivedNumber);
                  }
                });
                if (_draggedNumbers.length == 5) {
                  _checkCompletion();
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 170,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _draggedNumbers.isEmpty
                          ? 'Drop $_title here'
                          : _draggedNumbers.join(' '),
                      style: const TextStyle(
                        fontSize: 21,
                        color: Colors.green,
                        fontFamily: 'madimiOne',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 84,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                _title,
                style: TextStyle(
                  fontFamily: 'madimiOne',
                  color: Colors.green.withOpacity(0.8),
                  fontSize: 26,
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
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
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
          // Clear Basket Button (Bottom Left)
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _clearBasket,
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

  // Helper function to build draggable number container
  Widget _buildDraggable(int number) {
    return Draggable<int>(
      data: number,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.brown,
          border: Border.all(color: Colors.brown, width: 3.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'madimiOne',
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
            border: Border.all(color: Colors.orange, width: 3.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.orange,
                fontFamily: 'madimiOne',
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
          border: Border.all(color: Colors.orange, width: 3.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}