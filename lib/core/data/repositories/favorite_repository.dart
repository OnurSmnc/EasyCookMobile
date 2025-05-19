import 'package:easycook/core/data/models/favorite.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class FavoriteRepository {
  // This class will handle the favorite recipes
  // and their storage using Hive or any other local storage solution.

  final ApiService _apiService;

  FavoriteRepository(this._apiService);

  // Add a recipe to favorites

  Future<bool> addFavoriteRecipe(int viewedRecipeId) async {
    DateTime createdDate = DateTime.now();

    try {
      final Map<String, dynamic> requestBody = {
        'viewedRecipesId': viewedRecipeId,
      };

      print('POST URL: ${ApiConstats.baseUrl}${ApiConstats.addFavorite}');
      print('Request body: $requestBody');

      final response = await _apiService.post(
        ApiConstats.addFavorite,
        requestBody,
      );

      print('Favorite recipe response: $response');

      return response != null;
    } catch (e) {
      print('FavoriteRepository - addFavoriteRecipe error: $e');
      rethrow;
    }
  }

  Future<int?> addViewedRecipeAndReturnId(int recipeId) async {
    DateTime createdDate = DateTime.now();

    try {
      final Map<String, dynamic> requestBody = {
        'recipeId': recipeId,
        'createdDate': createdDate.toIso8601String(),
      };

      print('POST URL: ${ApiConstats.baseUrl}${ApiConstats.addViewedRecipes}');
      print('Request body: $requestBody');

      final response = await _apiService.post(
        ApiConstats.addViewedRecipes,
        requestBody,
      );

      print('Viewed recipe response: $response');

      // API integer ID döndürüyorsa:
      if (response is int) {
        return response;
      }
      // Eğer response map ise ve içinde id varsa:
      if (response is Map && response['id'] != null) {
        return response['id'];
      }
      return null;
    } catch (e) {
      print('ViewedRecipeRepository - addViewedRecipeAndReturnId error: $e');
      return null;
    }
  }

  Future<List<Favorite>> getFavorites() async {
    try {
      final response = await _apiService.get(ApiConstats.getFavorite);
      print('favorite response: $response');
      final List<dynamic> data = response as List<dynamic>;
      print('favorite data: $data');

      return data.map((e) => Favorite.fromJson(e)).toList();
    } catch (e) {
      print('FavoriteRepository - getFavorites error: $e');
      return [];
    }
  }
}
