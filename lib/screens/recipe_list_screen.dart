import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/screens/recipe_detail_screen.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Danh sách công thức"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/home');
            },
          ),
        ),

        body:FutureBuilder<List<Recipe>>(
        future: loadRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final recipes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: Image.asset(recipe.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(recipe.title),
                subtitle: Text("${recipe.duration} phút | ${recipe.difficulty}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
              );
            },
          );
        },
      )
    );
  }
}
