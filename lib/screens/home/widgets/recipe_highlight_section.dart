import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../models/recipe.dart';
import '../../../models/recipe_highlight.dart';
import '../../recipe/recipe_detail_screen.dart';
import 'recipe_high_light_card.dart';
import 'package:go_router/go_router.dart';

Future<List<RecipeHighlight>> fetchHighlightRecipes() async {
  try {
    final String response = await rootBundle.loadString(
      'assets/highlight_recipes.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => RecipeHighlight.fromJson(json)).toList();
  } catch (e) {
    print('Error loading highlight_recipes.json: $e');
    return [];
  }
}

Future<Recipe> fetchRecipeDetailsById(String id) async {
  final String response = await rootBundle.loadString(
    'assets/recipe_detail.json',
  );
  final List<dynamic> data = json.decode(response);
  final recipeJson = data.firstWhere(
    (item) => item['id'] == id,
    orElse: () => null,
  );
  if (recipeJson != null) {
    return Recipe.fromJson(recipeJson as Map<String, dynamic>);
  }
  throw Exception('Recipe with id \$id not found');
}

class RecipeHighlightSection extends StatelessWidget {
  final Future<List<RecipeHighlight>> future;

  const RecipeHighlightSection({super.key, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeHighlight>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text("Lỗi tải công thức nổi bật: \${snapshot.error}"),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final recipes = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "Gợi ý một số món ăn nổi bật !",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7653B),
                ),
              ),
            ),
            ...recipes.map(
              (recipe) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    try {
                      final Recipe fullRecipe = await fetchRecipeDetailsById(
                        recipe.id,
                      );
                      if (context.mounted) {
                        context.push(
                          '/recipe_detail_screen',
                          extra: fullRecipe,
                        );
                      }
                    } catch (e, stack) {
                      print('LỖI: $e');
                      print('STACK: $stack');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Không thể tải chi tiết công thức: ${recipe.title}\n$e",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: RecipeHighlightCard(recipe: recipe),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
