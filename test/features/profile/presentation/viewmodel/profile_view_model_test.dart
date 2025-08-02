import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickstock/features/dashboard/domain/usecase/user_logout_usecase.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/domain/usecase/add_phone_number_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/deactivate_account_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/delete_phone_number_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_email_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_password_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_profile_image_usecase.dart';
import 'package:quickstock/features/profile/domain/usecase/update_profile_info_usecase.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_event.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';

class MockAddPhoneNumberUsecase extends Mock implements AddPhoneNumberUsecase {}

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUpdatePasswordUsecase extends Mock implements UpdatePasswordUsecase {}

class MockUpdateProfileInfoUsecase extends Mock
    implements UpdateProfileInfoUsecase {}

class MockUpdateEmailUsecase extends Mock implements UpdateEmailUsecase {}

class MockUpdateProfileImageUsecase extends Mock
    implements UpdateProfileImageUsecase {}

class MockDeletePhoneNumberUsecase extends Mock
    implements DeletePhoneNumberUsecase {}

class MockDeactivateAccountUsecase extends Mock
    implements DeactivateAccountUsecase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late ProfileViewModel bloc;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockUpdateProfileInfoUsecase mockUpdateProfileInfoUsecase;
  late MockUpdatePasswordUsecase mockUpdatePasswordUsecase;
  late MockUpdateEmailUsecase mockUpdateEmailUsecase;
  late MockUpdateProfileImageUsecase mockUpdateProfileImageUsecase;
  late MockAddPhoneNumberUsecase mockAddPhoneNumberUsecase;
  late MockDeletePhoneNumberUsecase mockDeletePhoneNumberUsecase;
  late MockDeactivateAccountUsecase mockDeactivateAccountUsecase;
  late MockLogoutUseCase mockLogoutUseCase;

  final tProfileEntity = ProfileEntity(
    id: '688a05ccf90a5309554a97e9',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@email.com',
    primaryPhone: '1234567890',
    role: 'shop_owner',
    isActive: true,
    updatedAt: DateTime.parse('2025-07-31T08:10:44.379Z'),
    createdAt: DateTime.parse('2025-07-31T08:10:44.379Z'),
  );

  setUp(() {
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockUpdateProfileInfoUsecase = MockUpdateProfileInfoUsecase();
    mockUpdatePasswordUsecase = MockUpdatePasswordUsecase();
    mockUpdateEmailUsecase = MockUpdateEmailUsecase();
    mockUpdateProfileImageUsecase = MockUpdateProfileImageUsecase();
    mockAddPhoneNumberUsecase = MockAddPhoneNumberUsecase();
    mockDeletePhoneNumberUsecase = MockDeletePhoneNumberUsecase();
    mockDeactivateAccountUsecase = MockDeactivateAccountUsecase();
    mockLogoutUseCase = MockLogoutUseCase();

    bloc = ProfileViewModel(
      getProfileUsecase: mockGetProfileUsecase,
      updateProfileInfoUsecase: mockUpdateProfileInfoUsecase,
      updatePasswordUsecase: mockUpdatePasswordUsecase,
      updateEmailUsecase: mockUpdateEmailUsecase,
      updateProfileImageUsecase: mockUpdateProfileImageUsecase,
      addPhoneNumberUsecase: mockAddPhoneNumberUsecase,
      deletePhoneNumberUsecase: mockDeletePhoneNumberUsecase,
      deactivateAccountUsecase: mockDeactivateAccountUsecase,
      logoutUseCase: mockLogoutUseCase,
    );

    registerFallbackValue(
      const UpdateProfileInfoParams(firstName: '', lastName: ''),
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is ProfileState.initial()', () {
    expect(bloc.state, const ProfileState.initial());
  });

  group('ProfileFetchStartEvent', () {
    blocTest<ProfileViewModel, ProfileState>(
      'should emit [initial loading, final state with user] when GetProfileUsecase is successful',
      build: () {
        when(
          () => mockGetProfileUsecase(),
        ).thenAnswer((_) async => Right(tProfileEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(ProfileFetchStartEvent()),

      expect:
          () => [
            const ProfileState.initial(),

            ProfileState(isLoading: false, user: tProfileEntity),
          ],

      verify: (_) {
        verify(() => mockGetProfileUsecase()).called(1);
      },
    );
  });

  group('ProfileInfoUpdateEvent', () {
    const tUpdateParams = UpdateProfileInfoParams(
      firstName: 'Jane',
      lastName: 'Smith',
    );

    final tUpdatedProfile = tProfileEntity.copyWith(
      firstName: 'Jane',
      lastName: 'Smith',
    );

    blocTest<ProfileViewModel, ProfileState>(
      'should emit [isSubmitting, successMessage] when UpdateProfileInfoUsecase is successful',
      build: () {
        when(
          () => mockUpdateProfileInfoUsecase(any()),
        ).thenAnswer((_) async => Right(tUpdatedProfile));
        return bloc;
      },
      seed: () => ProfileState(user: tProfileEntity, isLoading: false),
      act:
          (bloc) => bloc.add(
            ProfileInfoUpdateEvent(
              firstName: tUpdateParams.firstName,
              lastName: tUpdateParams.lastName,
            ),
          ),
      expect:
          () => [
            ProfileState(
              user: tProfileEntity,
              isLoading: false,
              isSubmitting: true,
            ),
            ProfileState(
              isLoading: false,
              isSubmitting: false,
              user: tUpdatedProfile,
              successMessage: 'Profile information updated successfully!',
            ),
          ],
      verify: (_) {
        verify(() => mockUpdateProfileInfoUsecase(tUpdateParams)).called(1);
      },
    );
  });
}
