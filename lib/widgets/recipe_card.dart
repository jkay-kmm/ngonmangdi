
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme/app_fonts.dart';

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final double rating;
  final String country;
  final Color bgColor;

  const RecipeCard({
    required this.image,
    required this.title,
    required this.desc,
    required this.rating,
    required this.country,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset(image, height: 100, fit: BoxFit.cover)),
          const SizedBox(height: 8),
          Text(title, style: AppFont.regular_default_18,),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text('$rating  •  $country', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
