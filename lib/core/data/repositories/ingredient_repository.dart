import 'package:easycook/core/data/models/allergenics/allergenic_request.dart';
import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class IngredientRepository {
  final ApiService _apiService = ApiService(baseUrl: ApiConstats.baseUrl);

  Future<List<IngredientData>> getAllIngredients() async {
    try {
      final dynamic response =
          await _apiService.get(ApiConstats.getIngredients);
      print('API Response for Ingredients: $response');

      if (response is List) {
        final List<IngredientData> ingredients = response
            .map((e) => IngredientData.fromJson(e as Map<String, dynamic>))
            .toList();

        return ingredients;
      } else {
        print(
            'Error: API did not return a list for ingredients. Response type: ${response.runtimeType}');
        throw Exception('Invalid API response format for all ingredients.');
      }
    } catch (e) {
      print('Error in getAllIngredients: $e'); // Log the error
      rethrow;
    }
  }

  Future<dynamic> addIngredient(AllergyRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstats.addAllergy,
        request.toJson(),
      );
      return response;
    } catch (e) {
      print('Error in addIngredient: $e'); // Log the error
      rethrow;
    }
  }
}
