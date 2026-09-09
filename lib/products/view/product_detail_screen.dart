import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sylvera_fe/variant%20price/cubit/variant_price_cubit.dart';
import 'package:sylvera_fe/variant%20price/cubit/variant_price_state.dart';
import '../../theme/app_theme.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasVariants = product.variants.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart')),
            );
          }
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                [
                  if (product.metalType != null) product.metalType!,
                  if (product.purity != null) product.purity!,
                ].join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              if (!hasVariants)
                Text(
                  'This item has no purchasable options yet.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.muted),
                )
              else ...[
                Text('Options', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: product.variants.map((variant) {
                    final isSelected =
                        variant.variantId == _selectedVariant?.variantId;
                    return ChoiceChip(
                      label: Text(variant.variantValue),
                      selected: isSelected,
                      onSelected: (_) => _selectVariant(variant),
                      selectedColor: AppColors.garnet,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.ivory : AppColors.muted,
                      ),
                      backgroundColor: AppColors.surface,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    Text('$_quantity',
                        style: Theme.of(context).textTheme.bodyMedium),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<VariantPriceCubit, VariantPriceState>(
                  builder: (context, state) {
                    if (state is VariantPriceLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (state is VariantPriceError) {
                      return Text(state.message,
                          style: const TextStyle(color: AppColors.garnet));
                    }
                    if (state is VariantPriceLoaded) {
                      return Text(
                        '₹${state.price.calculatedPrice.toStringAsFixed(0)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: AppColors.garnet),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final isLoading = state is CartLoading;
                    return ElevatedButton(
                      onPressed: isLoading || _selectedVariant == null
                          ? null
                          : () {
                              context.read<CartCubit>().addToCart(
                                    variantId: _selectedVariant!.variantId,
                                    quantity: _quantity,
                                  );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add to cart'),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}