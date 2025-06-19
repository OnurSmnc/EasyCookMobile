class Recipes {
  final int id;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;
  final String? createdDate;
  final String? image;
  final int? preparationTime;
  final CalorieDto? calorieDto;

  Recipes({
    required this.id,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
    this.createdDate,
    this.image,
    this.calorieDto,
    this.preparationTime,
  });

  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
        id: json['id'],
        title: json['title'],
        url: json['url'],
        ingredients: json['ingredients'],
        recipeFood: json['recipeFood'],
        createdDate: json['createdDate'],
        image: json['image'], // Optional field, can be null
        calorieDto: json['calorieDto'] != null
            ? CalorieDto.fromJson(json['calorieDto'])
            : null,
        preparationTime: json['preparationTime'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'ingredients': ingredients,
      'recipeFood': recipeFood,
      'createdDate': createdDate,
      'image': image, // Optional field, can be null
    };
  }
}

class CalorieDto {
  final int calorie;
  final String? userId;

  CalorieDto({required this.calorie, this.userId});

  factory CalorieDto.fromJson(Map<String, dynamic> json) {
    return CalorieDto(
      calorie: json['calorie'] as int,
      userId: json['userId']?.toString(),
    );
  }
}
