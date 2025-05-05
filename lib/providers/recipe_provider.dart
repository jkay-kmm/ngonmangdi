import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/recipe.dart';

Future<List<Recipe>> loadRecipes() async {
  final String data = await rootBundle.loadString('assets/all_recipes.json');
  final List<dynamic> jsonData = jsonDecode(data);
  return jsonData.map((item) => Recipe.fromJson(item)).toList();
}
class RecipeService {
  Future<List<dynamic>> fetchRecipes() async {
    final String jsonString = await rootBundle.loadString('assets/recipes.json');
    return json.decode(jsonString) as List<dynamic>;
  }
}

