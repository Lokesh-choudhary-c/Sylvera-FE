import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_client.dart';
import '../models/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ApiClient _apiClient;

  CartCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());
    try {
      final response = await _apiClient.dio.get('/cart');
      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
          .toList();
      final cartTotal = (data['cart_total'] as num).toDouble();
      emit(CartLoaded(items, cartTotal));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  Future<void> addToCart({
    required String variantId,
    required int quantity,
    String? customizationId,
    String? customizationText,
  }) async {
    await _apiClient.dio.post('/cart', data: {
      'variant_id': variantId,
      'quantity': quantity,
      if (customizationId != null) 'customization_id': customizationId,
      if (customizationText != null)
        'customization_text': customizationText,
    });
    await fetchCart();
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final current = state;
    if (current is CartLoaded) {
      emit(CartActionInProgress(current.items, current.cartTotal));
    }
    try {
      await _apiClient.dio.patch('/cart/$cartItemId', data: {
        'quantity': quantity,
      });
      await fetchCart();
    } catch (e) {
      emit(CartError('Failed to update quantity: $e'));
    }
  }

  Future<void> removeItem(String cartItemId) async {
    final current = state;
    if (current is CartLoaded) {
      emit(CartActionInProgress(current.items, current.cartTotal));
    }
    try {
      await _apiClient.dio.delete('/cart/$cartItemId');
      await fetchCart();
    } catch (e) {
      emit(CartError('Failed to remove item: $e'));
    }
  }
}