import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_event.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';

class UpdateEmailDialog extends StatefulWidget {
  final String currentEmail;

  const UpdateEmailDialog({super.key, required this.currentEmail});

  @override
  State<UpdateEmailDialog> createState() => _UpdateEmailDialogState();
}

class _UpdateEmailDialogState extends State<UpdateEmailDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
        ProfileEmailUpdateEvent(email: _emailController.text.trim()),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Email Address'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'New Email Address'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email cannot be empty';
                }
                if (!RegExp(
                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                ).hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                if (value.trim() == widget.currentEmail) {
                  return 'Please enter a new email address';
                }
                return null;
              },
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
