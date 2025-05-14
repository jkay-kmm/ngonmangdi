import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/services/recipe_service.dart';
import '../../models/recipe.dart';
import '../../widgets/loading_text.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  final String? jsonFile;
  const RecipeListScreen({super.key, this.jsonFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách công thức",
          style: TextStyle(fontFamily: "ABeeZee", fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: FutureBuilder<List<Recipe>>(
        future:
            jsonFile != null
                ? RecipeService1().fetchRecipesFromFile(jsonFile!)
                : loadRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/loading.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 12),
                  const LoadingText(),
                ],
              ),
            );
          }
          final recipes = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        recipe.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${recipe.duration} phút | ${recipe.difficulty}",
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
