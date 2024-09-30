import 'dart:math';
import 'package:smart_kids_v1/pages/QUIZZES/Show_Result.dart';
import 'package:smart_kids_v1/pages/QUIZZES/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/text_to_speech.dart';

class Quiz_08_Eng extends StatefulWidget { // Spell Numbers
  @override
  _Quiz_08_EngState createState() => _Quiz_08_EngState();
}
class _Quiz_08_EngState extends State<Quiz_08_Eng> {
  final text_to_speech _textToSpeech = text_to_speech();
  late int _number;
  late List<String> _boxes;
  late List<String> _correctLetters;
  List<String> _shuffledLetters = []; // Initialize as empty list
  String _feedbackText = '';
  late Map<String, String?> _letterBoxMap;
  int attempts=0;
  int maxAttempts=2;

  final Map<int, String> _numberWords = {
    1: 'one',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
    10: 'ten',
  };

  @override
  void initState() {
    ScoreManager().resetScore();
    super.initState();
    _initializeGame();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  void _initializeGame() {
    setState(() {
      final random = Random();
      _number = random.nextInt(10) + 1; // Random number between 1 and 10
      _correctLetters = _numberWords[_number]!.split('');
      _boxes = List.generate(_correctLetters.length,
          (index) => ''); // Empty boxes based on the length of the word
      _shuffledLetters = List.from(_correctLetters)
        ..shuffle(); // Shuffle the letters
      _letterBoxMap = Map.fromIterable(_shuffledLetters,
          key: (item) => item,
          value: (item) => null); // Initialize letter box mapping
      _feedbackText = ''; // Clear feedback on refresh
      _speakNumber();
    });

  }

  void _speakNumber() async {
    await _textToSpeech.speak('Spell the number $_number');
  }

  void _handleDrop(String letter, int index) {
    setState(() {
      _boxes[index] = letter;
      _letterBoxMap[letter] = index.toString();
      _shuffledLetters.remove(letter);

      // Check if all boxes are filled and no letters are left to be dragged
      bool allFilled = !_boxes.contains('');
      bool noOptionsLeft = _shuffledLetters.isEmpty;

      // Provide feedback only if all boxes are filled and no options are left
      if (allFilled && noOptionsLeft) {
        if (_boxes.join('') == _numberWords[_number]) {
          ScoreManager().increaseScore(5); // Increment score for correct answer
          attempts++;
          _feedbackText =
              'Great job! You spelled the number $_number correctly.';
          _textToSpeech
              .speak('Great job! You spelled the number $_number correctly.');
            Future.delayed(Duration(seconds: 6), () {
            _initializeGame();
          });

        } else {
          attempts++;
          _feedbackText = 'Oops! That’s not right.';
          _textToSpeech.speak('Oops! That’s not right');
          Future.delayed(Duration(seconds: 6), () {
            _initializeGame();  
          });
        }
      } else {
        // Clear feedback while boxes are still being filled
        _feedbackText = '';
      }
    });
    if(attempts>maxAttempts){
         Future.delayed(Duration(seconds: 6), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Quiz_08_Eng2(),
          ),
        );
      });
    }
   
  }

  void _handleOptionSelected(String selectedOption) {
    setState(() {
      if (selectedOption == _numberWords[_number]) {
        _feedbackText = 'Great job! You spelled the number $_number correctly.';
        _textToSpeech
            .speak('Great job! You spelled the number $_number correctly.');
      } else {
        _feedbackText = 'Oops! That’s not right';
        _textToSpeech.speak('Oops! That’s not right');
      }
    });
  }

  void _resetBoxes() {
    setState(() {
      _boxes = List.generate(
          _correctLetters.length, (index) => ''); // Reset the boxes
      _shuffledLetters = List.from(_correctLetters)
        ..shuffle(); // Re-shuffle the letters
      _feedbackText = ''; // Clear feedback
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    _feedbackText,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "madimiOne",
                      fontWeight: FontWeight.bold,
                      color: _feedbackText.contains('Great job')
                          ? Colors.lightBlueAccent
                          : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_number',
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.tealAccent,
                          fontFamily: "madimiOne"),
                    ),
                    const SizedBox(height: 20),
                    _buildBoxes(),
                    const SizedBox(height: 20),
                    _buildOptions(),
                  ],
                ),
              ),
            ],
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
            bottom: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.9),
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
        ],
      ),
    );
  }

  Widget _buildBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_boxes.length, (index) {
        return DragTarget<String>(
          builder: (context, candidateData, rejectedData) {
            return _buildBox(_boxes[index]);
          },
          onAccept: (data) {
            _handleDrop(data, index);
          },
        );
      }),
    );
  }

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_shuffledLetters.length, (index) {
        return Draggable<String>(
          data: _shuffledLetters[index],
          child: _buildBox(_shuffledLetters[index], isOptionBox: true),
          feedback: _buildBox(_shuffledLetters[index],
              isFeedback: true, isOptionBox: true),
          childWhenDragging: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBox(String letter,
      {bool isFeedback = false, bool isOptionBox = false}) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlueAccent, width: 3),
        borderRadius: BorderRadius.circular(14),
        color: isOptionBox
            ? Colors.tealAccent
            : (isFeedback ? Colors.amber : Colors.white),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 40,
            color: isOptionBox
                ? Colors.white
                : Colors
                    .lightBlueAccent, // Black for answer boxes, white for option boxes
            fontFamily: "madimiOne",
          ),
        ),
      ),
    );
  }
}

