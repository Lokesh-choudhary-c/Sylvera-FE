import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sylvera_fe/category/cubit/category_cubit.dart';
import 'package:sylvera_fe/category/cubit/category_state.dart';
import 'package:sylvera_fe/products/view/product_detail_screen.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../../theme/app_theme.dart';
import 'product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _selectedCategoryId; // null means "All"

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Catalog'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _CategoryFilterRow(
              selectedCategoryId: _selectedCategoryId,
              onSelect: (id) => setState(() => _selectedCategoryId = id),
            ),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading || state is ProductInitial) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (state is ProductError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "Couldn't load your catalog. ${state.message}",
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final allProducts = (state as ProductLoaded).products;
                  final products = _selectedCategoryId == null
                      ? allProducts
                      : allProducts
                          .where((p) =>
                              p.categoryId == _selectedCategoryId)
                          .toList();

                  if (products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          allProducts.isEmpty
                              ? 'Your catalog is empty. Add a product from the backend to see it here.'
                              : 'No products in this category yet.',
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelect;

  const _CategoryFilterRow({
    required this.selectedCategoryId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is! CategoryLoaded || state.categories.isEmpty) {
          // Loading, error, or simply no categories yet — the catalog
          // still works fine unfiltered, so this row just disappears
          // rather than showing a spinner or error of its own.
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _FilterChip(
                label: 'All',
                isSelected: selectedCategoryId == null,
                onTap: () => onSelect(null),
              ),
              const SizedBox(width: 8),
              for (final category in state.categories) ...[
                _FilterChip(
                  label: category.name,
                  isSelected: selectedCategoryId == category.categoryId,
                  onTap: () => onSelect(category.categoryId),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.garnet : AppColors.surface,
          border: Border.all(
            color: isSelected
                ? AppColors.garnet
                : AppColors.muted.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isSelected ? AppColors.ivory : AppColors.muted,
          ),
        ),
      ),
    );
  }
}