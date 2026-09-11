import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:google_sign_in_web/web_only.dart' as google_web;
import 'package:sylvera_fe/auth/cubit/auth_cubit.dart';
import 'package:sylvera_fe/auth/cubit/auth_state.dart';
import 'package:sylvera_fe/theme/app_theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().prepareGoogleSignIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  BoxDecoration get _fieldDecoration => BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.muted.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      );

  Widget _buildGoogleButton(BuildContext context) {
    if (GoogleSignIn.instance.supportsAuthenticate()) {
      return CupertinoButton(
        color: AppColors.surface,
        onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.globe, color: AppColors.ivory),
            const SizedBox(width: 8),
            Text('Continue with Google', style: AppTextStyles.body),
          ],
        ),
      );
    }
    if (kIsWeb) {
      return google_web.renderButton();
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sylvera'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(14),
                decoration: _fieldDecoration,
                style: AppTextStyles.body,
                placeholderStyle: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: true,
                padding: const EdgeInsets.all(14),
                decoration: _fieldDecoration,
                style: AppTextStyles.body,
                placeholderStyle: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  return Column(
                    children: [
                      CupertinoButton.filled(
                        onPressed: () {
                          final cubit = context.read<AuthCubit>();
                          if (_isRegisterMode) {
                            cubit.register(
                              _emailController.text,
                              _passwordController.text,
                            );
                          } else {
                            cubit.signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: Text(_isRegisterMode ? 'Register' : 'Sign In'),
                      ),
                      if (state is AuthError) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.garnet),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 12),
                      _buildGoogleButton(context),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                onPressed: () {
                  setState(() => _isRegisterMode = !_isRegisterMode);
                },
                child: Text(
                  _isRegisterMode
                      ? 'Already have an account? Sign in'
                      : "Don't have an account? Register",
                  style: AppTextStyles.bodyMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}