import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/screens/reset_password_screen.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAuthService extends Mock implements IAuthService {}

void main() {
  group('ResetPasswordScreen', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('renders reset password screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResetPasswordScreen(authService: mockAuthService),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Request Password Reset'), findsOneWidget);
    });

    testWidgets('triggers password reset request on button press',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(mockAuthService),
            child: ResetPasswordScreen(authService: mockAuthService),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(mockAuthService.requestPasswordReset('test@example.com'))
          .called(1);
    });
  });
}
