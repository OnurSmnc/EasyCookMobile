import 'dart:convert';
import 'dart:io';
import 'package:easycook/core/data/models/recipeapiresponse.dart';
import 'package:easycook/core/data/models/recipes.dart';
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
}
