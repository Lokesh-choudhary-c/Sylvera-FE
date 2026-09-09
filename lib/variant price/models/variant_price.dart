class VariantPrice {
  final String variantId;
  final double calculatedPrice;

  VariantPrice({
    required this.variantId,
    required this.calculatedPrice,
  });

  factory VariantPrice.fromJson(Map<String, dynamic> json) {
    return VariantPrice(
      variantId: json['variant_id'] as String,
      // Real JS number here, not a Prisma Decimal string — direct cast is fine.
      calculatedPrice: (json['calculated_price'] as num).toDouble(),
    );
  }
}