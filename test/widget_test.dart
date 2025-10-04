// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animationtask/main.dart';

void main() {
  testWidgets('Animation screen renders and starts on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Click Me'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsNWidgets(2));

    await tester.tap(find.text('Click Me'));
    await tester.pump();

    // Let the animation advance a little to ensure no exceptions occur
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.any(find.byType(AlignTransition)), isTrue);
  });
}
