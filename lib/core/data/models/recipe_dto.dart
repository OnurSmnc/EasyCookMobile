class RecipeDto {
  final int recipeId;
  final String title;
  final String url;
  final String? image;
  final String recipeFood;
  final String ingredients;

  RecipeDto({
    required this.recipeId,
    required this.title,
    required this.url,
    required this.image,
    required this.recipeFood,
    required this.ingredients,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    return RecipeDto(
      recipeId: json['recipeId'],
      title: json['title'],
      url: json['url'],
      image: json['image'],
      recipeFood: json['recipeFood'],
      ingredients: json['ingredients'],
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
