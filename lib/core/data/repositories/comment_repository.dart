import 'package:easycook/core/data/models/comments/commentRequest.dart';
import 'package:easycook/core/data/models/comments/commentResponse.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class CommentRepository {
  final ApiService _apiService = ApiService(baseUrl: ApiConstats.baseUrl);

  CommentRepository();

  Future<CommentRequestResponse> addComment(CommentRequest request) async {
    try {
      final Map<String, dynamic> requestBody = {
        'recipeId': request.recipeId,
        'comment': request.comment,
        'viewedRecipesId': request.viewedRecipesId,
        'score': request.rating,
      };

      print('POST URL: ${ApiConstats.baseUrl}${ApiConstats.addComment}');
      print('Request body: $requestBody');

      final response =
          await _apiService.post(ApiConstats.addComment, requestBody);
      return CommentRequestResponse.fromJson(response);
    } catch (e) {
      print('CommentRepository - addComment error: $e');
      rethrow;
    }
  }

  Future<List<GetCommentResponse>> getComments(int recipeId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstats.getComment}?recipeId=$recipeId',
      );
      print('data: $response');
      if (response is List) {
        return response
            .map((comment) => GetCommentResponse.fromJson(comment))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('CommentRepository - getComments error: $e');
      rethrow;
    }
  }
}
