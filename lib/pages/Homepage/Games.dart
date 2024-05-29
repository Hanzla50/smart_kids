import 'package:flutter/material.dart';

class Gamespage extends StatelessWidget {
  const Gamespage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Games",style: TextStyle(fontSize: 25,color: Colors.white),)
        ),
        );
  }
}