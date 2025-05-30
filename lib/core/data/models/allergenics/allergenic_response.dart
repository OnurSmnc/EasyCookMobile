import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';

class AllergenicResponse {
  final int
      id; // This seems to be an ID for the UserIngredient entry itself, not the ingredient's ID
  final int ingredientsId; // The ID of the associated ingredient
  final String userId; // The ID of the user
  final IngredientData ingredients; // The nested Ingredient object

  AllergenicResponse({
    required this.id,
    required this.ingredientsId,
    required this.userId,
    required this.ingredients,
  });

  factory AllergenicResponse.fromJson(Map<String, dynamic> json) {
    return AllergenicResponse(
      id: json['id'] as int,
      ingredientsId: json['ingredientsId'] as int,
      userId: json['userId'] as String,
      ingredients:
          IngredientData.fromJson(json['ingredients'] as Map<String, dynamic>),
    );
  }
}
