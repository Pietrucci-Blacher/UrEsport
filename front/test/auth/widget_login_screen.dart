import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/screens/login_screen.dart';
import 'package:uresport/core/models/login_request.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('LoginScreen', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('renders login screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(authService: mockAuthService),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text("Don't have an account? Register"), findsOneWidget);
    });

    testWidgets('triggers login event on button press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(mockAuthService),
            child: LoginScreen(authService: mockAuthService),
          ),
        ),
      );

      await tester.enterText(
          find.byType(TextField).at(0), 'test.dart@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(mockAuthService.login(
        LoginRequest(email: 'test.dart@example.com', password: 'password'),
      )).called(1);
    });
  });
}
