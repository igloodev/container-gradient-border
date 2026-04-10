import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:container_gradient_border/container_gradient_border.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('ContainerGradientBorder', () {
    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          child: Text('hello'),
        ),
      ));
      expect(find.text('hello'), findsOneWidget);
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('renders with LinearGradient', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
          borderWidth: 4,
          child: SizedBox(width: 100, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('renders with RadialGradient', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          gradient: RadialGradient(colors: [Colors.red, Colors.orange]),
          borderWidth: 3,
          borderRadius: 8,
          child: SizedBox(width: 80, height: 80),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('renders with SweepGradient', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          gradient: SweepGradient(colors: [Colors.pink, Colors.purple, Colors.pink]),
          borderWidth: 5,
          borderRadius: 50,
          child: SizedBox(width: 100, height: 100),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('renders with containerColor', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          containerColor: Colors.white,
          borderWidth: 3,
          borderRadius: 12,
          child: SizedBox(width: 120, height: 60),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('renders with borderWidth 0 (no border)', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 0,
          child: Text('no border'),
        ),
      ));
      expect(find.text('no border'), findsOneWidget);
    });

    testWidgets('renders with borderRadius 0 (sharp corners)', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 2,
          borderRadius: 0,
          child: SizedBox(width: 100, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('renders with large borderRadius (pill shape)', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 2,
          borderRadius: 999,
          gradient: LinearGradient(colors: [Colors.cyan, Colors.teal]),
          child: SizedBox(width: 160, height: 48),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('applies padding around child', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 2,
          padding: EdgeInsets.all(16),
          child: Text('padded'),
        ),
      ));
      expect(find.text('padded'), findsOneWidget);
      // Padding widget should exist in tree (borderWidth padding + user padding)
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('child is rendered inside CustomPaint', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          child: Text('inside'),
        ),
      ));
      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(customPaint.child, isA<Padding>());
    });

    testWidgets('padding combines borderWidth and user padding', (tester) async {
      const borderWidth = 4.0;
      const userPadding = EdgeInsets.all(8.0);

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: borderWidth,
          padding: userPadding,
          child: SizedBox(width: 50, height: 50),
        ),
      ));

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(CustomPaint),
        ),
      );
      final paddingWidget = customPaint.child as Padding;
      expect(
        paddingWidget.padding,
        EdgeInsets.all(borderWidth).add(userPadding),
      );
    });

    testWidgets('borderWidth 0 applies only user padding', (tester) async {
      const userPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 0,
          padding: userPadding,
          child: SizedBox(width: 50, height: 50),
        ),
      ));

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(CustomPaint),
        ),
      );
      final paddingWidget = customPaint.child as Padding;
      expect(paddingWidget.padding, userPadding);
    });

    testWidgets('painter is set on CustomPaint', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          child: SizedBox(width: 80, height: 40),
        ),
      ));

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(customPaint.painter, isNotNull);
    });

    testWidgets('rebuilds correctly when gradient changes', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
          child: SizedBox(width: 100, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
          child: SizedBox(width: 100, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('rebuilds correctly when borderWidth changes', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 2,
          child: SizedBox(width: 100, height: 50),
        ),
      ));

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 8,
          child: SizedBox(width: 100, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    test('assert fires for negative borderWidth', () {
      expect(
        () => ContainerGradientBorder(
          borderWidth: -1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });
  });
}
