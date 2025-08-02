import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/use_case/activate_category_usecase.dart';

import 'category_repository.mock.dart';

void main() {
  late ActivateCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = ActivateCategoryUsecase(repository: mockRepository);
  });

  const testParams = ActivateCategoryParams('68896f119e9284fc3529ba86');

  const testActivatedCategoryEntity = CategoryEntity(
    id: '68896f119e9284fc3529ba86',
    name: 'New Gadgets',
    description: 'All the latest and greatest gadgets.',
    createdBy: '688911b6d647fafffd14d347',
    isActive: true,
  );

  group('ActivateCategoryUsecase', () {
    test(
      'should call activateCategory on the repository and return the updated CategoryEntity on success',
      () async {
        when(
          () => mockRepository.activateCategory(any()),
        ).thenAnswer((_) async => const Right(testActivatedCategoryEntity));

        final result = await usecase(testParams);

        expect(result, const Right(testActivatedCategoryEntity));

        verify(
          () => mockRepository.activateCategory(testParams.categoryId),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        when(() => mockRepository.activateCategory(any())).thenAnswer(
          (_) async => const Left(
            RemoteDatabaseFailure(message: 'Failed to activate the category.'),
          ),
        );

        final result = await usecase(testParams);

        expect(
          result,
          const Left(
            RemoteDatabaseFailure(message: 'Failed to activate the category.'),
          ),
        );

        verify(
          () => mockRepository.activateCategory(testParams.categoryId),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
