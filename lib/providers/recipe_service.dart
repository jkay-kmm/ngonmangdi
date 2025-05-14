import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ngon_mang_di/models/recipe_highlight.dart';

import '../models/recipe.dart';

Future<List<Recipe>> loadRecipes() async {
  final String data = await rootBundle.loadString('assets/confectionery.json');
  final List<dynamic> jsonData = jsonDecode(data);
  return jsonData.map((item) => Recipe.fromJson(item)).toList();
}

class RecipeService {
  Future<List<dynamic>> fetchRecipes() async {
    final String jsonString = await rootBundle.loadString(
      'assets/recipes.json',
    );
    return json.decode(jsonString) as List<dynamic>;
  }
}

class RecipeService1 {
  Future<List<Recipe>> fetchRecipesFromFile(String fileName) async {
    final jsonString = await rootBundle.loadString('assets/$fileName');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Recipe.fromJson(e)).toList();
  }
}

class RecipeService2 {
  Future<List<RecipeHighlight>> fetchHighlightRecipes() async {
    final String response = await rootBundle.loadString(
      'assets/highlight_recipes.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => RecipeHighlight.fromJson(json)).toList();
  }
}
