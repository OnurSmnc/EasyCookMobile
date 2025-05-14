import 'package:easycook/core/data/models/detect_ingredient.dart';
import 'package:easycook/core/data/models/recipes.dart';

class RecipeApiResponse {
  final List<DetectedIngredient> detectedIngredients;
  final List<Recipes> recipes;

  RecipeApiResponse({
    required this.detectedIngredients,
    required this.recipes,
  });

  factory RecipeApiResponse.fromJson(Map<String, dynamic> json) {
    return RecipeApiResponse(
      detectedIngredients: (json['detectedIngredients'] as List)
          .map((e) => DetectedIngredient.fromJson(e))
          .toList(),
      recipes:
          (json['recipes'] as List).map((e) => Recipes.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detectedIngredients':
          detectedIngredients.map((e) => e.toJson()).toList(),
      'recipes': recipes.map((e) => e.toJson()).toList(),
    };
  }
}
