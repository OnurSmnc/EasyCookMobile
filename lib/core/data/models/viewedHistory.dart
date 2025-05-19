class ViewedRecipeHistoryItem {
  final String viewedDate;
  final int recipeId;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;

  ViewedRecipeHistoryItem({
    required this.viewedDate,
    required this.recipeId,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
  });

  factory ViewedRecipeHistoryItem.fromJson(Map<String, dynamic> json) {
    return ViewedRecipeHistoryItem(
      viewedDate: json['viewedDate'],
      recipeId: json['recipeId'],
      title: json['title'],
      url: json['url'],
      ingredients: json['ingredients'],
      recipeFood: json['recipeFood'],
    );
  }
}
