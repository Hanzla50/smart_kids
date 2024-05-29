import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'DrawingPainter.dart';
import 'DrawingPoint.dart';

class ColoringScreen extends StatefulWidget {
  final String? imagePath;

  const ColoringScreen({Key? key, this.imagePath}) : super(key: key);

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
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
  DrawingPoint? currentDrawingPoint;

  double _minScale = 1.0;
  double _maxScale = 4.0;
  late TransformationController _transformationController;
  TapDownDetails _doubleTapDetails = TapDownDetails();
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
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
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails.localPosition;
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale != _maxScale) {
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * (_maxScale - 1), -position.dy * (_maxScale - 1))
        ..scale(_maxScale);
    } else {
      _transformationController.value = Matrix4.identity();
    }
  }

  Future<void> _saveImage() async {
    try {
      final boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      await ImageGallerySaver.saveImage(bytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to gallery')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save image')));
    }
  }

  void _handleEraser(Offset touchPoint) {
    final double eraseRadius = 20.0; // Adjust the erase radius as needed
    final List<DrawingPoint> pointsToRemove = [];

    for (var point in userDrawingPoints) {
      for (var offset in point.offsets) {
        if ((offset - touchPoint).distanceSquared < eraseRadius * eraseRadius) {
          pointsToRemove.add(point);
          break; // Break once we find a point within the erase radius
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
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: Stack(
                        children: [
                          if (widget.imagePath != null)
                            Positioned.fill(
                              child: GestureDetector(
                                onDoubleTapDown: (details) => _doubleTapDetails = details,
                                onDoubleTap: _handleDoubleTap,
                                child: InteractiveViewer(
                                  transformationController: _transformationController,
                                  minScale: _minScale,
                                  maxScale: _maxScale,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(widget.imagePath!),
                                        fit: BoxFit.contain, // Ensure the full image is shown
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                currentDrawingPoint = DrawingPoint(
                                  id: DateTime.now().microsecondsSinceEpoch,
                                  offsets: [details.localPosition],
                                  color: isEraser ? Colors.transparent : selectedColor,
                                  width: selectedWidth,
                                  isEraser: isEraser, shapeType: ShapeType.freehand,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

