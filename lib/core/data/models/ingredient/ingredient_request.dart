class IngredientData {
  final int id;
  final String? name;
  final String? image;

  IngredientData({
    required this.id,
    this.name,
    this.image,
  });

  // Factory method to create an Ingredient from a JSON map
  factory IngredientData.fromJson(Map<String, dynamic> json) {
    return IngredientData(
      id: json['id'] as int,
      name: json['name'] as String?,
      image: json['image'] as String?,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
