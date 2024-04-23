import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uresport/home/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen has correct text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeScreen(),
    ));

    expect(find.text('Welcome to the Home Screen!'), findsOneWidget);
  });
}
