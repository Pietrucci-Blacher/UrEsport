import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/screens/register_screen.dart';
import 'package:uresport/core/models/register_request.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('RegisterScreen', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('renders register screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterScreen(authService: mockAuthService),
        ),
      );

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('triggers register event on button press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(mockAuthService),
            child: RegisterScreen(authService: mockAuthService),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'John');
      await tester.enterText(find.byType(TextField).at(1), 'Doe');
      await tester.enterText(find.byType(TextField).at(2), 'johndoe');
      await tester.enterText(find.byType(TextField).at(3), 'john@example.com');
      await tester.enterText(find.byType(TextField).at(4), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(mockAuthService.register(
        RegisterRequest(
          firstName: 'John',
          lastName: 'Doe',
          userName: 'johndoe',
          email: 'john@example.com',
          password: 'password',
        ),
      )).called(1);
    });
  });
}
