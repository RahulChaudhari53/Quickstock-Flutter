import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/core/error/failure.dart';
import 'package:quickstock/features/categories/domain/entity/category_entity.dart';
import 'package:quickstock/features/categories/domain/entity/pagination_info_entity.dart';
import 'package:quickstock/features/categories/domain/repository/category_repository.dart';
import 'package:quickstock/features/categories/domain/use_case/get_all_categories_usecase.dart';
import 'category_repository.mock.dart';

void main() {
  late GetAllCategoriesUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = GetAllCategoriesUsecase(repository: mockRepository);
  });

  const testCategory1 = CategoryEntity(
    id: '68896edd9e9284fc3529ba67',
    name: 'Electronics',
    description: 'Gadgets and devices',
    createdBy: '688911b6d647fafffd14d347',
    isActive: true,
  );

  const testCategory2 = CategoryEntity(
    id: '68896f119e9284fc3529ba86',
    name: 'Books',
    description: 'Printed and digital books',
    createdBy: '688911b6d647fafffd14d347',
    isActive: true,
  );

  const testPaginationInfo = PaginationInfoEntity(
    currentPage: 1,
    totalPages: 5,
    hasNextPage: true,
    hasPrevPage: false,
  );

  final testPaginatedCategories = PaginatedCategories(
    categories: const [testCategory1, testCategory2],
    paginationInfo: testPaginationInfo,
  );

  const testParams = GetAllCategoriesParams(
    page: 1,
    limit: 10,
    searchTerm: 'cat',
    sortBy: 'name_asc',
    isActive: true,
  );

  group('GetAllCategoriesUsecase', () {
    test(
      'should get a paginated list of categories from the repository',
      () async {
        when(
          () => mockRepository.getAllCategories(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            searchTerm: any(named: 'searchTerm'),
            sortBy: any(named: 'sortBy'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(testPaginatedCategories));

        final result = await usecase(testParams);

        expect(result, Right(testPaginatedCategories));

        verify(
          () => mockRepository.getAllCategories(
            page: testParams.page,
            limit: testParams.limit,
            searchTerm: testParams.searchTerm,
            sortBy: testParams.sortBy,
            isActive: testParams.isActive,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a failure when the call to the repository is unsuccessful',
      () async {
        when(
          () => mockRepository.getAllCategories(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            searchTerm: any(named: 'searchTerm'),
            sortBy: any(named: 'sortBy'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer(
          (_) async =>
              const Left(RemoteDatabaseFailure(message: 'Server Error')),
        );

        final result = await usecase(testParams);

        expect(
          result,
          const Left(RemoteDatabaseFailure(message: 'Server Error')),
        );

        verify(
          () => mockRepository.getAllCategories(
            page: testParams.page,
            limit: testParams.limit,
            searchTerm: testParams.searchTerm,
            sortBy: testParams.sortBy,
            isActive: testParams.isActive,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
