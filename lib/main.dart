import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sylvera_fe/account/view/account_screen.dart';
import 'package:sylvera_fe/cart/view/cart_screen.dart';
import 'package:sylvera_fe/category/cubit/category_cubit.dart';
import 'package:sylvera_fe/products/view/product_list_screen.dart';
import 'package:sylvera_fe/variant_price/cubit/variant_price_cubit.dart';
import 'firebase_options.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/auth_state.dart';
import 'auth/view/sign_in_screen.dart';
import 'api/api_client.dart';
import 'products/cubit/product_cubit.dart';
import 'cart/cubit/cart_cubit.dart';
import 'theme/app_theme.dart';

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
          create: (context) =>
              ProductCubit(apiClient: context.read<ApiClient>()),
        ),
        BlocProvider(
          create: (context) =>
              VariantPriceCubit(apiClient: context.read<ApiClient>()),
        ),
        BlocProvider(
          create: (context) => CartCubit(apiClient: context.read<ApiClient>()),
        ),
        BlocProvider(
          create: (context) =>
              CategoryCubit(apiClient: context.read<ApiClient>())..fetchCategories(),
        ),
      ],
      child: CupertinoApp(
        title: 'Sylvera',
        theme: AppTheme.cupertinoTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const MainTabScaffold();
            }
            if (state is AuthUnauthenticated || state is AuthError) {
              return const SignInScreen();
            }
            return const CupertinoPageScaffold(
              child: Center(child: CupertinoActivityIndicator()),
            );
          },
        ),
      ),
    );
  }
}
class MainTabScaffold extends StatelessWidget {
  const MainTabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.ink,
        activeColor: AppColors.garnet,
        inactiveColor: AppColors.muted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Account',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const CupertinoTabView(builder: _buildCatalogTab);
          case 1:
            return const CupertinoTabView(builder: _buildCartTab);
          default:
            return const CupertinoTabView(builder: _buildAccountTab);
        }
      },
    );
  }
}

Widget _buildCatalogTab(BuildContext context) => const ProductListScreen();
Widget _buildCartTab(BuildContext context) => const CartScreen();
Widget _buildAccountTab(BuildContext context) => const AccountScreen();