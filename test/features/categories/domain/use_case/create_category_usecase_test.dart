import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/use_case/create_category_usecase.dart';

import 'category_repository.mock.dart';

void main() {
  late CreateCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = CreateCategoryUsecase(repository: mockRepository);
  });

  const testParams = CreateCategoryParams(
    name: 'New Gadgets',
    description: 'All the latest and greatest gadgets.',
  );

  const testCategoryEntity = CategoryEntity(
    id: '68896f119e9284fc3529ba86',
    name: 'New Gadgets',
    description: 'All the latest and greatest gadgets.',
    createdBy: '688911b6d647fafffd14d347',
    isActive: true,
  );

  group('CreateCategoryUsecase', () {
    test(
      'should call createCategory on the repository and return new CategoryEntity on success',
      () async {
        when(
          () => mockRepository.createCategory(
            name: any(named: 'name'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => const Right(testCategoryEntity));

        final result = await usecase(testParams);

        expect(result, const Right(testCategoryEntity));

        verify(
          () => mockRepository.createCategory(
            name: testParams.name,
            description: testParams.description,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a failure when the call to the repository is unsuccessful',
      () async {
        when(
          () => mockRepository.createCategory(
            name: any(named: 'name'),
            description: any(named: 'description'),
          ),
        ).thenAnswer(
          (_) async => const Left(RemoteDatabaseFailure(message: "failed")),
        );

        final result = await usecase(testParams);

        expect(result, const Left(RemoteDatabaseFailure(message: "failed")));

        verify(
          () => mockRepository.createCategory(
            name: testParams.name,
            description: testParams.description,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
