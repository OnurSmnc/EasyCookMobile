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

class RemoveFavoriteRequset {
  final int favoriteId;

  RemoveFavoriteRequset({
    required this.favoriteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
    };
  }

  @override
  String toString() {
    return 'RemoveFavoriteRequset(favoriteId: $favoriteId)';
  }
}

class FavoriteResponse {
  final String message;
  final int? favoriteId;
  final int viewedRecipesId;

  FavoriteResponse({
    required this.message,
    this.favoriteId,
    required this.viewedRecipesId,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      message: json['message'] as String,
      favoriteId: json['favoriteId'] != null ? json['favoriteId'] as int : null,
      viewedRecipesId:
          json['viewedRecipesId'] != null ? json['viewedRecipesId'] as int : 0,
    );
  }

  @override
  String toString() {
    return 'RemoveFavoriteResponse(message: $message, favoriteId: $favoriteId, viewedRecipesId: $viewedRecipesId)';
  }
}

class ViewedRecipe {
  final String viewedDate;
  final int recipeId;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;
  final int id;

  ViewedRecipe({
    required this.viewedDate,
    required this.recipeId,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
    required this.id,
  });

  factory ViewedRecipe.fromJson(Map<String, dynamic> json) {
    return ViewedRecipe(
      viewedDate: json['viewedDate'],
      recipeId: json['recipeId'],
      title: json['title'],
      url: json['url'],
      ingredients: json['ingredients'],
      recipeFood: json['recipeFood'],
      id: json['id'] != null ? json['id'] as int : 0,
    );
  }
}
