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

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return GestureDetector(
      onTap: () => context.unFocus(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, state) {
            if (state is Authenticated) {
              context.go(Routes.kanbanLayout);
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
                          maxWidth: isTablet ? 500 : double.infinity,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
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
                              SizedBox(height: 40),
                              Card(
                                color: context.theme.cardColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(24),
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
                                        SizedBox(height: 16),
                                        AppTextField(
                                          controller: _passwordController,
                                          hintText: LocaleKeys.password.tr(),
                                          validator: Validators.password,
                                          obscureText: true,
                                          icon: Icons.lock,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 24),
                                        AppButton(
                                          text: LocaleKeys.login.tr(),
                                          onPressed: () {
                                            context.read<AuthBloc>().add(
                                              LoginEvent(
                                                _emailController.text,
                                                _passwordController.text,
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 12),
                                        TextButton(
                                          onPressed: () {
                                            GoRouter.of(
                                              context,
                                            ).goNamed(Routes.registerScreen);
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
              ],
            );
          },
        ),
      ),
    );
  }
}
