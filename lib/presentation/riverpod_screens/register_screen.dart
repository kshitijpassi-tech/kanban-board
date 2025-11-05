import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanban_assignment/core/constants/context_extensions.dart';

import '../../../core/utils/validators.dart';
import '../../core/constants/routes_constants.dart';
import '../../core/l10n/locale_keys.g.dart';
import '../providers/presentation_providers.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_indicator.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  final bool _obscurePassword = true;
  final bool _obscureConfirm = true;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await ref
          .read(authStateNotifierProvider.notifier)
          .register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

      if (mounted) context.goNamed(Routes.kanbanLayout);
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          'Registeration failed: ${e.toString()}',
          color: context.theme.colorScheme.error,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Confirm password is required';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return GestureDetector(
      onTap: () => context.unFocus(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        body: Stack(
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
                                key: _formKey,
                                child: Column(
                                  spacing: 16,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppTextField(
                                      controller: _emailController,
                                      hintText: LocaleKeys.email.tr(),
                                      validator: Validators.email,
                                      icon: Icons.email,
                                      maxLines: 1,
                                    ),
                                    AppTextField(
                                      controller: _passwordController,
                                      hintText: LocaleKeys.password.tr(),
                                      validator: Validators.password,
                                      maxLines: 1,
                                      obscureText: _obscurePassword,
                                      icon: Icons.lock,
                                    ),
                                    AppTextField(
                                      controller: _confirmController,
                                      hintText: LocaleKeys.confirmPassword.tr(),
                                      validator: _confirmPasswordValidator,
                                      maxLines: 1,
                                      obscureText: _obscureConfirm,
                                      icon: Icons.lock_outline,
                                    ),
                                    const SizedBox(height: 8),
                                    AppButton(
                                      text: LocaleKeys.register.tr(),
                                      onPressed: _register,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        GoRouter.of(
                                          context,
                                        ).pushNamed(Routes.loginScreen);
                                      },
                                      child: Text(
                                        LocaleKeys.alreadyHaveAnAccount.tr(),
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
            if (_loading)
              Container(
                color: Colors.black54,
                child: const Center(child: LoadingIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
