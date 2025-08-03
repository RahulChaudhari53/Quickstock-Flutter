import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_event.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_state.dart';
import 'package:quickstock/features/forgot_password/presentation/viewmodel/reset_password_viewmodel/reset_password_viewmodel.dart';

class ResetPasswordView extends StatelessWidget {
  final String resetToken;

  ResetPasswordView({super.key, required this.resetToken});

  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _obscureNewPassword = ValueNotifier(true);
  final _obscureConfirmPassword = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocBuilder<ResetPasswordViewModel, ResetPasswordState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'Reset Your Password',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create a new, strong password for your account.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _obscureNewPassword,
                            builder: (context, isObscure, _) {
                              return CustomTextFormField(
                                controller: _newPasswordController,
                                label: "New Password",
                                prefixIcon: Icons.lock_outline,
                                obscureText: isObscure,
                                onChanged: (value) {
                                  context.read<ResetPasswordViewModel>().add(
                                    PasswordChanged(value),
                                  );
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed:
                                      () =>
                                          _obscureNewPassword.value =
                                              !isObscure,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (!state.isPasswordValid) {
                                    return 'Please meet all password criteria.';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          _ValidationCriteria(state: state),
                          const SizedBox(height: 24),

                          ValueListenableBuilder<bool>(
                            valueListenable: _obscureConfirmPassword,
                            builder: (context, isObscure, _) {
                              return CustomTextFormField(
                                controller: _confirmPasswordController,
                                label: "Confirm New Password",
                                prefixIcon: Icons.lock_outline,
                                obscureText: isObscure,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed:
                                      () =>
                                          _obscureConfirmPassword.value =
                                              !isObscure,
                                ),
                                validator: (value) {
                                  if (value != _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          CustomElevatedButton(
                            onPressed:
                                state.isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<ResetPasswordViewModel>()
                                            .add(
                                              ResetPasswordButtonPressed(
                                                context: context,
                                                newPassword:
                                                    _newPasswordController.text,
                                                resetToken: resetToken,
                                              ),
                                            );
                                      }
                                    },
                            height: 56,
                            child:
                                state.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                    : const Text("Reset Password"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ValidationCriteria extends StatelessWidget {
  final ResetPasswordState state;
  const _ValidationCriteria({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ValidationChecklistItem(
          label: "At least 8 characters",
          isValid: state.has8Chars,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one uppercase letter",
          isValid: state.hasUppercase,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one lowercase letter",
          isValid: state.hasLowercase,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one number",
          isValid: state.hasNumber,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one symbol",
          isValid: state.hasSymbol,
        ),
      ],
    );
  }
}

class _ValidationChecklistItem extends StatelessWidget {
  final String label;
  final bool isValid;
  const _ValidationChecklistItem({required this.label, required this.isValid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isValid ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color;
    final icon = isValid ? Icons.check_circle : Icons.cancel;
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
      ],
    );
  }
}
