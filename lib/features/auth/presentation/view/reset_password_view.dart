import 'package:flutter/material.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/features/auth/presentation/view/login_view.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;

  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureNewPassword = ValueNotifier(true);
  final obscureConfirmPassword = ValueNotifier(true);

  final has8Chars = ValueNotifier(false);
  final hasUppercase = ValueNotifier(false);
  final hasLowercase = ValueNotifier(false);
  final hasNumber = ValueNotifier(false);
  final hasSymbol = ValueNotifier(false);

  final isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    newPasswordController.removeListener(_validatePassword);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    isLoading.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = newPasswordController.text;
    has8Chars.value = password.length >= 8;
    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));
    hasSymbol.value = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  void handleResetPassword() async {
    if (isLoading.value) return;

    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password has been reset successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        // Navigate to Login, removing all screens in between
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginView()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Center(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  // --- Header ---
                  Text(
                    'Reset Your Password',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter a new password for your account: ${widget.email}',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // --- Form Container ---
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
                        // --- New Password Field ---
                        ValueListenableBuilder<bool>(
                          valueListenable: obscureNewPassword,
                          builder: (context, isObscure, _) {
                            return CustomTextFormField(
                              controller: newPasswordController,
                              label: "New Password",
                              prefixIcon: Icons.lock_outline,
                              keyboardType: TextInputType.text,
                              obscureText: isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed:
                                    () => obscureNewPassword.value = !isObscure,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Password is required';
                                if (!has8Chars.value ||
                                    !hasUppercase.value ||
                                    !hasLowercase.value ||
                                    !hasNumber.value ||
                                    !hasSymbol.value) {
                                  return 'Please meet all password criteria.';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- Validation Criteria ---
                        _ValidationCriteria(
                          has8Chars: has8Chars,
                          hasUppercase: hasUppercase,
                          hasLowercase: hasLowercase,
                          hasNumber: hasNumber,
                          hasSymbol: hasSymbol,
                        ),
                        const SizedBox(height: 24),

                        // --- Confirm Password Field ---
                        ValueListenableBuilder<bool>(
                          valueListenable: obscureConfirmPassword,
                          builder: (context, isObscure, _) {
                            return CustomTextFormField(
                              controller: confirmPasswordController,
                              label: "Confirm New Password",
                              prefixIcon: Icons.lock_outline,
                              keyboardType: TextInputType.text,
                              obscureText: isObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed:
                                    () =>
                                        obscureConfirmPassword.value =
                                            !isObscure,
                              ),
                              validator: (value) {
                                if (value != newPasswordController.text)
                                  return 'Passwords do not match';
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // --- Submit Button ---
                        ValueListenableBuilder<bool>(
                          valueListenable: isLoading,
                          builder: (context, value, _) {
                            return CustomElevatedButton(
                              onPressed: value ? null : handleResetPassword,
                              height: 56,
                              child:
                                  value
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                      : const Text("Reset Password"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// validation criteria
class _ValidationCriteria extends StatelessWidget {
  final ValueNotifier<bool> has8Chars;
  final ValueNotifier<bool> hasUppercase;
  final ValueNotifier<bool> hasLowercase;
  final ValueNotifier<bool> hasNumber;
  final ValueNotifier<bool> hasSymbol;

  const _ValidationCriteria({
    required this.has8Chars,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ValidationChecklistItem(
          label: "At least 8 characters",
          notifier: has8Chars,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one uppercase letter",
          notifier: hasUppercase,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one lowercase letter",
          notifier: hasLowercase,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one number",
          notifier: hasNumber,
        ),
        const SizedBox(height: 8),
        _ValidationChecklistItem(
          label: "At least one symbol",
          notifier: hasSymbol,
        ),
      ],
    );
  }
}

//
class _ValidationChecklistItem extends StatelessWidget {
  final String label;
  final ValueNotifier<bool> notifier;

  const _ValidationChecklistItem({required this.label, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, isValid, _) {
        final color =
            isValid
                ? theme.colorScheme.primary
                : theme.textTheme.bodySmall?.color;
        final icon = isValid ? Icons.check_circle : Icons.cancel;
        return Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
          ],
        );
      },
    );
  }
}
