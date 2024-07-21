import 'package:flutter/material.dart';

class DashedPainter extends CustomPainter {
  final double strokeWidth;
  final List<double> dashPattern;
  final Color color;
  final Gradient? gradient;
  final Radius radius;
  final StrokeCap strokeCap;
  final EdgeInsets padding;

  DashedPainter({
    this.strokeWidth = 2,
    this.dashPattern = const <double>[3, 1],
    this.color = Colors.black,
    this.gradient,
    this.radius = const Radius.circular(0),
    this.strokeCap = StrokeCap.butt,
    this.padding = EdgeInsets.zero,
  }) {
    assert(dashPattern.isNotEmpty, 'Dash Pattern cannot be empty');
  }

  @override
  void paint(Canvas canvas, Size originalSize) {
    final Size size;
    if (padding == EdgeInsets.zero) {
      size = originalSize;
    } else {
      canvas.translate(padding.left, padding.top);
      size = Size(
        originalSize.width - padding.horizontal,
        originalSize.height - padding.vertical,
      );
    }

    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    if (gradient != null) {
      final rect = Offset.zero & size;
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    Path path = _getPath(size);
    canvas.drawPath(dashPath(path), paint);
  }

  Path _getPath(Size size) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
          radius,
        ),
      );
  }

  Path dashPath(Path source) {
    final Path path = Path();
    final double dashWidth = dashPattern[0];
    final double dashSpace = dashPattern[1];
    double distance = 0.0;
    bool draw = true;

    source.computeMetrics().forEach((metric) {
      final pathMetrics = metric;
      double length = pathMetrics.length;
      while (distance < length) {
        final interval = draw ? dashWidth : dashSpace;
        if (draw) {
          final start = distance;
          final end =
              (distance + interval) < length ? distance + interval : length;
          path.addPath(
            pathMetrics.extractPath(start, end),
            Offset.zero,
          );
        }
        distance += interval;
        draw = !draw;
      }
    });

    return path;
  }

  @override
  bool shouldRepaint(DashedPainter oldDelegate) {
    return oldDelegate.strokeWidth != this.strokeWidth ||
        oldDelegate.color != this.color ||
        oldDelegate.dashPattern != this.dashPattern ||
        oldDelegate.padding != this.padding;
  }
}
