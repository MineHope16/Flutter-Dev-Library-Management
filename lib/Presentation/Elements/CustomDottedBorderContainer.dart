import 'package:flutter/material.dart';

/// Dotted Border Container Widget
class MyDottedContainer extends StatelessWidget {
  final Widget? child;
  final double strokeWidth;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;

  const MyDottedContainer({
    super.key,
    this.child,
    this.borderRadius,
    this.backgroundColor,
    this.strokeWidth = 2,
    this.color = Colors.black,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
        isCircle: borderRadius == null && width == height,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Painter for Dotted Border
class _DottedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final BorderRadiusGeometry? borderRadius;
  final bool isCircle;

  _DottedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    this.borderRadius,
    this.isCircle = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    Path path;

    if (isCircle) {
      // Circle path
      path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    } else if (borderRadius != null) {
      // Rounded rectangle path
      path = Path()
        ..addRRect(borderRadius!.resolve(TextDirection.ltr).toRRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ));
    } else {
      // Normal rectangle
      path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
