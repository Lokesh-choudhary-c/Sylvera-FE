import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:sylvera_fe/api/api_client.dart';
import 'package:sylvera_fe/auth/cubit/auth_cubit.dart';
import 'package:sylvera_fe/auth/cubit/auth_state.dart';
import 'package:sylvera_fe/products/view/product_list_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final email = state is AuthAuthenticated ? state.user.email : '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sylvera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed in as $email'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await ApiClient().dio.get('/cart');
                  print('CART: ${response.data}');
                } on DioException catch (e) {
                  print('ERROR: ${e.response?.statusCode} - ${e.response?.data}');
                }
              },
              child: const Text('Fetch Cart'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              },
              child: const Text('View Products'),
            ),
          ],
        ),
      ),
    );
  }
}