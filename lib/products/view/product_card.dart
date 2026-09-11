import 'package:flutter/cupertino.dart';
import '../../theme/app_theme.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isGold = product.metalType == 'gold';
    final swatchGradient =
        isGold ? AppColors.goldGradient : AppColors.silverGradient;

    final specLine = product.pricingType == 'fixed'
        ? 'Fixed price'
        : [
            if (product.metalType != null) product.metalType!,
            if (product.purity != null) product.purity!,
            if (product.netWeightGrams != null)
              '${product.netWeightGrams!.toStringAsFixed(1)}g',
          ].join(' · ');

    final priceLabel = product.pricingType == 'fixed'
        ? (product.fixedPrice != null
            ? '₹${product.fixedPrice!.toStringAsFixed(0)}'
            : '—')
        : 'Weight-based';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.muted.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(gradient: swatchGradient),
            ),
          ),
          Container(height: 1, color: AppColors.muted.withOpacity(0.25)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  specLine,
                  style: AppTextStyles.bodyMuted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(priceLabel, style: AppTextStyles.priceLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}