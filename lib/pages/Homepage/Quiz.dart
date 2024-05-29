import 'package:flutter/material.dart';

class Quizpage extends StatelessWidget {
  const Quizpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Quiz",style: TextStyle(fontSize: 25,color: Colors.white),)
        ),
        );
  }
}