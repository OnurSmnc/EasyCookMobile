import 'package:easycook/core/data/models/recipe_dto.dart';

class RecipeMadedGetResponse {
  final int recipeId;
  final int viewedRecipeId;
  final DateTime createdDate;
  final RecipeDto recipeDto;

  RecipeMadedGetResponse({
    required this.recipeId,
    required this.viewedRecipeId,
    required this.createdDate,
    required this.recipeDto,
  });

  factory RecipeMadedGetResponse.fromJson(Map<String, dynamic> json) {
    return RecipeMadedGetResponse(
      recipeId: json['recipeId'],
      viewedRecipeId: json['viewedRecipeId'],
      createdDate: DateTime.parse(json['createdDate']),
      recipeDto: RecipeDto.fromJson(json['recipeDto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'viewedRecipeId': viewedRecipeId,
      'createdDate': createdDate.toIso8601String(),
      'recipeDto': recipeDto.toJson(),
    };
  }
}
