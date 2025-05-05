import 'package:flutter/material.dart';

import '../models/recipe.dart';


class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(recipe.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(recipe.description, style: const TextStyle(fontSize: 16)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoItem(icon: Icons.schedule, label: '${recipe.duration} phút'),
                  InfoItem(icon: Icons.people, label: '${recipe.servings} phần'),
                  InfoItem(icon: Icons.local_fire_department, label: recipe.difficulty),
                ],
              ),
            ),

            const Divider(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Nguyên liệu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...recipe.ingredients.map((i) => ListTile(
              leading: const Icon(Icons.circle, size: 8),
              title: Text("${i.quantity} ${i.unit} ${i.name}"),
            )),

            const Divider(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Các bước nấu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...recipe.steps.map((s) => ListTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.orange.shade300,
                child: Text('${s.order}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text(s.instruction),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.orange),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
