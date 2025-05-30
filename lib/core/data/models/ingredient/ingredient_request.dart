class IngredientData {
  final int id;
  final String name;
  final String image;

  IngredientData({
    required this.id,
    required this.name,
    required this.image,
  });

  // Factory method to create an Ingredient from a JSON map
  factory IngredientData.fromJson(Map<String, dynamic> json) {
    return IngredientData(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  // Method to convert an Ingredient object to a JSON map (optional, but good practice)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
