import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDelete;

  const CustomChip({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
