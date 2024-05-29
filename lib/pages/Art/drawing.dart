import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'DrawingPainter.dart';
import 'DrawingPoint.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<Color> availableColors = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown
  ];
  final List<DrawingPoint> userDrawingPoints = [];
  List<DrawingPoint> historyDrawingPoints = [];
  Color selectedColor = Colors.black;
  double selectedWidth = 2.0;
  bool isEraser = false;
  ShapeType selectedShape = ShapeType.freehand;
  DrawingPoint? currentDrawingPoint;

  final GlobalKey _repaintBoundaryKey = GlobalKey();

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

  Future<void> _saveImage() async {
    try {
      final boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(bytes);
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to gallery')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save image')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save image')));
    }
  }

  void _handleEraser(Offset touchPoint) {
    final double eraseRadius = 20.0;
    final List<DrawingPoint> pointsToRemove = [];

    for (var point in userDrawingPoints) {
      for (var offset in point.offsets) {
        if ((offset - touchPoint).distanceSquared < eraseRadius * eraseRadius) {
          pointsToRemove.add(point);
          break;
        }
      }
    }

    setState(() {
      userDrawingPoints.removeWhere((point) => pointsToRemove.contains(point));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    // Color selection bar
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      child: Row(
                        children: availableColors.map((color) {
                          return GestureDetector(
                            onTap: () => setState(() {
                              selectedColor = color;
                              isEraser = false;
                            }),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: color,
                              child: selectedColor == color && !isEraser ? const Icon(Icons.done, color: Colors.white) : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Shape selection bar
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.brush,
                          onPressed: () => setState(() => selectedShape = ShapeType.freehand),
                          color: selectedShape == ShapeType.freehand ? Colors.blue : Colors.grey,
                        ),
                        RoundIconButton(
                          icon: Icons.crop_square,
                          onPressed: () => setState(() => selectedShape = ShapeType.square),
                          color: selectedShape == ShapeType.square ? Colors.blue : Colors.grey,
                        ),
                        RoundIconButton(
                          icon: Icons.circle,
                          onPressed: () => setState(() => selectedShape = ShapeType.circle),
                          color: selectedShape == ShapeType.circle ? Colors.blue : Colors.grey,
                        ),
                        RoundIconButton(
                          icon: Icons.change_history,
                          onPressed: () => setState(() => selectedShape = ShapeType.triangle),
                          color: selectedShape == ShapeType.triangle ? Colors.blue : Colors.grey,
                        ),
                        RoundIconButton(
                          icon: Icons.rectangle,
                          onPressed: () => setState(() => selectedShape = ShapeType.rectangle),
                          color: selectedShape == ShapeType.rectangle ? Colors.blue : Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                // Drawing area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: Container(
                        color: Colors.white, // Ensure a white background
                        child: GestureDetector(
                          onPanStart: (details) {
                            setState(() {
                              currentDrawingPoint = DrawingPoint(
                                id: DateTime.now().microsecondsSinceEpoch,
                                offsets: [details.localPosition],
                                color: isEraser ? Colors.transparent : selectedColor,
                                width: selectedWidth,
                                isEraser: isEraser,
                                shapeType: selectedShape,
                              );
                              if (currentDrawingPoint != null) {
                                if (isEraser) {
                                  _handleEraser(details.localPosition);
                                } else {
                                  userDrawingPoints.add(currentDrawingPoint!);
                                }
                                historyDrawingPoints = List.from(userDrawingPoints);
                              }
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              if (currentDrawingPoint != null) {
                                currentDrawingPoint!.offsets.add(details.localPosition);
                                userDrawingPoints.last = currentDrawingPoint!;
                                historyDrawingPoints = List.from(userDrawingPoints);
                              }
                            });
                          },
                          onPanEnd: (_) => currentDrawingPoint = null,
                          child: CustomPaint(
                            painter: DrawingPainter(drawingPoints: userDrawingPoints),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Toolbar
          Positioned(
            left: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: selectedWidth,
                    onChanged: (value) => setState(() => selectedWidth = value),
                    max: 20,
                    min: 1,
                    label: '${selectedWidth.toInt()}',
                  ),
                ),
                Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.save,
                      onPressed: _saveImage,
                      color: Colors.blue,
                    ),
                    RoundIconButton(
                      icon: Icons.undo,
                      onPressed: () => setState(() {
                        if (userDrawingPoints.isNotEmpty) {
                          historyDrawingPoints.removeLast();
                          userDrawingPoints.clear();
                          userDrawingPoints.addAll(historyDrawingPoints);
                        }
                      }),
                      color: Colors.blue,
                    ),
                    RoundIconButton(
                      icon: Icons.clear,
                      onPressed: () => setState(() {
                        userDrawingPoints.clear();
                        historyDrawingPoints.clear();
                      }),
                      color: Colors.red,
                    ),
                    RoundIconButton(
                      icon: Icons.remove,
                      onPressed: () => setState(() {
                        isEraser = true;
                      }),
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const RoundIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
