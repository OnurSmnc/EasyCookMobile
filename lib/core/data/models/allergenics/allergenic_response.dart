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

class AllergenicResponseWrapper {
  final int status;
  final List<AllergenicResponse> data;

  AllergenicResponseWrapper({
    required this.status,
    required this.data,
  });

  factory AllergenicResponseWrapper.fromJson(Map<String, dynamic> json) {
    return AllergenicResponseWrapper(
      status: json['status'] as int,
      data: (json['data'] as List)
          .map((e) => AllergenicResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
