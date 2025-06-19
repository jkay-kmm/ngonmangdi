import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMorePressed;
  final String? customButtonText;
  final VoidCallback? onCustomButtonPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeMorePressed,
    this.customButtonText,
    this.onCustomButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (customButtonText != null && onCustomButtonPressed != null)
          GestureDetector(
            onTap: onCustomButtonPressed,
            child: Text(
              customButtonText!,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else if (onSeeMorePressed != null)
          GestureDetector(
            onTap: onSeeMorePressed,
            child: const Text(
              "Xem thêm",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
