import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AllPicDict extends StatefulWidget {
  final String category;

  AllPicDict({required this.category});

  @override
  _AllPicDictState createState() => _AllPicDictState();
}

class _AllPicDictState extends State<AllPicDict> {
  int _currentIndex = 0;
  String _currentText = '';
  List<String> _imagePaths = [];
  List<String> _animalNames = [];

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _initializeCategoryData(widget.category);

    _speakAnimalName(
        _currentIndex); // Speak the first animal name when the app starts
  }

  void _initializeCategoryData(String category) {
    switch (category) {
      case 'Animals':
        _imagePaths = [
         'assets/Dictionary_Glossary/Animals/dog.png',
          'assets/Dictionary_Glossary/Animals/cat.png',
          'assets/Dictionary_Glossary/Animals/lion.png',
          'assets/Dictionary_Glossary/Animals/tiger.png',
          'assets/Dictionary_Glossary/Animals/bear.png',
          'assets/Dictionary_Glossary/Animals/giraffe.png',
          'assets/Dictionary_Glossary/Animals/monkey.png',
          'assets/Dictionary_Glossary/Animals/elephant.png',

          // Add more image paths as needed
        ];
        _animalNames = [
          'D, O, G,   Dog',
          'C, A, T,   Cat',
          'L, I, O, N,   Lion',
          'T, I, G, E, R,   TIGER',
          'B, E, A, R,   Bear',
          'G, I, R, A, F, F, E,   Giraffe',
          'M, O, N, K, E, Y,   Monkey',
          'E, L, E, P, H, A, N, T,   Elephant',
          // Add more animal names as needed
        ];
        break;
        case 'Birds':
        _imagePaths = [
          'assets/Dictionary_Glossary/Birds/parrot.png',
          'assets/Dictionary_Glossary/Birds/owl.png',
          'assets/Dictionary_Glossary/Birds/duck.png',
          'assets/Dictionary_Glossary/Birds/eagle.png',
          'assets/Dictionary_Glossary/Birds/sparrow.png',
          // Add more image paths as needed
        ];
        _animalNames = [
          'P, A, R, R, O, T    Parrot ',
          'O, W, L,    Owl',
          'D, U, C, K   Duck',
          'E, A, G, L, E   Eagle',
          'S, P, A, R, R, O, W   Sparrow',
          // Add more animal names as needed
        ];
        break;
      // Add cases for other categories here
      case 'Fruits':
        _imagePaths = [
          'assets/Dictionary_Glossary/Fruits/apple.png',
          'assets/Dictionary_Glossary/Fruits/mango.png',
          'assets/Dictionary_Glossary/Fruits/orange.png',
          'assets/Dictionary_Glossary/Fruits/banana.png',
          'assets/Dictionary_Glossary/Fruits/kiwi.png',
        ];
        _animalNames = [
          'A, P, P, L, E,    apple ',
          'M, A, N, G, O,     Mango',
          'O, R, A, N, G, E,    orange',
          'B, A, N, A, N, A,    Banana',
          'K, I, W, I,     Kiwi',
          // Add more animal names as needed
        ];
        break;
     case 'Vegetables':
        _imagePaths = [
          'assets/Dictionary_Glossary/Vegetables/carrot.png',
          'assets/Dictionary_Glossary/Vegetables/pepper.png',
          'assets/Dictionary_Glossary/Vegetables/tomato.png',
          'assets/Dictionary_Glossary/Vegetables/potato.png',
          'assets/Dictionary_Glossary/Vegetables/corn.png',
          // Add more image paths as needed
        ];
        _animalNames = [
          'C, A, R, R, O, T   carrot',
          'P, E, P, P, E, R     pepper',
          'T, O, M, A, T, O,    tomato',
          'P, O, T, A, T, O,    potato',
          'C, O, R, N,     corn',
          // Add more animal names as needed
        ];
        break;
        case 'Body_Parts':
        _imagePaths = [
          'assets/Dictionary_Glossary/Body_Parts/head.png',
          'assets/Dictionary_Glossary/Body_Parts/ears.png',
          'assets/Dictionary_Glossary/Body_Parts/nose.png',
          'assets/Dictionary_Glossary/Body_Parts/mouth.png',
          'assets/Dictionary_Glossary/Body_Parts/legs.png',
          'assets/Dictionary_Glossary/Body_Parts/arms.png',
          'assets/Dictionary_Glossary/Body_Parts/feet.png',
          'assets/Dictionary_Glossary/Body_Parts/eyes.png',
        ];
        _animalNames = [
          'H, E, A, D,   Head',
          'E, A, R, S     ears',
          'N, O, S, E,    nose',
          'M, O, U, T, H,     mouth',
          'L, E, G, S,     legs',
          'A, R, M, S,    arms',
          'F, E, E, T,    feet',
          'E, Y, E, S     eyes',
        ];
        break;
        case 'Colors':
        _imagePaths = [
          'assets/Dictionary_Glossary/Colors/white.png',
          'assets/Dictionary_Glossary/Colors/black.png',
          'assets/Dictionary_Glossary/Colors/green.png',
          'assets/Dictionary_Glossary/Colors/blue.png',
          'assets/Dictionary_Glossary/Colors/red.png',
          'assets/Dictionary_Glossary/Colors/yellow.png',
          'assets/Dictionary_Glossary/Colors/orange.png',
          'assets/Dictionary_Glossary/Colors/pink.png',
          'assets/Dictionary_Glossary/Colors/brown.png',
          'assets/Dictionary_Glossary/Colors/purple.png',
        ];
        _animalNames = [
          'W, H, I, T, E    White',
          'B, L, A, C, K     black',
          'G, R, E, E, N    green',
          'B, L, U, E,     blue',
          'R, E, G,     red',
          'Y, E, L, L, O, W     yellow',
          'O, R, A, N, G, E    orange',
          'P, I, N, K     pink',
          'B, R, O, W, N     brown',
          'P, U, R, P, L, E    purple',
        ];
        break;
         case 'Shapes':
        _imagePaths = [
          'assets/Dictionary_Glossary/Shapes/circle.png',
          'assets/Dictionary_Glossary/Shapes/star.png',
          'assets/Dictionary_Glossary/Shapes/triangle.png',
          'assets/Dictionary_Glossary/Shapes/rectangle.png',
          'assets/Dictionary_Glossary/Shapes/oval.png',
          'assets/Dictionary_Glossary/Shapes/heart.png',
        ];
        _animalNames = [
          'C, I, R, C, L, E     circle',
          'S, T, A, R    star',
          'T, R, I, A, N, G, L, E    triangle',
          'R, E, C, T, A, N, G, L, E    rectangle',
          'O, V, A, L     oval',
          'H, E, A, R, T      heart',
        ];
        break;
        case 'Vehicles':
        _imagePaths = [
          'assets/Dictionary_Glossary/Vehicles/car.png',
          'assets/Dictionary_Glossary/Vehicles/bus.png',
          'assets/Dictionary_Glossary/Vehicles/truck.png',
          'assets/Dictionary_Glossary/Vehicles/boat.png',
          'assets/Dictionary_Glossary/Vehicles/scooter.png',
        ];
        _animalNames = [
          'C, A, R,     car',
          'B, U, S,     bus',
          'T, R, U, C, K    truck',
          'B, O, A, T     boat',
          'S, C, O, O, T, E, R      scooter',
        ];
        break;
      default:
        _imagePaths = [];
        _animalNames = [];
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
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _imagePaths.length) % _imagePaths.length;
      _speakAnimalName(_currentIndex);
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      _speakAnimalName(_currentIndex);
    });
  }

  Future<void> _speakAnimalName(int index) async {
    String animalName = _animalNames[index];
    setState(() {
      _currentText = '';
    });

    await flutterTts.setVoice({"name": "en-us-x-sfg#female_2-local"});
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.2); // Adjust the speech rate here

    // Update the displayed text letter by letter
    List<String> letters = animalName.split(', ');
    for (String letter in letters) {
      setState(() {
        _currentText += letter + ' ';
      });
      await flutterTts.speak(letter);
      await Future.delayed(Duration(seconds: 1)); // Adjust the delay as needed
    }
  }

  Future<void> _speakCurrentAnimalName() async {
    await _speakAnimalName(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Dictionary_Glossary/board3.png'),
                fit: BoxFit.cover, // Ensure background covers the entire screen
              ),
            ),
          ),
          _buildLandscapeView(),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              color: Colors.white,
              iconSize: 40,
            ),
          ),
          Positioned(
            bottom: 16, // Adjust the bottom position as needed
            right: 16, // Adjust the right position as needed
            child: ElevatedButton(
              onPressed: _speakCurrentAnimalName,
              child: Icon(Icons.volume_up),
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

  String trimLettersAfterDoubleSpace(String text) {
    List<String> words = text.split(' ');
    List<String> result = [];

    int consecutiveSpaces = 0;
    for (String word in words) {
      if (word.isEmpty) {
        consecutiveSpaces++;
        if (consecutiveSpaces >= 2) {
          break;
        }
      } else {
        if (consecutiveSpaces >= 2) {
          break;
        }
        result.add(word);
        consecutiveSpaces = 0;
      }
    }

    return result.join('');
  }

  Widget _buildLandscapeView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _imagePaths[_currentIndex],
              fit: BoxFit.contain, // Adjust as needed
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.brown.withOpacity(1.0), // Adjust opacity as needed
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousImage,
                color: Colors.white,
                iconSize: 40, // Making icon bigger
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.brown.withOpacity(1.0), // Adjust opacity as needed
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextImage,
                color: Colors.white,
                iconSize: 40, // Making icon bigger
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 33,
            child: Image.asset(
              'assets/GIFS/gif2.gif',
              height: 225, // Adjust height as needed
            ),
          ),
          Positioned(
            top: 50, // Adjust the top position as needed
            left: 400, // Align to the left
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(trimLettersAfterDoubleSpace(_currentText),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'arial', // Change font family
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
