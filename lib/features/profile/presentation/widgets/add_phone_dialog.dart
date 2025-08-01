import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_event.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:quickstock/features/profile/presentation/viewmodel/profile_view_model.dart';

class AddPhoneDialog extends StatefulWidget {
  const AddPhoneDialog({super.key});

  @override
  State<AddPhoneDialog> createState() => _AddPhoneDialogState();
}

class _AddPhoneDialogState extends State<AddPhoneDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
        ProfilePhoneNumberAddEvent(phoneNumber: _phoneController.text.trim()),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Secondary Phone'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number cannot be empty';
                }
                if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                  return 'Must be exactly 10 digits';
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
                      : const Text('Add'),
            );
          },
        ),
      ],
    );
  }
}
