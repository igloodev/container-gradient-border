import 'package:container_gradient_border/container_gradient_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('dashed border', () {
    testWidgets('renders with a dashPattern', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          borderRadius: 12,
          dashPattern: [6, 4],
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a single-entry dashPattern renders (equal dash/gap)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          dashPattern: [5],
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('an empty dashPattern falls back to a solid stroke', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          dashPattern: <double>[],
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    // Regression: a non-advancing pattern must not infinite-loop in paint().
    testWidgets('an all-zero dashPattern does not hang', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          dashPattern: [0, 0],
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a negative dashPattern entry does not hang', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          dashPattern: [-5, 4],
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(tester.takeException(), isNull);
    });
  });

  group('glow', () {
    testWidgets('renders with a glowColor', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          glowColor: Colors.cyan,
          glowBlurRadius: 12,
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders glow + dashed together', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 4,
          borderRadius: 16,
          dashPattern: [8, 4],
          glowColor: Colors.purple,
          child: SizedBox(width: 100, height: 100),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    test('assert fires for negative glowBlurRadius', () {
      expect(
        () => ContainerGradientBorder(
          glowBlurRadius: -1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });
  });

  group('animated gradient', () {
    testWidgets('animates without error and advances frames', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 4,
          borderRadius: 20,
          animate: true,
          animationDuration: Duration(milliseconds: 400),
          gradient:
              SweepGradient(colors: [Colors.red, Colors.blue, Colors.red]),
          child: SizedBox(width: 100, height: 100),
        ),
      ));
      // A repeating animation never settles — pump fixed frames instead.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('toggling animate off disposes the controller cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          animate: true,
          child: SizedBox(width: 80, height: 80),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          animate: false,
          child: SizedBox(width: 80, height: 80),
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('disposes cleanly when removed mid-animation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          animate: true,
          child: SizedBox(width: 80, height: 80),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(_wrap(const SizedBox()));
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('backward compatible: no new params behaves as before', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(
      const ContainerGradientBorder(
        borderWidth: 2,
        child: Text('ok'),
      ),
    ));
    expect(find.text('ok'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
