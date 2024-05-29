import 'package:flutter/material.dart';
import 'DrawingPoint.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in drawingPoints) {
      final paint = Paint()
        ..color = point.isEraser ? Colors.transparent : point.color
        ..strokeWidth = point.width
        ..strokeCap = StrokeCap.round;

      if (point.shapeType == ShapeType.freehand) {
        for (int i = 0; i < point.offsets.length - 1; i++) {
          if (point.offsets[i] != null && point.offsets[i + 1] != null) {
            canvas.drawLine(point.offsets[i], point.offsets[i + 1], paint);
          }
        }
      } else {
        _drawShape(canvas, point, paint);
      }
    }
  }

  void _drawShape(Canvas canvas, DrawingPoint point, Paint paint) {
    final start = point.offsets.first;
    final end = point.offsets.last;

    switch (point.shapeType) {
      case ShapeType.square:
        final size = (end - start).distance;
        final rect = Rect.fromCenter(center: start, width: size, height: size);
        canvas.drawRect(rect, paint);
        break;
      case ShapeType.circle:
        final radius = (end - start).distance / 2;
        canvas.drawCircle(start, radius, paint);
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..lineTo(end.dx, end.dy)
          ..lineTo(2 * start.dx - end.dx, end.dy)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.rectangle:
        final rect = Rect.fromPoints(start, end);
        canvas.drawRect(rect, paint);
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
