import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart';
import 'dart:math'; // To generate random numbers

class Quiz_04_Eng extends StatefulWidget { // Letter Number Mix Game
  @override
  _Quiz_04_EngState createState() => _Quiz_04_EngState();
}

class _Quiz_04_EngState extends State<Quiz_04_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
  List<String> _items = [];
  List<String> _letters = [];
  List<String> _draggedLetters = [];
  String _feedbackText = '';

  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeGame();
  }

  void _initializeGame() {
    _textToSpeech.speak('Drag and drop the letters into the basket');
    // Generate random letters
    List<String> letters = [];
    Random random = Random();
    const alphabet = 'abcdefghijklmnopqrstuvwxyz';
    while (letters.length < 8) {
      String letter = alphabet[random.nextInt(alphabet.length)];
      if (!letters.contains(letter)) {
        letters.add(letter);
      }
    }

    // Generate random numbers from 1 to 10
    List<String> numbers = [];
    while (numbers.length < 7) {
      String number = (random.nextInt(10) + 1).toString();
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }

    // Combine letters and numbers and shuffle them
    _items = [...letters, ...numbers];
    _items.shuffle();

    _letters = letters;
    _draggedLetters.clear();
    _feedbackText = '';
    setState(() {}); // Refresh UI
  }

  void _checkCompletion() {
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
    } else {
      if (_draggedLetters.toSet().containsAll(_letters.toSet())) {
        _textToSpeech.speak('Goodt job! All letters collected');
        ScoreManager().increaseScore(5); // Increment score for correct answer
        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Quiz_04_Eng2(),
            ),
          );
        });
        setState(() {
          _feedbackText = 'Correct! Well done!';
        });
      } else {
        _textToSpeech.speak(
            'Oops! The Basket is missing some letters');
        setState(() {
          _feedbackText = 'Some letters are missing!';
          Future.delayed(Duration(seconds: 4), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Quiz_04_Eng2(),
              ),
            );
          });
        });
      }
    }
  
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
              padding: const EdgeInsets.all(40), // Adjust padding as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _items.take(5).map((item) {
                      return _buildDraggableItem(item);
                    }).toList(),
                  ),
                  // Second Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _items.skip(5).take(5).map((item) {
                      return _buildDraggableItem(item);
                    }).toList(),
                  ),
                  // Third Row
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
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.9),
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
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _initializeGame, // Add Refresh button action
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
                color: Colors.amber.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _checkCompletion, // Add Refresh button action
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
            top: 170,
            right: 35,
            child: DragTarget<String>(
              onAccept: (receivedItem) {
                setState(() {
                  if (_draggedLetters.length < 8 &&
                      !_draggedLetters.contains(receivedItem)) {
                    _draggedLetters.add(receivedItem);
                  }
                });
                if (_draggedLetters.length == 8) {
                  _checkCompletion();
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      _draggedLetters.isEmpty
                          ? 'Drag Letters here'
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
            top: 16,
            right: 100,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _feedbackText,
                style: TextStyle(
                  fontFamily: "madimiOne",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _feedbackText.contains('Correct')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 74,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Letters: Drag 8 letters',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 11,
            left: 80,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Separate Alphabets',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontFamily: "madimiOne"),
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
        margin: const EdgeInsets.all(4), // Small space between boxes
        padding: const EdgeInsets.all(10),
        width: 70,
        height: 75,
        decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.8),
          border: Border.all(color: Colors.brown.withOpacity(0.7), width: 0),
          borderRadius: BorderRadius.circular(25),
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
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.brown, width: 3.0),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.orange,
                fontFamily: 'arial',
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.all(4), // Small space between boxes
        padding: const EdgeInsets.all(10),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: Border.all(color: Colors.orange, width: 3.0),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}

//___________________________________________________________________________________

class Quiz_04_Eng2 extends StatefulWidget { // Identify Vowels
  @override
  _Quiz_04_Eng2State createState() => _Quiz_04_Eng2State();
}

class _Quiz_04_Eng2State extends State<Quiz_04_Eng2> {
  final text_to_speech _textToSpeech = text_to_speech();
  List<String> _letters = [];
  List<String> _vowels = [];
  List<String> _draggedVowels = [];
  String _feedbackText = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeGame();
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
    _textToSpeech.speak('Drag and drop the vowels into the basket');

    List<String> vowels = ['a', 'e', 'i', 'o', 'u']; // Lowercase vowels
    List<String> alphabet = List.generate(
        26, (i) => String.fromCharCode(i + 97)); // Lowercase letters

    // Shuffle the alphabet to get a random order and select 10 consonants
    alphabet.shuffle();
    List<String> consonants =
        alphabet.where((letter) => !vowels.contains(letter)).take(10).toList();

    // Combine vowels and consonants
    List<String> selectedLetters = [];
    selectedLetters.addAll(vowels);
    selectedLetters.addAll(consonants);

    // Shuffle the selected letters to mix vowels and consonants
    selectedLetters.shuffle();

    _letters = selectedLetters;
    _vowels = _letters.where((letter) => vowels.contains(letter)).toList();

    _draggedVowels.clear();
    _feedbackText = '';
    setState(() {}); // Refresh UI
  }

  void _checkCompletion() {
    if (_draggedVowels.length == 5) {
      if (_draggedVowels.toSet().containsAll(_vowels.toSet())) {
        _textToSpeech.speak('Great job! All vowels Collected');
        ScoreManager().increaseScore(5); // Increment score for correct answer
        setState(() {
          _feedbackText = 'Correct! Well done!';
        });
      } else {
        _textToSpeech.speak('Oops! Some vowels are missing');
        setState(() {
          _feedbackText = 'Oops! Some vowels are missing';
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

  Widget _buildLetterRow(List<String> letters) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align boxes to the left
      children: letters.map((letter) {
        return Draggable<String>(
          data: letter,
          child: Container(
            margin: const EdgeInsets.all(5), // Reduce spacing between boxes
            width: 75, // Set fixed width
            height: 75, // Set fixed height
            decoration: BoxDecoration(
              color: Colors.teal,
              border: Border.all(color: Colors.teal, width: 3.0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontFamily: 'coco_bold',
                ),
              ),
            ),
          ),
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              width: 70, // Same width as the original box
              height: 70, // Same height as the original box
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange, width: 3.0),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.orange,
                    fontFamily: 'coco_bold',
                  ),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(
            margin: const EdgeInsets.all(6),
            width: 60, // Keep the size consistent
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              border: Border.all(color: Colors.orange, width: 3.0),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Split the letters into 3 rows
    final row1 = _letters.sublist(0, _letters.length ~/ 3);
    final row2 =
        _letters.sublist(_letters.length ~/ 3, 2 * _letters.length ~/ 3);
    final row3 = _letters.sublist(2 * _letters.length ~/ 3);

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
          Padding(
            padding:
                const EdgeInsets.fromLTRB(30, 70, 10, 10), // Added top padding
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align rows to the left
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLetterRow(row1),
                const SizedBox(height: 5),
                _buildLetterRow(row2),
                const SizedBox(height: 5),
                _buildLetterRow(row3),
              ],
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
                  fontSize: 22,
                  fontFamily: "madimiOne",
                  fontWeight: FontWeight.bold,
                  color: _feedbackText.contains('Correct')
                      ? Colors.teal
                      : Colors.redAccent,
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 150,
            child: DragTarget<String>(
              onAccept: (receivedVowel) {
                setState(() {
                  if (_draggedVowels.length < 5 &&
                      !_draggedVowels.contains(receivedVowel)) {
                    _draggedVowels.add(receivedVowel);
                  }
                });
                if (_draggedVowels.length == 5) {
                  _checkCompletion();
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 140,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      _draggedVowels.isEmpty
                          ? 'Drag vowels here'
                          : _draggedVowels.join(' '),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'coco_bold',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            left: 74,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Separate Vowels',
                style: TextStyle(
                  fontFamily: 'madimiOne',
                  color: Colors.amber,
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
                color: Colors.amber.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 60,
              height: 45,
              child: TextButton(
                onPressed: () {
                  _textToSpeech.stop();
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
          Positioned(
            top: 16,
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
