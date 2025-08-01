
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/profile/domain/entity/profile_entity.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_event.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';

class UpdateInfoDialog extends StatefulWidget {
  final ProfileEntity user;

  const UpdateInfoDialog({super.key, required this.user});

  @override
  State<UpdateInfoDialog> createState() => _UpdateInfoDialogState();
}

class _UpdateInfoDialogState extends State<UpdateInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
        ProfileInfoUpdateEvent(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        ),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The rest of the build method is unchanged, as it was already correct.
    return AlertDialog(
      title: const Text('Update Personal Info'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              textCapitalization: TextCapitalization.words,
              validator:
                  (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'First name cannot be empty'
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              textCapitalization: TextCapitalization.words,
              validator:
                  (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Last name cannot be empty'
                          : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocBuilder<ProfileViewModel, ProfileState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.isSubmitting ? null : _submitForm,
              child:
                  state.isSubmitting
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                      : const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}
