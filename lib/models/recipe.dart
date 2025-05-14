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
  final int? cookTime;
  final int? totalTime;
  final String? notes;

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
    required this.cookTime,
    required this.totalTime,
    required this.notes,
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
      cookTime: json['cookTime'],
      totalTime: json['totalTime'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'tags': tags,
      'duration': duration,
      'servings': servings,
      'difficulty': difficulty,
      'author': author,
      'cookTime': cookTime,
      'totalTime': totalTime,
      'notes': notes,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}
