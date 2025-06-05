class GetCommentResponse {
  final int recipeId;
  final int viewedRecipesId;
  final String comment;
  final String? image; // nullable
  final String nickName;
  final double score;
  final DateTime createdAt;

  GetCommentResponse({
    required this.recipeId,
    required this.viewedRecipesId,
    required this.comment,
    required this.image,
    required this.nickName,
    required this.score,
    required this.createdAt,
  });

  factory GetCommentResponse.fromJson(Map<String, dynamic> json) {
    return GetCommentResponse(
      recipeId: json['recipeId'] ?? 0,
      viewedRecipesId: json['viewedRecipesId'] ?? 0,
      comment: json['comment'] ?? '',
      image: json['image'], // nullable
      nickName: json['nickName'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
          json['createdDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class GetCommentRequest {
  final String? recipeId;

  GetCommentRequest({
    this.recipeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
    };
  }
}
