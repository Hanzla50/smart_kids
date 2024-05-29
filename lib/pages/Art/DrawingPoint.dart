import 'package:flutter/material.dart';

enum ShapeType { freehand, square, circle, triangle, rectangle }

class DrawingPoint {
  final int id;
  final List<Offset> offsets;
  final Color color;
  final double width;
  final bool isEraser;
  final ShapeType shapeType;

  DrawingPoint({
    required this.id,
    required this.offsets,
    required this.color,
    required this.width,
    required this.isEraser,
    required this.shapeType,
  });
}
