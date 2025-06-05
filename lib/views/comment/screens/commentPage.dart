// lib/features/comments/widgets/comments_modal_popup.dart

import 'package:easycook/core/data/models/comments/commentRequest.dart';
import 'package:easycook/core/data/models/comments/commentResponse.dart';
import 'package:easycook/core/data/repositories/comment_repository.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/views/comment/widgets/comment_empty.dart';
import 'package:easycook/views/comment/widgets/comment_input.dart';
import 'package:easycook/views/comment/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

// Yorum modeli - bunu kendi modelinizle değiştirin
class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final double rating;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    required this.likes,
    this.isLiked = false,
    required this.rating,
  });
}

class CommentsModalPopup extends StatefulWidget {
  final int recipeId;
  final int viewedRecipesId;
  final String recipeTitle;
  final List<CommentRequestResponse> comments;
  final BuildContext parentContext;

  const CommentsModalPopup({
    Key? key,
    required this.recipeId,
    required this.recipeTitle,
    required this.comments,
    required this.viewedRecipesId,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<CommentsModalPopup> createState() => _CommentsModalPopupState();
}

class _CommentsModalPopupState extends State<CommentsModalPopup> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  double _currentRating = 5;
  final List<CommentRequestResponse> _comments = [];
  final List<GetCommentResponse> _fetchedComments = [];
  late final CommentRepository _commentRepository;

  @override
  void initState() {
    super.initState();
    _commentRepository = CommentRepository();
    _fetchComments(); // Yorumları başlatma
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _addComment() async {
    if (_commentController.text.trim().isNotEmpty) {
      _commentController.clear();
      _commentFocusNode.unfocus();
    }
  }

  void addComment(CommentRequest comment) async {
    var response = await _commentRepository.addComment(comment);
    if (response != null && response.message == "Success") {
      setState(() {
        _commentController.clear();
        _currentRating = 0;
        _fetchComments();
      });
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: 'Yorum eklendi.',
          icon: Padding(
            padding: const EdgeInsets.all(10), // 👈 İkon etrafına boşluk
            child: const Icon(
              Icons.verified_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500, // Metni biraz kalınlaştır
          ),
          backgroundColor: Colors.green,
          borderRadius: BorderRadius.circular(12), // Daha yumuşak köşeler
        ),
      );
    } else {}
  }

  void _fetchComments() async {
    // Burada API çağrısı yaparak yorumları çekebilirsiniz
    // Örnek olarak, widget.comments listesini güncelleyebilirsiniz
    // await widget.commentsRepository.fetchComments(widget.recipeId);
    // setState(() {});
    try {
      final comments = await _commentRepository.getComments(widget.recipeId);
      for (var com in comments) {
        print('Yorum: ${com.comment} tarih: ${com.createdAt}');
      }
      setState(() {
        _fetchedComments.clear();
        _fetchedComments.addAll(comments);
      });
      for (var comment in _fetchedComments) {
        print('Yorum: ${comment.comment} tarih: ${comment.createdAt}');
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi verebilirsiniz
      showTopSnackBar(
        widget.parentContext,
        CustomSnackBar.error(
          message: 'Yorumlar yüklenirken bir hata oluştu.',
          icon: const Icon(Icons.error, color: Colors.white),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: MediaQuery.of(context).size.height * 0.85,
      width: MediaQuery.of(context).size.width * 0.97,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: [
          // Üst kısım - Başlık ve kapatma butonu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yorumlar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        widget.recipeTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Yorum sayısı
          if (widget.comments.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${widget.comments.length} yorum',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const Divider(height: 1),

          // Yorumlar listesi
          Expanded(
            child: _fetchedComments.isEmpty
                ? CommentEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _fetchedComments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      // Burada sadece yorum gösterimi olmalı!
                      return CommentItem(comment: _fetchedComments[index]);
                    },
                  ),
          ),

          const Divider(height: 1),

          // Yorum yazma alanı (sadece 1 tane)
          CommentInput(
            controller: _commentController,
            focusNode: _commentFocusNode,
            rating: _currentRating,
            onRatingChanged: (rating) {
              setState(() {
                _currentRating = rating;
              });
            },
            onSend: () {
              addComment(
                CommentRequest(
                  recipeId: widget.recipeId,
                  comment: _commentController.text.trim(),
                  rating: _currentRating,
                  viewedRecipesId: widget.viewedRecipesId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
