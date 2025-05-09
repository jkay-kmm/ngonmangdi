import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMorePressed;

  const SectionHeader({required this.title, this.onSeeMorePressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextButton(onPressed: onSeeMorePressed, child: const Text("Xem thêm")),
      ],
    );
  }
}
