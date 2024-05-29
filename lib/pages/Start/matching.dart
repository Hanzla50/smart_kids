import 'package:flutter/material.dart';


class MatchingGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matching Game',
      home: MatchingGameScreen(),
    );
  }
}

class MatchingGameScreen extends StatefulWidget {
  @override
  _MatchingGameScreenState createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  final Map<String, Offset> itemsPosition = {
    'A': Offset(100, 200),
    'B': Offset(200, 200),
    'A_item': Offset(100, 400),
    'B_item': Offset(200, 400),
  };

  final Map<String, String> correctMatches = {
    'A': 'A_item',
    'B': 'B_item',
  };

  Map<String, String> userMatches = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Game'),
      ),
      body: Stack(
        children: [
          for (var entry in itemsPosition.entries)
            DraggableItem(
              label: entry.key,
              initialPosition: entry.value,
              onDragEnd: (details) {
                setState(() {
                  itemsPosition[entry.key] = details.offset;
                  checkMatch(entry.key, details.offset);
                });
              },
            ),
          CustomPaint(
            painter: MatchPainter(userMatches, itemsPosition),
          ),
        ],
      ),
    );
  }

  void checkMatch(String key, Offset position) {
    for (var match in correctMatches.entries) {
      if (match.key == key &&
          (position - itemsPosition[match.value]!).distance < 50) {
        userMatches[key] = match.value;
      } else if (match.value == key &&
          (position - itemsPosition[match.key]!).distance < 50) {
        userMatches[match.key] = key;
      }
    }
  }
}

class DraggableItem extends StatelessWidget {
  final String label;
  final Offset initialPosition;
  final void Function(DraggableDetails) onDragEnd;

  DraggableItem({
    required this.label,
    required this.initialPosition,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: initialPosition.dx,
      top: initialPosition.dy,
      child: Draggable(
        data: label,
        feedback: Material(
          color: Colors.transparent,
          child: Text(
            label,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: onDragEnd,
        child: Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MatchPainter extends CustomPainter {
  final Map<String, String> userMatches;
  final Map<String, Offset> itemsPosition;

  MatchPainter(this.userMatches, this.itemsPosition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    userMatches.forEach((key, value) {
      final p1 = itemsPosition[key]!;
      final p2 = itemsPosition[value]!;
      canvas.drawLine(p1, p2, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
