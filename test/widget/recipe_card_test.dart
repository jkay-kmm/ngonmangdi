import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_mang_di/models/recipe.dart';
import 'package:ngon_mang_di/widgets/recipe_card.dart';
import 'package:ngon_mang_di/models/ingredient.dart';
import 'package:ngon_mang_di/models/stepmodel.dart' as recipe_step;

void main() {
  testWidgets('RecipeCard displays recipe information correctly', (
    WidgetTester tester,
  ) async {
    // Arrange
    final recipe = Recipe(
      id: '1',
      title: 'Test Recipe',
      description: 'Test Description',
      imageUrl: 'assets/images/image_box.jpg',
      category: 'Main Course',
      tags: ['test', 'example'],
      duration: 30,
      servings: 4,
      difficulty: 'Medium',
      author: 'Test Author',
      cookTime: 20,
      totalTime: 50,
      notes: 'Test Notes',
      ingredients: [
        Ingredient(name: 'ingredient1', quantity: '100', unit: 'g'),
        Ingredient(name: 'ingredient2', quantity: '200', unit: 'g'),
      ],
      steps: [
        recipe_step.Step(instruction: 'step1', order: 1),
        recipe_step.Step(instruction: 'step2', order: 2),
      ],
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeCard(
            image: recipe.imageUrl,
            title: recipe.title,
            desc: recipe.description,
            rating: 4.5,
            country: recipe.category,
            bgColor: Colors.white,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Recipe'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('Main Course'), findsOneWidget);
  });
}
