import 'dart:ffi';

import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/service/api_constants.dart';

class ViewedRecipeRepository {
  final ApiService _apiService;

  ViewedRecipeRepository(this._apiService);

  Future<int?> addViewedRecipe(int recipeId) async {
    try {
      final Map<String, dynamic> requestBody = {
        'recipeId': recipeId,
        'createdDate': DateTime.now().toIso8601String(),
      };

      final response = await _apiService.post(
        ApiConstats.addViewedRecipes,
        requestBody,
      );

      // API integer ID döndürüyorsa:
      if (response is int) return response;
      // Eğer response map ise ve içinde id varsa:
      if (response is Map && response['id'] != null) return response['id'];
      return null;
    } catch (e) {
      print('ViewedRecipeRepository - addViewedRecipeAndReturnId error: $e');
      return null;
    }
  }

  // Görüntülenen tarif geçmişini getir
  // Future<ViewedHistoryQueryResponse> getAllViewedHistory() async {
  //   try {
  //     final response = await _apiService.get(ApiConstats.viewedRecipes);
  //     return ViewedHistoryQueryResponse.fromJson(response);
  //   } catch (e) {
  //     throw Exception('Görüntüleme geçmişi alınamadı: $e');
  //   }
  // }

  // Belirli bir tarihin görüntüleme geçmişini getir
  // Future<ViewedHistoryQueryResponse> getViewedHistoryByDate(
  //     DateTime date) async {
  //   try {
  //     final formattedDate = date.toIso8601String();
  //     final response = await _apiService
  //         .get('${ApiConstats.viewedRecipes}?date=$formattedDate');
  //     return ViewedHistoryQueryResponse.fromJson(response);
  //   } catch (e) {
  //     throw Exception('Tarihli görüntüleme geçmişi alınamadı: $e');
  //   }
  // }

  // // Belirli bir kullanıcının görüntüleme geçmişini getir
  // Future<ViewedHistoryQueryResponse> getViewedHistoryByUserId(
  //     String userId) async {
  //   try {
  //     final response =
  //         await _apiService.get('${ApiConstats.viewedRecipes}/$userId');
  //     return ViewedHistoryQueryResponse.fromJson(response);
  //   } catch (e) {
  //     throw Exception('Kullanıcı görüntüleme geçmişi alınamadı: $e');
  //   }
  // }
}
