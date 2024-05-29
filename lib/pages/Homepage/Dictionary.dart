import 'package:flutter/material.dart';

class Dictionarypage extends StatelessWidget {
  const Dictionarypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Dictionary",style: TextStyle(fontSize: 25,color: Colors.white),)
        ),
        );
  }
}