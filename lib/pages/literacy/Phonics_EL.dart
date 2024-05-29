import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Phonics_EL extends StatefulWidget {
  @override
  _Phonics_ELState createState() => _Phonics_ELState();
}

class _Phonics_ELState extends State<Phonics_EL> {
  int _currentIndex = 0;
  final List<String> _imagePaths = [
    'assets/phonics/af.png',
    'assets/phonics/bf.png',
    'assets/phonics/cf.png',
    'assets/phonics/df.png',
    'assets/phonics/ef.png',
    'assets/phonics/ff.png',
    'assets/phonics/gf.png',
    'assets/phonics/hf.png',
    'assets/phonics/if.png',
    'assets/phonics/jf.png',
    'assets/phonics/kf.png',
    'assets/phonics/lf.png',
    'assets/phonics/mf.png',
    'assets/phonics/nf.png',
    'assets/phonics/of.png',
    'assets/phonics/pf.png',
    'assets/phonics/qf.png',
    'assets/phonics/rf.png',
    'assets/phonics/sf.png',
    'assets/phonics/tf.png',
    'assets/phonics/uf.png',
    'assets/phonics/vf.png',
    'assets/phonics/wf.png',
    'assets/phonics/xf.png',
    'assets/phonics/yf.png',
    'assets/phonics/zf.png',

    
    // Add more image paths as needed
  ];

  final List<String> _phonicsTexts = [
    'a for apple, a, p , p , l , e',
    'b for bus, b , u , s',
    'c for car, c, a , r',
    'd for dolphin, d, o , l, p, h, i, n',
    'e for elephant, e, l , e, p, h, a, n, t',
    'f for flower, f, l , o, w, e, r',
    'g for giraffe, g, i , r, a, f,f , e',
    'h for hat, h, a , t',
    'i for ice cream, i, c , e, c, r, e, a, m',
    'j for jellyfish, j, e , l, l,y, f, i, s, h',
    'k for kite, k, i , t, e',
    'l for lion, l, i , o, n',
    'm for moon, m, o , o, n',
    'n for nest, n, e , s, t',
    'o for owl, o, w , l',
    'p for plant, p, l ,a, n, t ',
    'q for queen, q, u , e, e, n ',
    'r for rose, r, o , s, e',
    's for sun, s, u, n',
    't for tree, t, r, e, e',
    'u for unicorn, u, n ,i, c, o, r, n ',
    'v for van, v, a , n ',
    'w for watermelon, w, a , t, e, r, m , e, l, o, n ',
    'x for xylophone, x, y ,l, o, p, h, o, n, e',
    'y for yak, y, a , k, ',
    'z for zebra, z, e, b, r, a',

    
    // Add more phonics texts as needed
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
      _speakCurrentPhonics();
    });
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      _speakCurrentPhonics();
    });
  }

  Future<void> _speakCurrentPhonics() async {
    await flutterTts.setVoice({"name": "en-us-x-sfg#female_2-local"});
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.2); // Adjust the speech rate here
    await flutterTts.speak(_phonicsTexts[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/phonics/phonics_board.png'),
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
              onPressed: _speakCurrentPhonics,
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
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Phonics_EL(),
  ));
}
