import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '/text_to_speech.dart';

class Quiz_09_Eng extends StatefulWidget { // Sentence making
  @override
  _Quiz_09_EngState createState() => _Quiz_09_EngState();
}

class _Quiz_09_EngState extends State<Quiz_09_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
  late List<String> _sentenceWords; // List to store words of the sentence
  late List<String> _draggableWords; // List of draggable words
  late List<String> _emptyBoxes; // List for empty boxes
  String _feedbackText = ''; // Variable to hold feedback text
  int attempts=0;
  int maxAttempts=2;


  final List<String> _sentences = [
    'This is a cat',
    'I see a dog',
    'The big ball',
    'She loves apples',
    'We play outside',
    'The cat is big',
    'I see a sun',
    'The red car',
    'She has a ball',
    'We see a tree',
    'The dog runs fast',
    'I eat a sandwich',
    'The bird sings',
    'He likes milk',
    'The book is blue',
    'The frog jumps high',
    'I have a toy',
    'The star is bright',
    'We play with blocks',
    'The hat is green',
    'She rides a bike',
    'The fish swims fast',
    'The chair is red',
    'I see a rainbow',
    'The apple is red',
  ];

  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    _initializeGame();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
    setState(() {
      final random = Random();
      final sentence = _sentences[random.nextInt(_sentences.length)];
      _sentenceWords = sentence.split(' ');
      _draggableWords = List.from(_sentenceWords)..shuffle();
      _emptyBoxes = List.filled(_sentenceWords.length, '');
      _feedbackText = ''; // Clear feedback on refresh
      _speakSentence(sentence);
    });
  }

  void _speakSentence(String sentence) async {
    await _textToSpeech.speak(sentence);
  }

  void _handleWordDrop(int index, String word) {
    setState(() {
      if (_emptyBoxes[index].isEmpty) {
        _emptyBoxes[index] = word;
        _draggableWords.remove(word);
        _checkCompletion(); // Check completion after placing the word
      }
    });
  }

  void _checkCompletion() {
    if (_emptyBoxes.join(' ') == _sentenceWords.join(' ')) {
      setState(() {
        ScoreManager().increaseScore(5);
        attempts++;
        _feedbackText = 'Great job! You built the sentence correctly.';
        _textToSpeech.speak('Great job! You built the sentence correctly.');

      });
    } else if (_emptyBoxes.contains('')) {
      // Do nothing if there are still empty boxes
      return;
    } else {
      setState(() {
        attempts++;
        _feedbackText = 'Try again! The sentence is not correct.';
        _textToSpeech.speak('Try again! The sentence is not correct.');
      });
    }
    if(attempts>maxAttempts){
      Future.delayed(Duration(seconds: 6), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowResult(
              scoreObtained: ScoreManager().score,
              totalmarks: 15,
            ),
          ),
        );
      });
    }
    else{
      Future.delayed(Duration(seconds: 5), () {
        _initializeGame();
      });
    }
  }

  void _nextSentence() {
    _initializeGame(); // Refresh to a new sentence
  }

  void _resetBoxes() {
    setState(() {
      _emptyBoxes = List.filled(_sentenceWords.length, '');
      _draggableWords = List.from(_sentenceWords)..shuffle();
      _feedbackText = ''; // Clear feedback on reset
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top:
                    60), // Adjust the top padding to move the sentence boxes lower
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEmptyBoxesRow(),
                      const SizedBox(height: 20),
                      _buildDraggableWordsRow(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      _feedbackText,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'madimiOne',
                        fontWeight: FontWeight.bold,
                        color: _feedbackText.contains('Great job')
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
            top: 10,
            left: 85,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Make Sentence',
                style: TextStyle(
                  fontFamily: 'madimiOne',
                  color: Colors.amber.withOpacity(1),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
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
              child: TextButton(
                onPressed: _resetBoxes, // Add Refresh button action
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

  Widget _buildEmptyBoxesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_emptyBoxes.length, (index) {
        return _buildEmptyBox(index);
      }),
    );
  }

  Widget _buildDraggableWordsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_draggableWords.length, (index) {
        return _buildDraggableWordBox(_draggableWords[index]);
      }),
    );
  }

  Widget _buildEmptyBox(int index) {
    return DragTarget<String>(
      onAccept: (word) => _handleWordDrop(index, word),
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 145,
          height: 70,
          margin: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              _emptyBoxes[index],
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'madimiOne',
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableWordBox(String word) {
    return Draggable<String>(
      data: word,
      child: _buildWordBox(word),
      feedback: Material(
        color: Colors.transparent,
        child: _buildWordBox(word),
      ),
      childWhenDragging: _buildWordBox(''),
    );
  }

  Widget _buildWordBox(String word) {
    return Container(
      width: 155,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent, width: 2),
        borderRadius: BorderRadius.circular(30),
        color: Colors.greenAccent,
      ),
      child: Center(
        child: Text(
          word,
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontFamily: 'madimiOne',
          ),
        ),
      ),
    );
  }
}
