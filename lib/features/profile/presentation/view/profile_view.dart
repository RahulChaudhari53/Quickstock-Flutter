import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/app/service_locator/service_locator.dart';
import 'package:quickstock/features/auth/presentation/view/login_view.dart';
import 'package:quickstock/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:quickstock/features/dashboard/presentation/page_content.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_event.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';
import 'package:quickstock/features/profile/presentation/widgets/add_phone_dialog.dart';
import 'package:quickstock/features/profile/presentation/widgets/profile_header.dart';
import 'package:quickstock/features/profile/presentation/widgets/profile_section.dart';
import 'package:quickstock/features/profile/presentation/widgets/update_email_dialog.dart';
import 'package:quickstock/features/profile/presentation/widgets/update_info_dialog.dart';
import 'package:quickstock/features/profile/presentation/widgets/update_password_dialog.dart';

class ProfileView extends PageContent {
  const ProfileView({super.key});

  @override
  String get title => 'My Profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileViewModel>(
      create:
          (context) =>
              serviceLocator<ProfileViewModel>()..add(ProfileFetchStartEvent()),
      child: const _ProfileViewBody(),
    );
  }
}

class _ProfileViewBody extends StatelessWidget {
  const _ProfileViewBody();

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  onConfirm();
                  Navigator.pop(dialogContext);
                },
                child: Text(title.contains('Delete') ? 'Delete' : 'Deactivate'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.isLoggedOut) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: serviceLocator<LoginViewModel>(),
                      child: LoginView(),
                    ),
              ),
              (route) => false,
            );
            return;
          }
          final messenger = ScaffoldMessenger.of(context);
          final viewModel = context.read<ProfileViewModel>();

          if (state.actionError != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.actionError!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            viewModel.add(ProfileFeedbackMessageClearedEvent());
          }
          if (state.successMessage != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
            viewModel.add(ProfileFeedbackMessageClearedEvent());
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          if (state.user == null) {
            return const Center(child: Text('Could not load profile.'));
          }

          final user = state.user!;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileViewModel>().add(ProfileFetchStartEvent());
            },
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ProfileHeader(user: user),
                    const SizedBox(height: 16),

                    ProfileSectionCard(
                      title: 'Personal Information',
                      onEdit:
                          () => showDialog(
                            context: context,
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<ProfileViewModel>(),
                                  child: UpdateInfoDialog(user: user),
                                ),
                          ),
                      child: Column(
                        children: [
                          _InfoRow(label: 'Full Name', value: user.fullName),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Contact Details Card ---
                    ProfileSectionCard(
                      title: 'Contact Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            label: 'Email Address',
                            value: user.email,
                            onEdit:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<ProfileViewModel>(),
                                        child: UpdateEmailDialog(
                                          currentEmail: user.email,
                                        ),
                                      ),
                                ),
                          ),
                          const Divider(),
                          _InfoRow(
                            label: 'Primary Phone',
                            value: user.primaryPhone,
                          ),
                          if (user.secondaryPhone != null) ...[
                            const Divider(),
                            _InfoRow(
                              label: 'Secondary Phone',
                              value: user.secondaryPhone!,
                              onDelete:
                                  () => _showConfirmationDialog(
                                    context: context,
                                    title: 'Delete Phone Number?',
                                    content:
                                        'Are you sure you want to remove this number?',
                                    onConfirm:
                                        () => context
                                            .read<ProfileViewModel>()
                                            .add(
                                              ProfilePhoneNumberDeleteEvent(
                                                phoneNumber:
                                                    user.secondaryPhone!,
                                              ),
                                            ),
                                  ),
                            ),
                          ] else
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton.icon(
                                onPressed:
                                    () => showDialog(
                                      context: context,
                                      builder:
                                          (_) => BlocProvider.value(
                                            value:
                                                context
                                                    .read<ProfileViewModel>(),
                                            child: const AddPhoneDialog(),
                                          ),
                                    ),
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                ),
                                label: const Text('Add secondary phone'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    ProfileSectionCard(
                      title: 'Security',
                      editText: 'Change',
                      onEdit:
                          () => showDialog(
                            context: context,
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<ProfileViewModel>(),
                                  child: const UpdatePasswordDialog(),
                                ),
                          ),
                      child: const _InfoRow(
                        label: 'Password',
                        value: '••••••••',
                      ),
                    ),
                    const SizedBox(height: 16),

                    _DangerZoneCard(
                      onDeactivate:
                          () => _showConfirmationDialog(
                            context: context,
                            title: 'Deactivate Account?',
                            content:
                                'This action is permanent and cannot be undone. Are you sure?',
                            onConfirm:
                                () => context.read<ProfileViewModel>().add(
                                  ProfileAccountDeactivateEvent(),
                                ),
                          ),
                    ),
                  ],
                ),

                if (state.isLoading && state.user != null)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _InfoRow({
    required this.label,
    required this.value,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
        ],
      ),
    );
  }
}

class _DangerZoneCard extends StatelessWidget {
  final VoidCallback onDeactivate;
  const _DangerZoneCard({required this.onDeactivate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer.withOpacity(0.3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger Zone',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Deactivating your account is a permanent action and cannot be undone.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDeactivate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                child: const Text('Deactivate Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
