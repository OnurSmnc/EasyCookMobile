import 'dart:convert';
import 'dart:io';
import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';
import 'package:easycook/core/data/models/recipeapiresponse.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/models/recipes/recipeAdd/RecipeAddRequest.dart';
import 'package:easycook/core/data/models/recipes/recipeAdd/get_recipe_made_response.dart';
import 'package:easycook/core/data/models/recipes/recipeAdd/recipeAddResponse.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RecipeRepository {
  final ApiService _api = ApiService();

  RecipeRepository();

  Future<RecipeApiResponse> detectIngredientsFromImage(File imageFile) async {
    try {
      final response = await _api.uploadFile(
        ApiConstats.detectIngredients,
        imageFile,
        fieldName: 'file', // API bu alan adını bekliyorsa
      );

      return RecipeApiResponse.fromJson(response);
    } catch (e) {
      throw Exception('Malzeme tespiti başarısız: $e');
    }
  }

  Future<List<Recipes>> getRecommendationRecipesAsync() async {
    try {
      final response = await _api.get(ApiConstats.getRecommendedRecipes);

      if (response != null) {
        final data = response is String ? jsonDecode(response) : response;

        final list =
            (data as List).map((item) => Recipes.fromJson(item)).toList();
        return list.toList();
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<Recipes>> getAllRecipesBySearch(
      List<IngredientData> request) async {
    try {
      final body = {
        "ingredientList": request.map((e) => e.toJson()).toList(),
      };

      final response = await _api.post(
        ApiConstats.getAllRecipes,
        body,
      );

      if (response != null) {
        final data = response is String ? jsonDecode(response) : response;

        final list =
            (data as List).map((item) => Recipes.fromJson(item)).toList();
        return list.toList();
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<RecipeAddResponse> madeRecipe(RecipeAddRequest request) async {
    try {
      final response = await _api.post(
        ApiConstats.madeRecipe,
        request.toJson(),
      );

      if (response != null) {
        final data = response is String ? jsonDecode(response) : response;
        return RecipeAddResponse.fromJson(data);
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<List<RecipeMadedGetResponse>> getMadedRecipeAsync() async {
    try {
      final response = await _api.get(ApiConstats.getRecipeMaded);

      if (response != null) {
        final data = response is String ? jsonDecode(response) : response;
        final list = (data as List)
            .map((item) => RecipeMadedGetResponse.fromJson(item))
            .toList();
        return list.reversed.toList();
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
