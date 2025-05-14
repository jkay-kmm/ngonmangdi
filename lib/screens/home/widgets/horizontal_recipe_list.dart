import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/recipe_card.dart';
import '../home_screen.dart';
import '../../../screens/recipe/recipe_list_screen.dart';

class HorizontalRecipeList extends StatelessWidget {
  final List<dynamic> recipes;
  final bool clickable;
  const HorizontalRecipeList({
    super.key,
    required this.recipes,
    this.clickable = false,
  });

  Color _parseColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final item = recipes[index];
          final card = RecipeCard(
            image: item['image'],
            title: item['title'],
            desc: item['desc'],
            rating: item['rating'],
            country: item['country'],
            bgColor: _parseColor(item['bgColor']),
          );
          return clickable
              ? GestureDetector(
                onTap: () {
                  context.push(
                    '/recipe_list_screen?jsonFile=${item['jsonFile']}',
                  );
                },
                child: card,
              )
              : card;
        },
      ),
    );
  }
}
