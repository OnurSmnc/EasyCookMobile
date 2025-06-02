class GetCommentResponse {
  final int recipeId;
  final int viewedRecipesId;
  final String comment;
  final String? image; // nullable
  final String nickName;
  final double score;

  GetCommentResponse({
    required this.recipeId,
    required this.viewedRecipesId,
    required this.comment,
    required this.image,
    required this.nickName,
    required this.score,
  });

  factory GetCommentResponse.fromJson(Map<String, dynamic> json) {
    return GetCommentResponse(
      recipeId: json['recipeId'] ?? 0,
      viewedRecipesId: json['viewedRecipesId'] ?? 0,
      comment: json['comment'] ?? '',
      image: json['image'], // nullable
      nickName: json['nickName'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
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
