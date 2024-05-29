import 'package:flutter/material.dart';

class Artpage extends StatelessWidget {
  const Artpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Art",style: TextStyle(fontSize: 25,color: Colors.white),)
        ),
        );
  }
}