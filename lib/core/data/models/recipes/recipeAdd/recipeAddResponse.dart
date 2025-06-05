class RecipeAddResponse {
  final String message;

  RecipeAddResponse({required this.message});

  factory RecipeAddResponse.fromJson(Map<String, dynamic> json) {
    return RecipeAddResponse(message: json['message'] as String);
  }
}
