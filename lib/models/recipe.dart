import 'package:ngon_mang_di/models/stepmodel.dart';

import 'ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final List<Ingredient> ingredients;
  final List<Step> steps;
  final int duration;
  final int servings;
  final String difficulty;
  final String author;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.tags,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.servings,
    required this.difficulty,
    required this.author,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var ingredientsList = json['ingredients'] as List;
    var stepsList = json['steps'] as List;

    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
      ingredients: ingredientsList.map((e) => Ingredient.fromJson(e)).toList(),
      steps: stepsList.map((e) => Step.fromJson(e)).toList(),
      duration: json['duration'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      author: json['author'],
    );
  }
}