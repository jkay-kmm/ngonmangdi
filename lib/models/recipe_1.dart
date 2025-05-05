import 'package:flutter/material.dart';

class Recipe_1 {
  final String image;
  final String title;
  final String desc;
  final double rating;
  final String country;
  final Color bgColor;

  Recipe_1({
    required this.image,
    required this.title,
    required this.desc,
    required this.rating,
    required this.country,
    required this.bgColor,
  });

  factory Recipe_1.fromJson(Map<String, dynamic> json) {
    return Recipe_1(
      image: json['image'],
      title: json['title'],
      desc: json['desc'],
      rating: (json['rating'] as num).toDouble(),
      country: json['country'],
      bgColor: Color(_hexToColor(json['bgColor'])),
    );
  }

  static int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add opacity if missing
    return int.parse(hex, radix: 16);
  }
}
