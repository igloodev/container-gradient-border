import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A Flutter widget that renders a gradient border around a child widget
/// using [CustomPaint] for pixel-accurate stroke rendering.
///
/// Unlike a nested-container approach, this widget:
/// - Sizes to its [child] automatically — no fixed height/width required
/// - Supports any [Gradient] type: [LinearGradient], [RadialGradient], [SweepGradient]
/// - Draws a true stroke, not a background bleed-through
/// - Optionally renders a [dashPattern] dashed stroke, an outer [glowColor]
///   glow, and an [animate]d (continuously rotating) gradient
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
class ContainerGradientBorder extends StatefulWidget {
  /// Creates a gradient-bordered container that wraps [child].
  ///
  /// [borderWidth] and [borderRadius] must be non-negative.
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
    this.dashPattern,
    this.glowColor,
    this.glowBlurRadius = 8.0,
    this.animate = false,
    this.animationDuration = const Duration(seconds: 3),
  })  : assert(borderWidth >= 0, 'borderWidth must be non-negative.'),
        assert(borderRadius >= 0, 'borderRadius must be non-negative.'),
        assert(glowBlurRadius >= 0, 'glowBlurRadius must be non-negative.');

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

  /// Dash pattern for the stroke as `[dashLength, gapLength, ...]` in logical
  /// pixels (e.g. `[6, 4]`).
  ///
  /// When null (the default) the stroke is solid. Even-indexed segments are
  /// drawn, odd-indexed segments are gaps; the pattern repeats around the
  /// border.
  final List<double>? dashPattern;

  /// Color of an outer glow drawn behind the stroke.
  ///
  /// When null (the default) no glow is drawn. The glow follows the same
  /// shape and [dashPattern] as the stroke, blurred by [glowBlurRadius].
  final Color? glowColor;

  /// Blur radius of the [glowColor] glow, in logical pixels. Defaults to `8.0`.
  final double glowBlurRadius;

  /// When true, the [gradient] rotates continuously for an animated/shimmer
  /// border. Defaults to `false` (static).
  ///
  /// Most striking with a [SweepGradient]. Any existing
  /// [Gradient.transform] is replaced by the animation while active.
  final bool animate;

  /// Duration of one full rotation when [animate] is true. Defaults to 3s.
  final Duration animationDuration;

  @override
  State<ContainerGradientBorder> createState() =>
      _ContainerGradientBorderState();
}

