import 'dart:ui';

import 'package:flutter/material.dart';

class LocationPainter extends CustomPainter {
  double x, y;
  Color color;
  LocationPainter(
      {required this.x, required this.y, required Color this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 10;
    //list of points
    var points = [
      Offset(x, y),
    ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void move(double x, double y) {
    this.y = 580 - y * 50;
    this.x = 217 - x * 50;
  }
}
