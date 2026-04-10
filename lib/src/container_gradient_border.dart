import 'package:flutter/material.dart';

/// A Flutter widget that renders a gradient border around a child widget
/// using [CustomPaint] for pixel-accurate stroke rendering.
///
/// Unlike a nested-container approach, this widget:
/// - Sizes to its [child] automatically — no fixed height/width required
/// - Supports any [Gradient] type: [LinearGradient], [RadialGradient], [SweepGradient]
/// - Draws a true stroke, not a background bleed-through
///
/// The border is painted as a background layer (via [CustomPaint.painter]).
/// If [child] has its own opaque background it will cover [containerColor],
/// but the gradient stroke on the outer edge remains visible.
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
  /// [borderWidth] must be non-negative. [borderRadius] must be non-negative.
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
  })  : assert(borderWidth >= 0, 'borderWidth must be non-negative.'),
        assert(borderRadius >= 0, 'borderRadius must be non-negative.');

  /// The widget to display inside the gradient border.
  final Widget child;

  /// The gradient applied to the border stroke.
  ///
  /// Accepts any [Gradient] subtype — [LinearGradient], [RadialGradient],
  /// or [SweepGradient]. Defaults to a white-to-black linear gradient.
  ///
  /// Note: [Gradient] does not implement value equality, so two structurally
  /// identical gradients are not considered equal. This means the painter will
  /// repaint whenever the widget rebuilds with a new [Gradient] instance —
  /// a known Flutter limitation. To avoid unnecessary repaints, cache the
  /// gradient instance or use `const`.
  final Gradient gradient;

  /// The thickness of the gradient border in logical pixels.
  ///
  /// Must be non-negative. When set to `0`, [CustomPaint] is skipped entirely
  /// and [containerColor] has no effect — only [padding] and [child] are used.
  ///
  /// Defaults to `2.0`.
  final double borderWidth;

  /// The corner radius of the border.
  ///
  /// Must be non-negative. Defaults to `0.0` (sharp corners).
  /// When [borderWidth] exceeds [borderRadius], the inner fill radius is
  /// clamped to `0.0` automatically.
  final double borderRadius;

  /// The background color of the area inside the border.
  ///
  /// Skipped when fully transparent (alpha == 0) or when [borderWidth] is `0`.
  /// Defaults to [Colors.transparent].
  final Color containerColor;

  /// Padding applied around [child], inside the border.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // Skip CustomPaint entirely when there is no border to draw.
    if (borderWidth == 0) {
      return padding == EdgeInsets.zero
          ? child
          : Padding(padding: padding, child: child);
    }
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
    // Use alpha check instead of identity comparison so any fully-transparent
    // color (e.g. Color(0x00FFFFFF)) is correctly skipped.
    if (containerColor.a != 0) {
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
  // NOTE: Gradient does not implement value equality, so this returns true
  // whenever a new Gradient instance is passed — even if structurally identical.
  // This is a Flutter framework limitation. Use const or cached gradients to
  // prevent unnecessary repaints.
  bool shouldRepaint(_GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.containerColor != containerColor;
}
