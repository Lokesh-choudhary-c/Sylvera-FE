import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_client.dart';
import '../models/product.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ApiClient _apiClient;

  ProductCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final response = await _apiClient.dio.get('/products');
      final products = (response.data as List<dynamic>)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to load products: $e'));
    }
  }
}