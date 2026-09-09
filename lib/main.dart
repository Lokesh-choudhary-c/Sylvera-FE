import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sylvera_fe/api/api_client.dart';
import 'package:sylvera_fe/auth/view/sign_in_screen.dart';
import 'package:sylvera_fe/cart/cubit/cart_cubit.dart';
import 'package:sylvera_fe/home/home_screen.dart';
import 'package:sylvera_fe/products/cubit/product_cubit.dart';
import 'package:sylvera_fe/theme/app_theme.dart';
import 'package:sylvera_fe/variant%20price/cubit/variant_price_cubit.dart';
import 'firebase_options.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/auth_state.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(apiClient: ApiClient()));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  const MyApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        RepositoryProvider(create: (context) => apiClient),
        BlocProvider(
          create: (context) => ProductCubit(apiClient: context.read<ApiClient>()),
        ),
        BlocProvider(
          create: (context) => CartCubit(apiClient: context.read<ApiClient>()),
        ),
        BlocProvider(
          create: (context) => VariantPriceCubit(apiClient: context.read<ApiClient>()),
        ),
      ],
      child: MaterialApp(
        title: 'Sylvera',
        theme: AppTheme.theme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            }
            if (state is AuthUnauthenticated || state is AuthError) {
              return const SignInScreen();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}