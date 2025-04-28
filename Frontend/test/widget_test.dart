// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusease/main.dart';

void main() {
  testWidgets('FocusEase app loads and shows a loading indicator',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FocusEaseApp());

    // Verify that while loading, it shows a CircularProgressIndicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let FutureBuilder complete
    await tester.pumpAndSettle();

    // After loading, it should either find LoginScreen or TasksScreen
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Scaffold,
      ),
      findsWidgets,
    );
  });
}
