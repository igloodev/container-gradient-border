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
        const EdgeInsets.all(borderWidth).add(userPadding),
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

      // borderWidth:0 → no CustomPaint; widget returns Padding(userPadding) directly.
      final paddingWidget = tester.widget<Padding>(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(Padding),
        ),
      );
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

    testWidgets('borderWidth greater than borderRadius clamps inner radius to 0',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 20,
          borderRadius: 8, // borderWidth > borderRadius → inner radius clamped to 0
          child: SizedBox(width: 100, height: 100),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('borderWidth equal to borderRadius renders without error',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 12,
          borderRadius: 12, // inner radius exactly 0
          child: SizedBox(width: 100, height: 100),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('borderWidth 0 with zero padding returns child directly',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 0,
          // padding defaults to EdgeInsets.zero
          child: SizedBox(width: 50, height: 50),
        ),
      ));
      // borderWidth:0 + padding:zero → child returned as-is, no Padding wrapper.
      expect(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(Padding),
        ),
        findsNothing,
      );
    });

    testWidgets('asymmetric padding is combined correctly with borderWidth',
        (tester) async {
      const borderWidth = 3.0;
      const userPadding = EdgeInsets.only(left: 16, top: 8);

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: borderWidth,
          padding: userPadding,
          child: SizedBox(width: 80, height: 40),
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
        const EdgeInsets.all(borderWidth).add(userPadding),
      );
    });

    testWidgets('rebuilds correctly when containerColor changes', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          containerColor: Colors.white,
          child: SizedBox(width: 80, height: 40),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          containerColor: Colors.black,
          child: SizedBox(width: 80, height: 40),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('rebuilds correctly when borderRadius changes', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderRadius: 4,
          child: SizedBox(width: 80, height: 40),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);

      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderRadius: 20,
          child: SizedBox(width: 80, height: 40),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('borderWidth 0 does not crash (painter early-exit path)',
        (tester) async {
      // When borderWidth <= 0 the painter returns early, skipping both the
      // fill and stroke — including containerColor. Widget should still render.
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 0,
          borderRadius: 12,
          containerColor: Colors.white,
          child: SizedBox(width: 100, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('very large borderWidth does not crash', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 100,
          child: SizedBox(width: 50, height: 50),
        ),
      ));
      expect(find.byType(ContainerGradientBorder), findsOneWidget);
    });

    testWidgets('borderWidth 0 skips CustomPaint entirely', (tester) async {
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 0,
          child: SizedBox(width: 60, height: 30),
        ),
      ));
      // No CustomPaint should exist as a descendant when borderWidth is 0.
      expect(
        find.descendant(
          of: find.byType(ContainerGradientBorder),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    testWidgets(
        'fully-transparent containerColor with non-zero alpha is skipped',
        (tester) async {
      // Color(0x00FFFFFF) has alpha=0 — fill should be skipped like transparent.
      await tester.pumpWidget(_wrap(
        const ContainerGradientBorder(
          borderWidth: 3,
          containerColor: Color(0x00FFFFFF),
          child: SizedBox(width: 80, height: 40),
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

    test('assert fires for negative borderRadius', () {
      expect(
        () => ContainerGradientBorder(
          borderRadius: -1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });
  });
}
