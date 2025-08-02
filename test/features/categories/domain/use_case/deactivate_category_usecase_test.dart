import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/use_case/deactivate_category_usecase.dart';
import 'category_repository.mock.dart';

void main() {
  late DeactivateCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = DeactivateCategoryUsecase(repository: mockRepository);
  });

  const testCategoryId = '68896f119e9284fc3529ba86';

  const testParams = DeactivateCategoryParams(testCategoryId);

  group('DeactivateCategoryUsecase', () {
    test(
      'should call deactivateCategory on repository and return void on success',
      () async {
        when(
          () => mockRepository.deactivateCategory(any()),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase(testParams);

        expect(result, const Right(null));

        verify(() => mockRepository.deactivateCategory(testCategoryId)).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a failure when the call to repository is unsuccessful',
      () async {
        when(() => mockRepository.deactivateCategory(any())).thenAnswer(
          (_) async => const Left(
            RemoteDatabaseFailure(message: 'category deactivate failed'),
          ),
        );

        final result = await usecase(testParams);

        expect(
          result,
          const Left(
            RemoteDatabaseFailure(message: 'category deactivate failed'),
          ),
        );

        verify(() => mockRepository.deactivateCategory(testCategoryId)).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
