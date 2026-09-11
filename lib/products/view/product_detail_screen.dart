import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sylvera_fe/variant_price/cubit/variant_price_cubit.dart';
import 'package:sylvera_fe/variant_price/cubit/variant_price_state.dart';
import '../../theme/app_theme.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductVariant? _selectedVariant;
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.variants.isNotEmpty) {
      _selectVariant(widget.product.variants.first);
    }
  }

  void _selectVariant(ProductVariant variant) {
    setState(() => _selectedVariant = variant);
    context.read<VariantPriceCubit>().fetchPrice(variant.variantId);
  }

  void _showMessage(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart() async {
    setState(() => _isAddingToCart = true);
    try {
      await context.read<CartCubit>().addToCart(
            variantId: _selectedVariant!.variantId,
            quantity: _quantity,
          );
      if (mounted) _showMessage('Added to cart');
    } catch (e) {
      if (mounted) _showMessage('Failed to add to cart: $e');
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasVariants = product.variants.isNotEmpty;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(product.name),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: AppTextStyles.headline),
              const SizedBox(height: 4),
              Text(
                [
                  if (product.metalType != null) product.metalType!,
                  if (product.purity != null) product.purity!,
                ].join(' · '),
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 24),
              if (!hasVariants)
                Text(
                  'This item has no purchasable options yet.',
                  style: AppTextStyles.bodyMuted,
                )
              else ...[
                Text('Options', style: AppTextStyles.bodyMuted),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: product.variants.map((variant) {
                    final isSelected =
                        variant.variantId == _selectedVariant?.variantId;
                    return GestureDetector(
                      onTap: () => _selectVariant(variant),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.garnet
                              : AppColors.surface,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.garnet
                                : AppColors.muted.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          variant.variantValue,
                          style: AppTextStyles.body.copyWith(
                            color:
                                isSelected ? AppColors.ivory : AppColors.muted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      child: const Icon(CupertinoIcons.minus_circle),
                    ),
                    Text('$_quantity', style: AppTextStyles.body),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(() => _quantity++),
                      child: const Icon(CupertinoIcons.add_circled),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<VariantPriceCubit, VariantPriceState>(
                  builder: (context, state) {
                    if (state is VariantPriceLoading) {
                      return const CupertinoActivityIndicator();
                    }
                    if (state is VariantPriceError) {
                      return Text(
                        state.message,
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.garnet),
                      );
                    }
                    if (state is VariantPriceLoaded) {
                      return Text(
                        '₹${state.price.calculatedPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.headline
                            .copyWith(color: AppColors.garnet),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: _isAddingToCart || _selectedVariant == null
                      ? null
                      : _addToCart,
                  child: _isAddingToCart
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white)
                      : const Text('Add to cart'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}