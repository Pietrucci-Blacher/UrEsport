import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uresport/app.dart';

void main() {
  testWidgets('LocaleSwitcher changes locale', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify the initial state
    expect(find.byIcon(Icons.language), findsOneWidget);

    // Tap the floating action button to open the dialog
    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    // Verify the dialog opens with language options
    expect(find.text('Select Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Spanish'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);

    // Select Spanish and verify the app now uses the Spanish locale
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();
    expect(find.text('¡Bienvenido a UrEsport!'), findsOneWidget);

    // Select French and verify the app now uses the French locale
    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenue à UrEsport!'), findsOneWidget);
  });
}
