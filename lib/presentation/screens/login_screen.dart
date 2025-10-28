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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await ref
          .read(authStateNotifierProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());

      if (mounted) context.goNamed(Routes.kanbanLayout);
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          'Login failed: ${e.toString()}',
          color: context.theme.colorScheme.error,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                          GestureDetector(
                            onTap: () {
                              _emailController.text = 'A@A.com';
                              _passwordController.text = 'password@123';
                            },
                            child: Text(
                              LocaleKeys.welcomeBack.tr(),
                              style: context.theme.textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
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
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    AppTextField(
                                      controller: _emailController,
                                      hintText: LocaleKeys.email.tr(),
                                      validator: Validators.email,
                                      icon: Icons.email,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 16),
                                    AppTextField(
                                      controller: _passwordController,
                                      hintText: LocaleKeys.password.tr(),
                                      validator: Validators.password,
                                      obscureText: true,
                                      icon: Icons.lock,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 24),
                                    AppButton(
                                      text: LocaleKeys.login.tr(),
                                      onPressed: _login,
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () {
                                        GoRouter.of(
                                          context,
                                        ).pushNamed(Routes.registerScreen);
                                      },
                                      child: Text(
                                        LocaleKeys.dontHaveAnAccount.tr(),
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
