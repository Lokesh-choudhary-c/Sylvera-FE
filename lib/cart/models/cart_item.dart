class CartProductSummary {
  final String productId;
  final String name;
  final String sku;
  final String pricingType;
  final String? metalType;
  final String? purity;
  final bool isActive;

  CartProductSummary({
    required this.productId,
    required this.name,
    required this.sku,
    required this.pricingType,
    this.metalType,
    this.purity,
    required this.isActive,
  });

  factory CartProductSummary.fromJson(Map<String, dynamic> json) {
    return CartProductSummary(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      pricingType: json['pricing_type'] as String,
      metalType: json['metal_type'] as String?,
      purity: json['purity'] as String?,
      isActive: json['is_active'] as bool,
    );
  }
}

class CartVariantSummary {
  final String variantId;
  final String variantType;
  final String variantValue;

  CartVariantSummary({
    required this.variantId,
    required this.variantType,
    required this.variantValue,
  });

  factory CartVariantSummary.fromJson(Map<String, dynamic> json) {
    return CartVariantSummary(
      variantId: json['variant_id'] as String,
      variantType: json['variant_type'] as String,
      variantValue: json['variant_value'] as String,
    );
  }
}

class CartItem {
  final String cartItemId;
  final int quantity;
  final String? customizationId;
  final String? customizationText;
  final double unitPrice;
  final double lineTotal;
  final CartVariantSummary variant;
  final CartProductSummary product;

  CartItem({
    required this.cartItemId,
    required this.quantity,
    this.customizationId,
    this.customizationText,
    required this.unitPrice,
    required this.lineTotal,
    required this.variant,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final variantJson = json['product_variants'] as Map<String, dynamic>;
    final productJson = variantJson['products'] as Map<String, dynamic>;
    return CartItem(
      cartItemId: json['cart_item_id'] as String,
      quantity: json['quantity'] as int,
      customizationId: json['customization_id'] as String?,
      customizationText: json['customization_text'] as String?,
      // Real JS numbers per the BE note — direct cast, no parsing.
      unitPrice: (json['unit_price'] as num).toDouble(),
      lineTotal: (json['line_total'] as num).toDouble(),
      variant: CartVariantSummary.fromJson(variantJson),
      product: CartProductSummary.fromJson(productJson),
    );
  }
}