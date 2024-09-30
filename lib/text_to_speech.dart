import 'package:flutter_tts/flutter_tts.dart';

class text_to_speech {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.2);
    await _flutterTts.speak(text);
  }

  // Add this method to stop the speech
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}