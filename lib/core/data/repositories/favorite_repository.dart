import 'package:easycook/core/data/models/favorite.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class FavoriteRepository {
  // This class will handle the favorite recipes
  // and their storage using Hive or any other local storage solution.

  final ApiService _api = ApiService();

  FavoriteRepository();

  // Add a recipe to favorites

  Future<FavoriteResponse> addFavoriteRecipe(int viewedRecipeId) async {
    DateTime createdDate = DateTime.now();

    try {
      final Map<String, dynamic> requestBody = {
        'viewedRecipesId': viewedRecipeId,
      };

      print('POST URL: ${ApiConstats.baseUrl}${ApiConstats.addFavorite}');
      print('Request body: $requestBody');

      final response = await _api.post(
        ApiConstats.addFavorite,
        requestBody,
      );

      return FavoriteResponse.fromJson(response);
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

      final response = await _api.post(
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
      final response = await _api.get(ApiConstats.getFavorite);
      print('favorite response: $response');
      final List<dynamic> data = response as List<dynamic>;
      print('favorite data: $data');

      return data.map((e) => Favorite.fromJson(e)).toList();
    } catch (e) {
      print('FavoriteRepository - getFavorites error: $e');
      return [];
    }
  }

  Future<FavoriteResponse> removeFavorite(RemoveFavoriteRequset request) async {
    try {
      final response = await _api.post(
        ApiConstats.removeFavorite,
        request.toJson(),
      );

      return FavoriteResponse.fromJson(response);
    } catch (e) {
      print('FavoriteRepository - removeFavorite error: $e');
      rethrow;
    }
  }
}