class _ContainerGradientBorderState extends State<ContainerGradientBorder>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) _start();
  }

  void _start() {
    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..repeat();
  }

  @override
  void didUpdateWidget(covariant ContainerGradientBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _start();
      } else {
        _controller?.dispose();
        _controller = null;
      }
    } else if (widget.animate &&
        widget.animationDuration != oldWidget.animationDuration) {
      _controller!
        ..duration = widget.animationDuration
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _GradientBorderPainter _painter(double rotation) => _GradientBorderPainter(
        gradient: widget.gradient,
        borderWidth: widget.borderWidth,
        borderRadius: widget.borderRadius,
        containerColor: widget.containerColor,
        dashPattern: widget.dashPattern,
        glowColor: widget.glowColor,
        glowBlurRadius: widget.glowBlurRadius,
        rotation: rotation,
      );

  @override
  Widget build(BuildContext context) {
    // Skip CustomPaint entirely when there is no border to draw.
    if (widget.borderWidth == 0) {
      return widget.padding == EdgeInsets.zero
          ? widget.child
          : Padding(padding: widget.padding, child: widget.child);
    }

    final Widget inner = Padding(
      padding: EdgeInsets.all(widget.borderWidth).add(widget.padding),
      child: widget.child,
    );

    if (_controller == null) {
      return CustomPaint(painter: _painter(0), child: inner);
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (BuildContext context, Widget? child) => CustomPaint(
        painter: _painter(_controller!.value * 2 * math.pi),
        child: child,
      ),
      child: inner,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.gradient,
    required this.borderWidth,
    required this.borderRadius,
    required this.containerColor,
    required this.dashPattern,
    required this.glowColor,
    required this.glowBlurRadius,
    required this.rotation,
  });

  final Gradient gradient;
  final double borderWidth;
  final double borderRadius;
  final Color containerColor;
  final List<double>? dashPattern;
  final Color? glowColor;
  final double glowBlurRadius;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0) return;

    final rect = Offset.zero & size;
    final halfBorder = borderWidth / 2;

    // Fill the inner area with containerColor, drawn beneath the border stroke.
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

    // The stroke path, centered on the edge so it stays within the bounds.
    final strokeRadius =
        (borderRadius - halfBorder).clamp(0.0, double.infinity);
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(halfBorder),
      Radius.circular(strokeRadius),
    );

    final Gradient effective =
        rotation == 0 ? gradient : _rotated(gradient, rotation);
    final shader = effective.createShader(rect);

    // Optional glow behind the stroke.
    if (glowColor != null && glowBlurRadius > 0) {
      _drawStroke(
        canvas,
        rrect,
        Paint()
          ..color = glowColor!
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlurRadius)
          ..isAntiAlias = true,
      );
    }

    _drawStroke(
      canvas,
      rrect,
      Paint()
        ..shader = shader
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true,
    );
  }

  void _drawStroke(Canvas canvas, RRect rrect, Paint paint) {
    final pattern = dashPattern;
    if (pattern == null || pattern.isEmpty) {
      canvas.drawRRect(rrect, paint);
      return;
    }
    canvas.drawPath(_dashed(Path()..addRRect(rrect), pattern), paint);
  }

  /// Returns a dashed copy of [source] following [pattern] (`[dash, gap, ...]`).
  ///
  /// Negative entries are treated as `0`. A pattern that can never advance
  /// (every entry `<= 0`) would loop forever, so it falls back to a solid
  /// stroke.
  static Path _dashed(Path source, List<double> pattern) {
    double cycle = 0;
    for (final d in pattern) {
      if (d > 0) cycle += d;
    }
    if (cycle <= 0) return source; // no positive segment → solid fallback.

    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      int index = 0;
      while (distance < metric.length) {
        final double raw = pattern[index % pattern.length];
        final double len = raw > 0 ? raw : 0.0; // clamp negatives to 0.
        if (index.isEven && len > 0) {
          dest.addPath(
            metric.extractPath(
              distance,
              (distance + len).clamp(0.0, metric.length),
            ),
            Offset.zero,
          );
        }
        distance += len; // each full cycle advances by `cycle` (> 0).
        index++;
      }
    }
    return dest;
  }

  /// Re-creates [g] with a [GradientRotation] of [radians]. Handles the three
  /// standard gradient types; other subtypes are returned unchanged.
  static Gradient _rotated(Gradient g, double radians) {
    final transform = GradientRotation(radians);
    if (g is LinearGradient) {
      return LinearGradient(
        colors: g.colors,
        stops: g.stops,
        begin: g.begin,
        end: g.end,
        tileMode: g.tileMode,
        transform: transform,
      );
    }
    if (g is RadialGradient) {
      return RadialGradient(
        colors: g.colors,
        stops: g.stops,
        center: g.center,
        radius: g.radius,
        tileMode: g.tileMode,
        focal: g.focal,
        focalRadius: g.focalRadius,
        transform: transform,
      );
    }
    if (g is SweepGradient) {
      return SweepGradient(
        colors: g.colors,
        stops: g.stops,
        center: g.center,
        startAngle: g.startAngle,
        endAngle: g.endAngle,
        tileMode: g.tileMode,
        transform: transform,
      );
    }
    return g;
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.containerColor != containerColor ||
      oldDelegate.dashPattern != dashPattern ||
      oldDelegate.glowColor != glowColor ||
      oldDelegate.glowBlurRadius != glowBlurRadius ||
      oldDelegate.rotation != rotation;
}
