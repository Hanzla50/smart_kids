import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Numbers_EL extends StatefulWidget{
  @override
  _Numbers_ELState createState() => _Numbers_ELState();
}

class _Numbers_ELState extends State<Numbers_EL> {
  int _currentIndex = 0;
  final List<String> _imagePaths = [
    'assets/num/1.png',
    'assets/num/2.png',
    'assets/num/3.png',
    'assets/num/4.png',
    'assets/num/5.png',
    'assets/num/6.png',
    'assets/num/7.png',
    'assets/num/8.png',
    'assets/num/9.png',
    'assets/num/10.png',
    // Add more image paths as needed
  ];

  FlutterTts flutterTts = FlutterTts();

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
      _speakNumber(_currentIndex);
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      _speakNumber(_currentIndex);
    });
  }

  void _speakNumber(int index) async {
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.2); // Adjust the speech rate here
    await flutterTts.speak('${index + 1}');
  }

  void _speakCurrentNumber() async {
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.2); // Adjust the speech rate here
    await flutterTts.speak('${_currentIndex + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/num/board2.png'),
            fit: BoxFit.cover, // Ensure background covers the entire screen
          ),
        ),
        child: Stack(
          children: [
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
                  Navigator.pop(context);
                },
                color: Colors.white,
                iconSize: 40,
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _speakCurrentNumber,
                child: Icon(Icons.volume_up),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
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
                  right: 0,
                  child: Image.asset(
                    _imagePaths[_currentIndex],
                    fit: BoxFit.contain,
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
                    iconSize: 40,
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
                    iconSize: 40,
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
              fit: BoxFit.contain,
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
                color: Colors.white.withOpacity(0.9),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousImage,
                color: Colors.green,
                iconSize: 50,
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
                color: Colors.white.withOpacity(0.9),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _nextImage,
                color: Colors.green,
                iconSize: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
