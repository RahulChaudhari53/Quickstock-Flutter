import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/usecase/update_password_usecase.dart';

import 'profile_repository.mock.dart';

void main() {
  late UpdatePasswordUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdatePasswordUsecase(mockRepository);
  });

  const testParams = UpdatePasswordParams(
    oldPassword: 'oldPassword@123',
    newPassword: 'newPassword@123',
  );

  group('UpdatePasswordUsecase', () {
    test(
      'should call updatePassword on the repository with correct data and return void on success',
      () async {
        when(
          () => mockRepository.updatePassword(
            oldPassword: any(named: 'oldPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase(testParams);

        expect(result, const Right(null));

        verify(
          () => mockRepository.updatePassword(
            oldPassword: testParams.oldPassword,
            newPassword: testParams.newPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        when(
          () => mockRepository.updatePassword(
            oldPassword: any(named: 'oldPassword'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            RemoteDatabaseFailure(message: 'Incorrect old password.'),
          ),
        );

        final result = await usecase(testParams);

        expect(
          result,
          const Left(RemoteDatabaseFailure(message: 'Incorrect old password.')),
        );

        verify(
          () => mockRepository.updatePassword(
            oldPassword: testParams.oldPassword,
            newPassword: testParams.newPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
