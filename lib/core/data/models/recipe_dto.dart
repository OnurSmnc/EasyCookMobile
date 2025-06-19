class RecipeDto {
  final int recipeId;
  final String title;
  final String url;
  final String? image;
  final String recipeFood;
  final int? preparationTime;
  final String ingredients;

  RecipeDto({
    required this.recipeId,
    required this.title,
    required this.url,
    this.image,
    this.preparationTime,
    required this.recipeFood,
    required this.ingredients,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    return RecipeDto(
      recipeId: json['recipeId'],
      title: json['title'],
      url: json['url'],
      recipeFood: json['recipeFood'],
      ingredients: json['ingredients'],
      image: json['image'] != null ? json['image'] as String : null,
      preparationTime: json['preparationTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'title': title,
      'url': url,
      'image': image,
      'recipeFood': recipeFood,
      'ingredients': ingredients,
    };
  }
}
