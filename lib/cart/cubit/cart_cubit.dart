import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_client.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ApiClient _apiClient;

  CartCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(CartInitial());

  Future<void> addToCart({
    required String variantId,
    required int quantity,
    String? customizationId,
    String? customizationText,
  }) async {
    emit(CartLoading());
    try {
      await _apiClient.dio.post('/cart', data: {
        'variant_id': variantId,
        'quantity': quantity,
        // Omit entirely when not provided, per the DTO note — cleaner
        // than sending explicit nulls even though both behave the same.
        if (customizationId != null) 'customization_id': customizationId,
        if (customizationText != null)
          'customization_text': customizationText,
      });
      emit(CartSuccess());
    } catch (e) {
      emit(CartError('Failed to add to cart: $e'));
    }
  }
}