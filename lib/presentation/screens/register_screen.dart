import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/context_extensions.dart';
import '../../core/constants/routes_constants.dart';
import '../../core/l10n/locale_keys.g.dart';
import '../../core/utils/validators.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_indicator.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    final bool obscurePassword = true;
    final bool obscureConfirm = true;

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    String? confirmPasswordValidator(String? value) {
      if (value == null || value.isEmpty) return 'Confirm password is required';
      if (value != passwordController.text) return 'Passwords do not match';
      return null;
    }

    return GestureDetector(
      onTap: () => context.unFocus(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.goNamed(Routes.kanbanLayout);
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: context.theme.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return LoadingIndicator();
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: size.height,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet
                              ? 500
                              : double.infinity, // limit width on tablets
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.createAccount.tr(),
                                style: context.theme.textTheme.headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 40),
                              Card(
                                color: context.theme.cardColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      spacing: 16,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppTextField(
                                          controller: emailController,
                                          hintText: LocaleKeys.email.tr(),
                                          validator: Validators.email,
                                          icon: Icons.email,
                                          maxLines: 1,
                                        ),
                                        AppTextField(
                                          controller: passwordController,
                                          hintText: LocaleKeys.password.tr(),
                                          validator: Validators.password,
                                          maxLines: 1,
                                          obscureText: obscurePassword,
                                          icon: Icons.lock,
                                        ),
                                        AppTextField(
                                          controller: confirmController,
                                          hintText: LocaleKeys.confirmPassword
                                              .tr(),
                                          validator: confirmPasswordValidator,
                                          maxLines: 1,
                                          obscureText: obscureConfirm,
                                          icon: Icons.lock_outline,
                                        ),
                                        const SizedBox(height: 8),
                                        AppButton(
                                          text: LocaleKeys.register.tr(),
                                          onPressed: () {
                                            context.read<AuthBloc>().add(
                                              RegisterEvent(
                                                emailController.text,
                                                passwordController.text,
                                              ),
                                            );
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            GoRouter.of(
                                              context,
                                            ).pushNamed(Routes.loginScreen);
                                          },
                                          child: Text(
                                            LocaleKeys.alreadyHaveAnAccount
                                                .tr(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
