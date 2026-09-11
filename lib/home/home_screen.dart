import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sylvera_fe/auth/cubit/auth_cubit.dart';
import 'package:sylvera_fe/auth/cubit/auth_state.dart';
import 'package:sylvera_fe/products/view/product_list_screen.dart';
import 'package:sylvera_fe/cart/view/cart_screen.dart';
import 'package:sylvera_fe/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final email = state is AuthAuthenticated ? state.user.email : '';
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Sylvera'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.cart),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.read<AuthCubit>().signOut(),
              child: const Icon(CupertinoIcons.square_arrow_right),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Signed in as $email', style: AppTextStyles.body),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const ProductListScreen(),
                    ),
                  );
                },
                child: const Text('View Products'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}