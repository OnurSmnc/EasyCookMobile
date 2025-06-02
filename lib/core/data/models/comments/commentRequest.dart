class CommentRequest {
  String comment;
  int recipeId;
  double rating;
  int viewedRecipesId;

  CommentRequest(
      {required this.comment,
      required this.recipeId,
      required this.rating,
      required this.viewedRecipesId});
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'recipeId': recipeId,
      'score': rating,
      'viewedRecipesId': viewedRecipesId,
    };
  }

  CommentRequest.fromJson(Map<String, dynamic> json)
      : comment = json['comment'] ?? '',
        recipeId = json['recipeId'] ?? 0,
        rating = (json['score'] != null)
            ? double.parse(json['score'].toString())
            : 0.0,
        viewedRecipesId = json['viewedRecipesId'] ?? 0;
}

class CommentRequestResponse {
  String message;
  int commentId;
  int viewedRecipesId;
  int recipeId;

  CommentRequestResponse({
    required this.message,
    required this.commentId,
    required this.recipeId,
    required this.viewedRecipesId,
  });

  factory CommentRequestResponse.fromJson(Map<String, dynamic> json) {
    return CommentRequestResponse(
      message: json['message'] as String,
      commentId: json['commentId'] != null ? json['commentId'] as int : 0,
      recipeId: json['recipeId'] != null ? json['recipeId'] as int : 0,
      viewedRecipesId:
          json['viewedRecipesId'] != null ? json['viewedRecipesId'] as int : 0,
    );
  }
}
