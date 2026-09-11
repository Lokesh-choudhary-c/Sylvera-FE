import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../../theme/app_theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final email = state is AuthAuthenticated ? state.user.email : '';
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Account')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Signed in as', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 4),
              Text(email ?? '', style: AppTextStyles.headline),
              const SizedBox(height: 24),
              CupertinoButton(
                color: AppColors.surface,
                onPressed: () => context.read<AuthCubit>().signOut(),
                child: Text(
                  'Sign out',
                  style: AppTextStyles.body.copyWith(color: AppColors.garnet),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}