import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickstock/core/common/custom_elevated_button.dart';
import 'package:quickstock/core/common/custom_text_form_field.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:quickstock/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          // Success navigation handled in BLoC
        },
        builder: (context, state) {
          return RegisterForm(state: state);
        },
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final RegisterState state;
  const RegisterForm({super.key, required this.state});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> agreedToTerms = ValueNotifier(false);

  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      final agreed = agreedToTerms.value;
      context.read<RegisterViewModel>().add(
        UserRegisterEvent(
          context: context,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          primaryPhone: phoneController.text.trim(),
          password: passwordController.text,
          agreedToTerms: agreed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Create Your Account",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter your details below to get started.",
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
      
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: firstNameController,
                        label: 'First Name',
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'First name is required'
                                    : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextFormField(
                        controller: lastNameController,
                        label: 'Last Name',
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Last name is required'
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
      
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
      
                CustomTextFormField(
                  controller: phoneController,
                  label: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Phone number is required';
                    if (value.length < 10)
                      return 'Must be a valid 10-digit phone number.';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
      
                ValueListenableBuilder<bool>(
                  valueListenable: obscurePassword,
                  builder: (context, isObscure, _) {
                    return CustomTextFormField(
                      controller: passwordController,
                      label: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: isObscure,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => obscurePassword.value = !isObscure,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Password is required';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
      
                ValueListenableBuilder<bool>(
                  valueListenable: agreedToTerms,
                  builder: (context, isChecked, _) {
                    return InkWell(
                      onTap: () => agreedToTerms.value = !isChecked,
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged:
                                (val) => agreedToTerms.value = val ?? false,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: textTheme.bodyMedium,
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'privacy policy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to privacy policy
                                          },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'terms of use',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to terms of use
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
      
                CustomElevatedButton(
                  onPressed: widget.state.isLoading ? null : handleSubmit,
                  height: 56,
                  child:
                      widget.state.isLoading
                          ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                          : const Text("Create Account"),
                ),
                const SizedBox(height: 24),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Login"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
