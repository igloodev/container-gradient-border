import 'package:flutter/material.dart';

/// A Flutter widget that renders a gradient border around a child widget
/// using [CustomPaint] for pixel-accurate stroke rendering.
///
/// Unlike a nested-container approach, this widget:
/// - Sizes to its [child] automatically — no fixed height/width required
/// - Supports any [Gradient] type: [LinearGradient], [RadialGradient], [SweepGradient]
/// - Draws a true stroke, not a background bleed-through
///
/// Example:
/// ```dart
/// ContainerGradientBorder(
///   borderWidth: 3,
///   borderRadius: 12,
///   gradient: const LinearGradient(
///     colors: [Colors.blue, Colors.purple],
///   ),
///   containerColor: Colors.white,
///   child: const Padding(
///     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
///     child: Text('Hello'),
///   ),
/// )
/// ```
class ContainerGradientBorder extends StatelessWidget {
  /// Creates a gradient-bordered container that wraps [child].
  ///
  /// [borderWidth] must be non-negative.
  const ContainerGradientBorder({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.white, Colors.black],
    ),
    this.borderWidth = 2.0,
    this.borderRadius = 0.0,
    this.containerColor = Colors.transparent,
    this.padding = EdgeInsets.zero,
  }) : assert(borderWidth >= 0, 'borderWidth must be non-negative.');

  /// The widget to display inside the gradient border.
  final Widget child;

  /// The gradient applied to the border stroke.
  ///
  /// Accepts any [Gradient] subtype — [LinearGradient], [RadialGradient],
  /// or [SweepGradient]. Defaults to a white-to-black linear gradient.
  final Gradient gradient;

  /// The thickness of the gradient border in logical pixels.
  ///
  /// Defaults to `2.0`. Must be non-negative.
  final double borderWidth;

  /// The corner radius of the border.
  ///
  /// Defaults to `0.0` (sharp corners).
  final double borderRadius;

  /// The background color of the area inside the border.
  ///
  /// Defaults to [Colors.transparent].
  final Color containerColor;

  /// Padding applied around [child], inside the border.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        gradient: gradient,
        borderWidth: borderWidth,
        borderRadius: borderRadius,
        containerColor: containerColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth).add(padding),
        child: child,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.gradient,
    required this.borderWidth,
    required this.borderRadius,
    required this.containerColor,
  });

  final Gradient gradient;
  final double borderWidth;
  final double borderRadius;
  final Color containerColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0) return;

    final rect = Offset.zero & size;
    final halfBorder = borderWidth / 2;

    // Fill the inner area with containerColor, drawn beneath the border stroke.
    if (containerColor != Colors.transparent) {
      final innerRadius =
          (borderRadius - borderWidth).clamp(0.0, double.infinity);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.deflate(borderWidth),
          Radius.circular(innerRadius),
        ),
        Paint()..color = containerColor,
      );
    }

    // Draw the gradient border stroke centered on the edge.
    // The path is deflated by half the border width so the stroke is fully
    // within the widget bounds (outer edge flush with widget edge).
    final strokeRadius =
        (borderRadius - halfBorder).clamp(0.0, double.infinity);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(halfBorder),
        Radius.circular(strokeRadius),
      ),
      Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.containerColor != containerColor;
}
