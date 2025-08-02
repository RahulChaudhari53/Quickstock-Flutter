import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/usecase/get_profile_usecase.dart';

import 'profile_repository.mock.dart';

void main() {
  late GetProfileUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = GetProfileUsecase(mockRepository);
  });

  final testProfileEntity = ProfileEntity(
    id: '688b25049254b18ddb2e08f8',
    firstName: 'John',
    lastName: 'Doe Mobile',
    email: 'john.doe.mobile@gmail.com',
    primaryPhone: '9800000002',
    role: 'shop_owner',
    isActive: true,
    createdAt: DateTime.parse('2025-07-31T08:10:44.379Z'),
    updatedAt: DateTime.parse('2025-07-31T08:10:44.379Z'),
  );

  group('GetProfileUsecase', () {
    test('should get user profile from the repository successfully', () async {
      when(
        () => mockRepository.getProfile(),
      ).thenAnswer((_) async => Right(testProfileEntity));

      final result = await usecase();

      expect(result, Right(testProfileEntity));

      verify(() => mockRepository.getProfile()).called(1);

      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        when(() => mockRepository.getProfile()).thenAnswer(
          (_) async =>
              const Left(RemoteDatabaseFailure(message: "Failed to get data")),
        );

        final result = await usecase();

        expect(
          result,
          const Left(RemoteDatabaseFailure(message: "Failed to get data")),
        );

        verify(() => mockRepository.getProfile()).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
