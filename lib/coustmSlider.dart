import 'package:flutter/material.dart';

class CustomSliderThumbShape extends SliderComponentShape {
  const CustomSliderThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.square(50); // adjust this value to change the thumb size
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double radius = sizeWithOverflow.width / 2;
    final double strokeWidth = 2;
    final double circleRadius = radius - strokeWidth / 2;

    canvas.drawCircle(center, circleRadius, paint);

    // Draw a border around the thumb
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, borderPaint);
  }
}