//__________________________________________________________________________________
//__________________________________________________________________________________

class Quiz_08_Eng2 extends StatefulWidget { // Count Syllabels
  @override
  _Quiz_08_Eng2State createState() => _Quiz_08_Eng2State();
}

class _Quiz_08_Eng2State extends State<Quiz_08_Eng2> {
  final text_to_speech _textToSpeech = text_to_speech();
  late String _word;
  late List<String> _options;
  late String _correctOption;
  String _feedbackText = ''; // Variable to hold feedback text

  final List<String> _words = [
    'banana',
    'apple',
    'orange',
    'grape',
    'pineapple',
    'strawberry','blueberry','watermelon','kiwi','mango','bus', 'house',
    'fish','elephant','butterfly', 'tiger', 'monkey', 'zebra','panda','bottle',
    'balloon','chocolate','umbrella','bear','Car', 'carrot','lion','owl','pepper',
    'potato','tomato','eagle','orange','dog','nose','head','pineapple'
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _textToSpeech
        .speak('Listen to the word and select the correct number of syllables');
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
      _word = _words[random.nextInt(_words.length)];
      _correctOption = _countSyllables(_word).toString();
      _options = _generateOptions(_correctOption);
      _feedbackText = ''; // Clear feedback on refresh
      _speakWord();
    });
  }
int _countSyllables(String word) {
    word = word.toLowerCase().trim();

    // List of exceptions where 'e' at the end doesn't count as a syllable.
    final silentEWords = RegExp(r'e$', caseSensitive: false);
    final vowelPattern = RegExp(r'[aeiouy]{1,2}', caseSensitive: false);

    // Replace consecutive vowels with single vowel sounds
    List<RegExpMatch> vowelMatches = vowelPattern.allMatches(word).toList();

    // Count the number of vowel matches
    int syllableCount = vowelMatches.length;

    // Adjust for silent 'e' at the end (common in many English words)
    if (word.endsWith('e') && syllableCount > 1 && !word.endsWith('le')) {
      syllableCount--;
    }

    // Some words might have no vowels counted, default to 1 syllable
    return syllableCount > 0 ? syllableCount : 1;
  }


  List<String> _generateOptions(String correctOption) {
    final random = Random();
    final options = <String>{correctOption};
    while (options.length < 4) {
      options.add((random.nextInt(5) + 1).toString());
    }
    return options.toList()..shuffle();
  }

  void _speakWord() async {
    await _textToSpeech.speak(_word);
  }

  void _handleOptionSelected(String selectedOption) {
    setState(() {
      if (selectedOption == _correctOption) {
        _feedbackText =
            'Great job! Correct number of syllables is: $_correctOption.';
             ScoreManager().increaseScore(5); // Increment score for correct answer
        _textToSpeech.speak(
            'Great job! Correct number of syllables is: $_correctOption.');
      } else {
        _feedbackText = 'Oops! That’s not right';
        _textToSpeech.speak('Oops! That’s not right');
      }
    });
      Future.delayed(Duration(seconds: 6), () {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    _feedbackText,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'madimiOne',
                      fontWeight: FontWeight.bold,
                      color: _feedbackText.contains('Great job')
                          ? Colors.brown
                          : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _word,
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'coco_bold',
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildOptionButton(_options[0]),
                            const SizedBox(width: 20),
                            _buildOptionButton(_options[1]),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildOptionButton(_options[2]),
                            const SizedBox(width: 20),
                            _buildOptionButton(_options[3]),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20), // Rounded rectangle

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
          
        ],
      ),
    );
  }
  Widget _buildOptionButton(String option) {
    return SizedBox(
      width: 170, // Increase button width
      height: 80, // Increase button height
      child: ElevatedButton(
        onPressed: () => _handleOptionSelected(option),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent, // Background color of button
          foregroundColor: Colors.white, // This changes the text color to white
          textStyle: TextStyle(
            fontSize: 34, // Increase font size
            fontFamily: 'madimiOne',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded rectangle
          ),
        ),
        child: Text(option),
      ),
    );
  }
}
