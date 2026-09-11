import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Cart')),
      child: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading || state is CartInitial) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is CartError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, style: AppTextStyles.body),
                ),
              );
            }
            final loaded = state as CartLoaded;
            final isBusy = state is CartActionInProgress;

            if (loaded.items.isEmpty) {
              return Center(
                child: Text(
                  'Your cart is empty.',
                  style: AppTextStyles.body,
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: loaded.items.length,
                    separatorBuilder: (_, __) => Container(
                      height: 1,
                      color: AppColors.muted.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    itemBuilder: (context, index) {
                      final item = loaded.items[index];
                      return _CartItemTile(item: item, disabled: isBusy);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(
                          color: AppColors.muted.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.body),
                      Text(
                        '₹${loaded.cartTotal.toStringAsFixed(0)}',
                        style: AppTextStyles.headline
                            .copyWith(color: AppColors.garnet),
                      ),
                    ],
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

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool disabled;
  const _CartItemTile({required this.item, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name, style: AppTextStyles.headline),
              const SizedBox(height: 4),
              Text(
                '${item.variant.variantType}: ${item.variant.variantValue}',
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 28,
                    onPressed: disabled || item.quantity <= 1
                        ? null
                        : () => cubit.updateQuantity(
                            item.cartItemId, item.quantity - 1),
                    child: const Icon(CupertinoIcons.minus_circle, size: 22),
                  ),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 28,
                    onPressed: disabled
                        ? null
                        : () => cubit.updateQuantity(
                            item.cartItemId, item.quantity + 1),
                    child: const Icon(CupertinoIcons.add_circled, size: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${item.lineTotal.toStringAsFixed(0)}',
              style: AppTextStyles.priceLabel,
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 28,
              onPressed:
                  disabled ? null : () => cubit.removeItem(item.cartItemId),
              child: const Icon(
                CupertinoIcons.delete,
                size: 20,
                color: AppColors.garnet,
              ),
            ),
          ],
        ),
      ],
    );
  }
}