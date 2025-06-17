class Recipes {
  final int id;
  final String title;
  final String url;
  final String ingredients;
  final String recipeFood;
  final String? createdDate;
  final String? image;

  Recipes({
    required this.id,
    required this.title,
    required this.url,
    required this.ingredients,
    required this.recipeFood,
    this.createdDate,
    this.image,
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
    );
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
