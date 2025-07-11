import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/features/user/presentation/view/register_view.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_state.dart';
import 'package:quickstock/features/user/presentation/view_model/register_view_model/register_view_model.dart';

class MockRegisterViewModel extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterViewModel {}

void main() {
  late MockRegisterViewModel mockViewModel;

  Widget loadRegisterView() {
    return BlocProvider<RegisterViewModel>.value(
      value: mockViewModel,
      child: MaterialApp(home: RegisterView()),
    );
  }

  setUp(() {
    mockViewModel = MockRegisterViewModel();
    when(() => mockViewModel.state).thenReturn(RegisterState.initial());
  });

  group("do widget test on register view", () {
    testWidgets('should find all widgets : register button and textfields', (
      tester,
    ) async {
      await tester.pumpWidget(loadRegisterView());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ElevatedButton, "Create Account"),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets("should show validation error when fields are empty", (
      tester,
    ) async {
      await tester.pumpWidget(loadRegisterView());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, "Create Account"));
      await tester.pumpAndSettle();

      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets("should enter all fields correctly", (tester) async {
      await tester.pumpWidget(loadRegisterView());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Rahul');
      await tester.enterText(find.byType(TextFormField).at(1), 'Chaudhari');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'rahul@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), '1010101010');
      await tester.enterText(find.byType(TextFormField).at(4), 'Password123');

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Rahul'), findsOneWidget);
      expect(find.text('Chaudhari'), findsOneWidget);
      expect(find.text('rahul@example.com'), findsOneWidget);
      expect(find.text('1010101010'), findsOneWidget);
      expect(find.text('Password123'), findsOneWidget);
    });

    testWidgets(
      "should show Circular Progress Indicator when state is loading",
      (tester) async {
        when(
          () => mockViewModel.state,
        ).thenReturn(RegisterState.initial().copyWith(isLoading: true));

        await tester.pumpWidget(loadRegisterView());
        await tester.pump(Duration(seconds: 4));

        expect(mockViewModel.state.isLoading, true);
      },
    );
  });
}
