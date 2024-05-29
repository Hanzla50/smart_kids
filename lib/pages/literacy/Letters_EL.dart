import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:flutter_gifimage/flutter_gifimage.dart';

class Letters_EL extends StatefulWidget {
  @override
  _Letters_ELState createState() => _Letters_ELState();
}

class _Letters_ELState extends State<Letters_EL> {
  int _currentIndex = 0;
  final List<String> _imagePaths = [
    'assets/gtv5.png',
    'assets/b.png',
    'assets/c.png',
    'assets/d.png',
    'assets/e.png',
    'assets/f.png',
    'assets/g.png',
    'assets/h.png',
    'assets/i.png',
    'assets/j.png',
    'assets/k.png',
    'assets/l.png',
    'assets/m.png',
    'assets/n.png',
    'assets/o.png',
    'assets/p.png',
    'assets/q.png',
    'assets/r.png',
    'assets/s.png',
    'assets/t.png',
    'assets/u.png',
    'assets/v.png',
    'assets/w.png',
    'assets/x.png',
    'assets/y.png',
    'assets/z.png',
    // Add more image paths as needed
  ];

  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
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
      _currentIndex = (_currentIndex - 1) % _imagePaths.length;
      _speakLetter(_currentIndex);
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      _speakLetter(_currentIndex);
    });
  }

  Future<void> _speakLetter(int index) async {
    setState(() {
      _isSpeaking = true;
    });

    await flutterTts.setVoice({"name": "en-us-x-sfg#female_2-local"});
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.2); // Adjust the speech rate here

    await flutterTts
        .speak("hello"); // A = 65, B = 66, ...

    setState(() {
      _isSpeaking = false;
    });
  }

  Future<void> _speakCurrentLetter() async {
    await flutterTts.setVoice({"name": "en-us-x-sfg#female_2-local"});
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.2); // Adjust the speech rate here
    await flutterTts.speak("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/board.png'),
                fit: BoxFit.cover, // Ensure background covers the entire screen
              ),
            ),
          ),
          OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.landscape
                  ? _buildLandscapeView()
                  : _buildPortraitView();
            },
          ),
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
              onPressed: _speakCurrentLetter,
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

  Widget _buildPortraitView() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0, // Added to stretch over the entire width
                  child: Image.asset(
                    _imagePaths[_currentIndex],
                    fit: BoxFit.contain, // Adjust as needed
                  ),
                ),
                if (_isSpeaking)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/GIFS/gif2.gif',
                      height: 150, // Adjust height as needed
                    ),
                  ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousImage,
                    color: Colors.yellow,
                    iconSize: 40, // Making icon bigger
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _nextImage,
                    color: Colors.yellow,
                    iconSize: 40, // Making icon bigger
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
                  Colors.white.withOpacity(0.9), // Adjust opacity as needed
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _previousImage,
              color: Colors.green,
              iconSize: 50, // Making icon bigger
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
                  Colors.white.withOpacity(0.9), // Adjust opacity as needed
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _nextImage,
              color: Colors.green,
              iconSize: 50, // Making icon bigger
            ),
          ),
        ),
        if (_isSpeaking)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 33,
            child: Image.asset(
              'assets/GIFS/gif2.gif',
              height: 220, // Adjust height as needed
            ),
          ),
      ],
    ),
  );
}
}