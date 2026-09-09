class Category {
  final String categoryId;
  final String name;
  final String? parentCategoryId;

  Category({
    required this.categoryId,
    required this.name,
    this.parentCategoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      parentCategoryId: json['parent_category_id'] as String?,
    );
  }
}

class ProductVariant {
  final String variantId;
  final String productId;
  final String variantType;
  final String variantValue;
  final double? netWeightGrams;
  final double? fixedPriceOverride;
  final int stockQuantity;
  final String? skuSuffix;
  final bool isActive;

  ProductVariant({
    required this.variantId,
    required this.productId,
    required this.variantType,
    required this.variantValue,
    this.netWeightGrams,
    this.fixedPriceOverride,
    required this.stockQuantity,
    this.skuSuffix,
    required this.isActive,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      variantId: json['variant_id'] as String,
      productId: json['product_id'] as String,
      variantType: json['variant_type'] as String,
      variantValue: json['variant_value'] as String,
      netWeightGrams: _parseDecimal(json['net_weight_grams']),
      fixedPriceOverride: _parseDecimal(json['fixed_price_override']),
      stockQuantity: json['stock_quantity'] as int,
      skuSuffix: json['sku_suffix'] as String?,
      isActive: json['is_active'] as bool,
    );
  }
}

class Product {
  final String productId;
  final String name;
  final String? description;
  final String sku;
  final String? categoryId;
  final String pricingType; // 'weight_based' or 'fixed'
  final String? metalType;
  final String? purity;
  final double? grossWeightGrams;
  final double? netWeightGrams;
  final String? makingChargeType;
  final double? makingChargeValue;
  final double? stoneCharge;
  final double? fixedPrice;
  final double? taxPercent;
  final bool isActive;
  final List<ProductVariant> variants;
  final Category? category;

  Product({
    required this.productId,
    required this.name,
    this.description,
    required this.sku,
    this.categoryId,
    required this.pricingType,
    this.metalType,
    this.purity,
    this.grossWeightGrams,
    this.netWeightGrams,
    this.makingChargeType,
    this.makingChargeValue,
    this.stoneCharge,
    this.fixedPrice,
    this.taxPercent,
    required this.isActive,
    this.variants = const [],
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      sku: json['sku'] as String,
      categoryId: json['category_id'] as String?,
      pricingType: json['pricing_type'] as String,
      metalType: json['metal_type'] as String?,
      purity: json['purity'] as String?,
      grossWeightGrams: _parseDecimal(json['gross_weight_grams']),
      netWeightGrams: _parseDecimal(json['net_weight_grams']),
      makingChargeType: json['making_charge_type'] as String?,
      makingChargeValue: _parseDecimal(json['making_charge_value']),
      stoneCharge: _parseDecimal(json['stone_charge']),
      fixedPrice: _parseDecimal(json['fixed_price']),
      taxPercent: _parseDecimal(json['tax_percent']),
      isActive: json['is_active'] as bool,
      variants: (json['product_variants'] as List<dynamic>?)
              ?.map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList() ??
          const [],
      category: json['categories'] != null
          ? Category.fromJson(json['categories'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Prisma serializes Decimal fields as JSON strings (e.g. "300", "1.5"),
/// and some are nullable. This handles both null and string-vs-num safely.
double? _parseDecimal(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}