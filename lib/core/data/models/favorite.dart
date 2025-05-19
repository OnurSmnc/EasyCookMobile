class Favorite {
  final int? id;
  final String userId;
  final int? viewedRecipesId;
  final ViewedRecipe viewedRecipe;

  Favorite({
    required this.id,
    required this.userId,
    required this.viewedRecipesId,
    required this.viewedRecipe,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] ?? 0,
      userId: json['userId'],
      viewedRecipesId: json['viewedRecipesId'] ?? 0,
      viewedRecipe: ViewedRecipe.fromJson(json[
          'viewedRecipes']), // Burada ViewedRecipe modelini doldurmalısınız
    );
  }
}

class ViewedRecipe {
  final String viewedDate;
  final int recipeId;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;

  ViewedRecipe({
    required this.viewedDate,
    required this.recipeId,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
  });

  factory ViewedRecipe.fromJson(Map<String, dynamic> json) {
    return ViewedRecipe(
      viewedDate: json['viewedDate'],
      recipeId: json['recipeId'],
      title: json['title'],
      url: json['url'],
      ingredients: json['ingredients'],
      recipeFood: json['recipeFood'],
    );
  }
}
