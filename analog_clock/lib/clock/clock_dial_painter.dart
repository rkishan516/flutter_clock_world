import 'dart:math';
import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter {
  final Paint tickPaint;
  final double tickLength = 10.0;
  final double tickWidth = 3.0;
  final double angle = 2 * pi / 60;

  ClockDialPainter(BuildContext context) : tickPaint = new Paint() {
    tickPaint.color = Theme.of(context).brightness == Brightness.light
        ? Color(0xFF0A21B4)
        : Colors.white;
    tickPaint.strokeWidth = tickWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var radius = (size.width) / 2;
    canvas.save();

    // drawing
    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      if (i % 5 == 0) {
        canvas.drawLine(new Offset(0.0, -radius),
            new Offset(0.0, -radius + 2.5 * tickLength), tickPaint);
      } else {
        canvas.drawLine(new Offset(0.0, -radius),
            new Offset(0.0, -radius + tickLength), tickPaint);
      }
      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
