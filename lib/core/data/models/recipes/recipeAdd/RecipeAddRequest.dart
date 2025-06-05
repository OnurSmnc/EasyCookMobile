class RecipeAddRequest {
  final int recipeId;
  final int viewedRecipeId;

  RecipeAddRequest({required this.recipeId, required this.viewedRecipeId});

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'viewedRecipeId': viewedRecipeId,
    };
  }
}
