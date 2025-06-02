import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double rating;
  final Function(double) onRatingChanged;
  final VoidCallback onSend;

  const CommentInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.rating,
    required this.onRatingChanged,
    required this.onSend,
  });

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  String? errorText;

  void handleSend() {
    final text = widget.controller.text.trim();
    final rating = widget.rating;

    if (rating == 0) {
      setState(() {
        errorText = 'Lütfen yıldız ile puan verin.';
      });
      return;
    }
    if (text.isEmpty) {
      setState(() {
        errorText = 'Lütfen yorumunuzu yazın.';
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    widget.onSend();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Center(
              child: RatingBar.builder(
                initialRating: widget.rating,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.orange,
                  shadows: <Shadow>[
                    Shadow(color: Colors.orange[300] ?? Colors.orange)
                  ],
                ),
                onRatingUpdate: widget.onRatingChanged,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.orange,
                  backgroundImage: NetworkImage(
                      'https://www.gravatar.com/avatar/placeholder'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    decoration: InputDecoration(
                      hintText: 'Yorumunuzu yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: errorText,
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButtonWidget(
                onPressed: handleSend,
                title: 'Gönder',
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
