import 'package:flutter/material.dart';

import 'coloring.dart';

class ImageSelectionScreen extends StatefulWidget {
  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  final List<String> imagePaths = [
    'assets/a.jpg',
    'assets/graphie.jpg',
    'assets/fish.jpg',
    'assets/zoo.jpg',
    'assets/rabbit.png',

  ];

  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Picture'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          final imagePath = imagePaths[index];
          final isSelected = imagePath == selectedImagePath;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedImagePath = imagePath;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ColoringScreen(imagePath: imagePath),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent, // Change color to black
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(imagePath),
            ),
          );
        },
      ),
    );
  }
}
