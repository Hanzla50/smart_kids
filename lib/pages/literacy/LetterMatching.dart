import 'package:flutter/material.dart';

class LetterMatching extends StatefulWidget {
  @override
  _LetterMatchingState createState() => _LetterMatchingState();
}

class _LetterMatchingState extends State<LetterMatching> {
  Map<String, String> leftItems = {
    'A': '',
    'B': '',
    'C': '',
  };
  Map<String, String> rightItems = {
    'b': 'B',
    'c': 'C',
    'a': 'A',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/game_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 550,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(1),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.brown),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 550,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(1),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.brown),
                onPressed: () {
                  // Handle next functionality here
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Letter Matching',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MadimiOne', // Change font as needed
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: leftItems.keys.map((item) {
                            return DragTarget<String>(
                              onWillAccept: (data) => leftItems[item]!.isEmpty,
                              onAccept: (data) {
                                setState(() {
                                  leftItems[item] = data;
                                });
                              },
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.green,
                                        width: 3.0), // Increased border width
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: candidateData.isNotEmpty
                                        ? [
                                            BoxShadow(
                                                color: Colors.green,
                                                blurRadius: 5)
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      leftItems[item]!,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'arial',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: leftItems.keys.map((item) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.green,
                                    width: 3.0), // Increased border width
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.brown,
                                    fontFamily: 'arial',
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: rightItems.keys.map((item) {
                    return Draggable<String>(
                      data: item,
                      child: _buildDraggableItem(item, Colors.white),
                      feedback: Material(
                        color: Colors.transparent,
                        child: _buildDraggableItem(item, Colors.green),
                      ),
                      childWhenDragging:
                          _buildDraggableItem(item, Colors.green),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    bool allMatched = true;
                    leftItems.forEach((key, value) {
                      if (rightItems[value] != key) {
                        allMatched = false;
                      }
                    });

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(allMatched ? 'Well Done!' : 'Try Again!'),
                          content: Text(allMatched
                              ? 'All items matched correctly.'
                              : 'Some items are incorrect.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // background color
                  ),
                  child: Text(
                    'Check Answers',
                    style: TextStyle(color: Colors.white), // text color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(String item, Color color) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
            color: Colors.green, width: 3.0), // Increased border width
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          item,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontFamily: 'arial',
          ),
        ),
      ),
    );
  }
}
