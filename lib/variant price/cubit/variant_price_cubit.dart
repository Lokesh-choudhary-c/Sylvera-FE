import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_client.dart';
import '../models/variant_price.dart';
import 'variant_price_state.dart';

class VariantPriceCubit extends Cubit<VariantPriceState> {
  final ApiClient _apiClient;

  VariantPriceCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(VariantPriceInitial());

  Future<void> fetchPrice(String variantId) async {
    emit(VariantPriceLoading());
    try {
      final response =
          await _apiClient.dio.get('/products/variants/$variantId/price');
      emit(VariantPriceLoaded(VariantPrice.fromJson(response.data)));
    } catch (e) {
      emit(VariantPriceError('Failed to load price: $e'));
    }
  }
}