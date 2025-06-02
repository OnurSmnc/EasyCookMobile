import 'package:easycook/core/data/models/comments/commentResponse.dart';
import 'package:easycook/views/comment/screens/commentPage.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final GetCommentResponse comment;

  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.orange[100],
          backgroundImage: comment.image != null
              ? NetworkImage(comment.image as String)
              : null,
          child: comment.image != null
              ? Text(
                  comment.nickName[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.nickName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    'formatTime(comment.createdAt)',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(comment.comment,
                  style: const TextStyle(fontSize: 14, height: 1.4)),
              const SizedBox(height: 8),
              // Row(
              //   children: [
              //     InkWell(
              //       onTap: () => {},
              //       borderRadius: BorderRadius.circular(16),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 8, vertical: 4),
              //         child: Row(
              //           children: [
              //             Icon(
              //               comment.isLiked
              //                   ? Icons.favorite
              //                   : Icons.favorite_border,
              //               size: 16,
              //               color:
              //                   comment.isLiked ? Colors.red : Colors.grey[600],
              //             ),
              //             if (comment.likes > 0) ...[
              //               const SizedBox(width: 4),
              //               Text(
              //                 comment.likes.toString(),
              //                 style: TextStyle(
              //                     fontSize: 12, color: Colors.grey[600]),
              //               )
              //             ]
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ],
    );
  }
}
