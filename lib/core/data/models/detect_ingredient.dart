class DetectedIngredient {
  final int id;
  final String name;
  final String? image;

  DetectedIngredient({
    required this.id,
    required this.name,
    this.image,
  });

  factory DetectedIngredient.fromJson(Map<String, dynamic> json) {
    return DetectedIngredient(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
