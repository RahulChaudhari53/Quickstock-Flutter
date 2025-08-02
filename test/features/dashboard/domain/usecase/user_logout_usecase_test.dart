import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/app/shared_pref/token_shared_pref.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/dashboard/domain/usecase/user_logout_usecase.dart';

class MockTokenSharedPref extends Mock implements TokenSharedPref {}

void main() {
  late LogoutUseCase usecase;
  late MockTokenSharedPref mockTokenSharedPref;

  setUp(() {
    mockTokenSharedPref = MockTokenSharedPref();
    usecase = LogoutUseCase(tokenSharedPref: mockTokenSharedPref);
  });

  test('should fail when clearToken fails', () async {
    final failure = SharedPreferenceFailure(message: 'Clear failed');
    when(
      () => mockTokenSharedPref.clearToken(),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase();

    expect(result, equals(Left(failure)));
    verify(() => mockTokenSharedPref.clearToken()).called(1);
    verifyNoMoreInteractions(mockTokenSharedPref);
  });
}
