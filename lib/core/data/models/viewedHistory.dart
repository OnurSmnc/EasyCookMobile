import 'package:easycook/core/data/models/recipes.dart';

class ViewedRecipeHistoryItem {
  final String viewedDate;
  final int recipeId;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;
  final int? id;
  final String? image;
  final CalorieDto? calorieDto;
  final int? preparationTime;

  ViewedRecipeHistoryItem({
    required this.viewedDate,
    required this.recipeId,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
    this.id,
    this.image,
    this.preparationTime,
    this.calorieDto,
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
      image: json['image'] != null ? json['image'] as String : null,
      calorieDto: json['calorieDto'] != null
          ? CalorieDto.fromJson(json['calorieDto'])
          : null,
      preparationTime: json['preparationTime'] ?? 0,
    );
  }
}
