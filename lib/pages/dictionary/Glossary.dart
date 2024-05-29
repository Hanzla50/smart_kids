import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Glossary extends StatefulWidget {
  final String category;

  Glossary({required this.category});

  @override
  _GlossaryState createState() => _GlossaryState();
}

class _GlossaryState extends State<Glossary> {
  int _currentIndex = 0;
  String _currentText = '';
  List<String> _imagePaths = [];
  List<String> _sentences = [];

  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _initializeCategoryData(widget.category);

    if (_imagePaths.isNotEmpty && _sentences.isNotEmpty) {
      _speakSentence(
          _currentIndex); // Speak the first sentence when the app starts
    } else {
      print("Error: Image paths or sentences list is empty.");
    }
  }

  void _initializeCategoryData(String category) {
    switch (category) {
      case 'ball':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/ball.png',
        ];
        _sentences = [
          'A round toy you can throw, kick, or bounce. You can play games like catch or soccer with a ball.',
        ];
        break;
      case 'cup':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/cup.png',
        ];
        _sentences = [
          'A small container used for drinking. You can drink juice, milk, or water from a cup.',
        ];
        break;
      case 'fish':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/fish.png',
        ];
        _sentences = [
          'Fish is an animal that lives in water and has fins and scales. They breathe through gills.',
        ];
        break;
      case 'flower':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/flower.png',
        ];
        _sentences = [
          'A colorful plant that blooms and smells good. Flowers come in many shapes and colors.',
        ];
        break;
      case 'chair':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/chair.png',
        ];
        _sentences = [
          'A chair has four legs. Its color is brown. It is made of wood. A carpenter made it.',
        ];
        break;
      case 'tree':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/tree.png',
        ];
        _sentences = [
          'A plant with branches and leaves. Trees provide shade, oxygen, and homes for birds and animals.',
        ];
        break;
      case 'butterfly':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/butterfly.png',
        ];
        _sentences = [
          'An insect with colorful wings that flies from flower to flower. They are of different colors.',
        ];
        break;
      case 'book':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/book.png',
        ];
        _sentences = [
          'This is a book. It has many pages. It contains poems, stories, lessons, and photos.',
        ];
        break;
      case 'dog':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/dog.png',
        ];
        _sentences = [
          'Dog is a friendly animal often kept as a pet. Dogs bark and they love to play fetch!',
        ];
        break;
      case 'milk':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/milk.png',
        ];
        _sentences = [
          'A white drink that comes from cows. Milk is good for your bones and helps you grow strong.',
        ];
        break;
      case 'bicycle':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/bicycle.png',
        ];
        _sentences = [
          'A vehicle with two wheels that you pedal to move. Bicycles are fun to ride in the park.',
        ];
        break;
      case 'mountain':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/mountain.png',
        ];
        _sentences = [
          'A very tall landform that reaches high into the sky. Mountains are often covered with snow at the top.',
        ];
        break;
      case 'moon':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/moon.png',
        ];
        _sentences = [
          'The bright object you see in the night sky. The moon changes shape and lights up the night.',
        ];
        break;
      case 'rainbow':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/rainbow.png',
        ];
        _sentences = [
          'A colorful arc in the sky after it rains. Rainbows have red, orange, yellow, green, blue, and purple colors.',
        ];
        break;
      case 'pencil':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/pencil.png',
        ];
        _sentences = [
          'A tool you use to write or draw. It has a long body made of wood. Pencils have an eraser to fix mistakes.',
        ];
        break;
      case 'sun':
        _imagePaths = [
          'assets/Dictionary_Glossary/Glossary/sun.png',
        ];
        _sentences = [
      'The big, bright star that gives us light. The sun rises in the morning and sets in the evening.',
        ];
        break;
      default:
        _imagePaths = [];
        _sentences = [];
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _previousImage() {
    if (_imagePaths.isNotEmpty && _sentences.isNotEmpty) {
      setState(() {
        _currentIndex =
            (_currentIndex - 1 + _imagePaths.length) % _imagePaths.length;
        _speakSentence(_currentIndex);
      });
    }
  }

  void _nextImage() {
    if (_imagePaths.isNotEmpty && _sentences.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
        _speakSentence(_currentIndex);
      });
    }
  }

  Future<void> _speakSentence(int index) async {
    if (_isSpeaking || _sentences.isEmpty) {
      print("Speech is already in progress or sentences list is empty.");
      return; // Prevent overlapping speech and empty list access
    }

    String sentence = _sentences[index];
    List<String> words = sentence.split(' ');
    _currentText = ''; // Reset the current text
    _isSpeaking = true;

    await flutterTts.setVoice({"name": "en-us-x-sfg#female_2-local"});
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.3); // Adjust the speech rate here

    for (String word in words) {
      if (!mounted) return; // Ensure the widget is still mounted
      setState(() {
        _currentText += word + ' ';
      });
      await flutterTts.speak(word);
      await Future.delayed(Duration(seconds: 1)); // Adjust the delay as needed
    }

    _isSpeaking = false;
  }

  Future<void> _speakCurrentSentence() async {
    await _speakSentence(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/Dictionary_Glossary/Glossary/board4.png'),
                fit: BoxFit.cover, // Ensure background covers the entire screen
              ),
            ),
          ),
          _buildLandscapeView(),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.close,
                  size: 40,
                  color: Colors.brown), // Make the close icon bold and brown
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),
          Positioned(
            bottom: 5, // Adjust the bottom position as needed
            right: 5, // Adjust the right position as needed
            child: ElevatedButton(
              onPressed: _speakCurrentSentence,
              child: Icon(Icons.volume_up,
                  color: Colors
                      .black), // Change the color of the volume icon to white
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10), // Adjust the padding as needed
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          if (_imagePaths.isNotEmpty)
            Positioned.fill(
              child: Image.asset(
                _imagePaths[_currentIndex],
                fit: BoxFit.contain, // Adjust as needed
                alignment: Alignment.center,
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            child: Image.asset(
              'assets/GIFS/gif2.gif',
              height: 225, // Adjust height as needed
            ),
          ),
          Positioned(
            top: 40, // Adjust the top position as needed
            left: 260, // Align to the left
            child: Container(
              width: 450, // Set the width to 450
              alignment: Alignment.centerLeft,
              child: Text(
                _currentText,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'arial',
                  color:
                      Colors.white.withOpacity(1), // Change text color to white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
