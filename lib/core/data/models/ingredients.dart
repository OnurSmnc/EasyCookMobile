class Ingredient {
  final int id;
  final String name;
  final String quantity;

  Ingredient({required this.id, required this.name, required this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        name: json['name'], quantity: json['quantity'], id: json['id']);
  }
}
