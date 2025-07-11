import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/features/user/presentation/view/login_view.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:quickstock/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class MockLoginView extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginView mockLoginView;

  Widget loadLoginView() {
    return BlocProvider<LoginViewModel>.value(
      value: mockLoginView,
      child: MaterialApp(home: LoginView()),
    );
  }

  setUp(() {
    mockLoginView = MockLoginView();
    when(() => mockLoginView.state).thenReturn(LoginState.initial());
  });

  group("Do Widget Test for Login Vew ", () {
    testWidgets("should find login button and textfields", (tester) async {
      await tester.pumpWidget(loadLoginView());
      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should show validation error when fields are empty', (
      tester,
    ) async {
      await tester.pumpWidget(loadLoginView());
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.tap(find.widgetWithText(ElevatedButton, "Login"));
      await tester.pumpAndSettle();

      expect(find.text('Phone Number is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should enter phone number and password', (tester) async {
      await tester.pumpWidget(loadLoginView());
      await tester.pumpAndSettle(const Duration(seconds: 4));

      await tester.enterText(find.byType(TextFormField).at(0), '1010101010');
      await tester.enterText(find.byType(TextFormField).at(1), 'Mobile@123');

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('1010101010'), findsOneWidget);
      expect(find.text('Mobile@123'), findsOneWidget);
    });

    testWidgets('should simulate successful login', (tester) async {
      when(
        () => mockLoginView.state,
      ).thenReturn(LoginState.initial().copyWith(isSuccess: true));

      await tester.pumpWidget(loadLoginView());
      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(mockLoginView.state.isSuccess, true);
    });

    testWidgets(
      'should show Circular Progress Indicator when state is loading',
      (tester) async {
        when(
          () => mockLoginView.state,
        ).thenReturn(LoginState.initial().copyWith(isLoading: true));

        await tester.pumpWidget(loadLoginView());
        await tester.pump(const Duration(seconds: 4));
        
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );
  });
}
