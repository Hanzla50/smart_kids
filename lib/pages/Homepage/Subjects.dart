import 'package:flutter/material.dart';

class Subjectspage extends StatelessWidget {
  const Subjectspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Subjects",style: TextStyle(fontSize: 25,color: Colors.white),)
        ),
        );
  }
}