class ViewedRecipeHistoryItem {
  final String viewedDate;
  final int recipeId;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;
  final int? id;
  ViewedRecipeHistoryItem({
    required this.viewedDate,
    required this.recipeId,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
    this.id,
  });

  factory ViewedRecipeHistoryItem.fromJson(Map<String, dynamic> json) {
    return ViewedRecipeHistoryItem(
      viewedDate: json['viewedDate'],
      recipeId: json['recipeId'],
      title: json['title'],
      url: json['url'],
      ingredients: json['ingredients'],
      recipeFood: json['recipeFood'],
      id: json['id'] != null ? json['id'] as int : null,
    );
  }
}
