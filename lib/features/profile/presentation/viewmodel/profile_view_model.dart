import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/dashboard/domain/usecase/user_logout_usecase.dart';
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

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileInfoUsecase _updateProfileInfoUsecase;
  final UpdatePasswordUsecase _updatePasswordUsecase;
  final UpdateEmailUsecase _updateEmailUsecase;
  final UpdateProfileImageUsecase _updateProfileImageUsecase;
  final AddPhoneNumberUsecase _addPhoneNumberUsecase;
  final DeletePhoneNumberUsecase _deletePhoneNumberUsecase;
  final DeactivateAccountUsecase _deactivateAccountUsecase;
  final LogoutUseCase _logoutUseCase;

  ProfileViewModel({
    required GetProfileUsecase getProfileUsecase,
    required UpdateProfileInfoUsecase updateProfileInfoUsecase,
    required UpdatePasswordUsecase updatePasswordUsecase,
    required UpdateEmailUsecase updateEmailUsecase,
    required UpdateProfileImageUsecase updateProfileImageUsecase,
    required AddPhoneNumberUsecase addPhoneNumberUsecase,
    required DeletePhoneNumberUsecase deletePhoneNumberUsecase,
    required DeactivateAccountUsecase deactivateAccountUsecase,
    required LogoutUseCase logoutUseCase,
  }) : _getProfileUsecase = getProfileUsecase,
       _updateProfileInfoUsecase = updateProfileInfoUsecase,
       _updatePasswordUsecase = updatePasswordUsecase,
       _updateEmailUsecase = updateEmailUsecase,
       _updateProfileImageUsecase = updateProfileImageUsecase,
       _addPhoneNumberUsecase = addPhoneNumberUsecase,
       _deletePhoneNumberUsecase = deletePhoneNumberUsecase,
       _deactivateAccountUsecase = deactivateAccountUsecase,
       _logoutUseCase = logoutUseCase,
       super(const ProfileState.initial()) {
    on<ProfileFetchStartEvent>(_onProfileFetchStarted);
    on<ProfileInfoUpdateEvent>(_onProfileInfoUpdated);
    on<ProfilePasswordUpdateEvent>(_onProfilePasswordUpdated);
    on<ProfileEmailUpdateEvent>(_onProfileEmailUpdated);
    on<ProfileImageUpdateEvent>(_onProfileImageUpdated);
    on<ProfilePhoneNumberAddEvent>(_onProfilePhoneNumberAdded);
    on<ProfilePhoneNumberDeleteEvent>(_onProfilePhoneNumberDeleted);
    on<ProfileLogoutEvent>(_onProfileLogout);
    on<ProfileAccountDeactivateEvent>(_onProfileAccountDeactivated);
    on<ProfileFeedbackMessageClearedEvent>(_onProfileFeedbackMessageCleared);
  }

  Future<void> _onProfileFetchStarted(
    ProfileFetchStartEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearErrorMessage: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final result = await _getProfileUsecase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (user) => emit(state.copyWith(isLoading: false, user: user)),
    );
  }

  Future<void> _onProfileInfoUpdated(
    ProfileInfoUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final params = UpdateProfileInfoParams(
      firstName: event.firstName,
      lastName: event.lastName,
    );
    final result = await _updateProfileInfoUsecase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          user: user,
          successMessage: 'Profile information updated successfully!',
        ),
      ),
    );
  }

  Future<void> _onProfilePasswordUpdated(
    ProfilePasswordUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final params = UpdatePasswordParams(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );
    final result = await _updatePasswordUsecase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Password updated successfully!',
        ),
      ),
    );
  }

  Future<void> _onProfileEmailUpdated(
    ProfileEmailUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final result = await _updateEmailUsecase(event.email);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          user: user,
          successMessage: 'Email updated successfully!',
        ),
      ),
    );
  }

  Future<void> _onProfileImageUpdated(
    ProfileImageUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );

    final result = await _updateProfileImageUsecase(event.image);

    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          user: user,
          successMessage: 'Profile image updated!',
        ),
      ),
    );
  }

  Future<void> _onProfilePhoneNumberAdded(
    ProfilePhoneNumberAddEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final result = await _addPhoneNumberUsecase(event.phoneNumber);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          user: user,
          successMessage: 'Phone number added!',
        ),
      ),
    );
  }

  Future<void> _onProfilePhoneNumberDeleted(
    ProfilePhoneNumberDeleteEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final result = await _deletePhoneNumberUsecase(event.phoneNumber);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          user: user,
          successMessage: 'Phone number removed.',
        ),
      ),
    );
  }

  void _onProfileFeedbackMessageCleared(
    ProfileFeedbackMessageClearedEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(clearActionError: true, clearSuccessMessage: true));
  }

  Future<void> _onProfileAccountDeactivated(
    ProfileAccountDeactivateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearActionError: true,
        clearSuccessMessage: true,
      ),
    );
    final result = await _deactivateAccountUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, actionError: failure.message),
      ),
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            successMessage: 'Account deactivated. Logging out...',
          ),
        );
        add(ProfileLogoutEvent());
      },
    );
  }

  Future<void> _onProfileLogout(
    ProfileLogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(actionError: "Logout failed: ${failure.message}"),
      ),
      (_) => emit(state.copyWith(isLoggedOut: true)),
    );
  }
}
