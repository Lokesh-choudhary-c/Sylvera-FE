import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_client.dart';
import '../../products/models/product.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final ApiClient _apiClient;

  CategoryCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final response = await _apiClient.dio.get('/categories');
      final categories = (response.data as List<dynamic>)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }
}