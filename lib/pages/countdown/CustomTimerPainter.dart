import 'dart:math';

import 'package:flutter/material.dart';

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color1,
    this.color2,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color1, color2;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    LinearGradient gradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        color2,
        color1,
      ],
    );
    Paint paintBack = Paint()
      ..color = backgroundColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Paint paintFront = Paint()
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);
    Paint paintPoint = Paint()
      ..color = Colors.white.withAlpha(0x88)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double progress = animation.value * 1.5 * pi;
    double start = pi * 0.75 + (1 - animation.value) * 1.5 * pi;

    Path path = Path()..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
    canvas.drawShadow(path, Colors.black.withAlpha(120), 16, true);
    canvas.drawPath(path, Paint()..color = Colors.white.withAlpha(245));

    canvas.drawArc(rect, pi * 0.75, pi * 1.5, false, paintBack);
    canvas.drawArc(rect, start, progress, false, paintFront);
    canvas.drawArc(rect, start, 0.005, false, paintPoint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color1 != old.color1 ||
        backgroundColor != old.backgroundColor;
  }
}