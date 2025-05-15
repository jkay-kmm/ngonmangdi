import 'package:flutter_test/flutter_test.dart';
import 'package:ngon_mang_di/models/recipe.dart';
import 'package:ngon_mang_di/models/ingredient.dart';
import 'package:ngon_mang_di/models/stepmodel.dart' as recipe_step;

void main() {
  group('Recipe Model Tests', () {
    test('should create Recipe from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Recipe',
        'description': 'Test Description',
        'imageUrl': 'test_image.jpg',
        'category': 'Main Course',
        'tags': ['test', 'example'],
        'duration': 30,
        'servings': 4,
        'difficulty': 'Medium',
        'author': 'Test Author',
        'cookTime': 20,
        'totalTime': 50,
        'notes': 'Test Notes',
        'ingredients': [
          {'name': 'ingredient1', 'quantity': '100', 'unit': 'g'},
          {'name': 'ingredient2', 'quantity': '200', 'unit': 'g'},
        ],
        'steps': [
          {'instruction': 'step1', 'order': 1},
          {'instruction': 'step2', 'order': 2},
        ],
      };

      // Act
      final recipe = Recipe.fromJson(json);

      // Assert
      expect(recipe.id, '1');
      expect(recipe.title, 'Test Recipe');
      expect(recipe.description, 'Test Description');
      expect(recipe.imageUrl, 'test_image.jpg');
      expect(recipe.category, 'Main Course');
      expect(recipe.tags, ['test', 'example']);
      expect(recipe.duration, 30);
      expect(recipe.servings, 4);
      expect(recipe.difficulty, 'Medium');
      expect(recipe.author, 'Test Author');
      expect(recipe.cookTime, 20);
      expect(recipe.totalTime, 50);
      expect(recipe.notes, 'Test Notes');
      expect(recipe.ingredients.length, 2);
      expect(recipe.steps.length, 2);
    });

    test('should convert Recipe to JSON', () {
      // Arrange
      final recipe = Recipe(
        id: '1',
        title: 'Test Recipe',
        description: 'Test Description',
        imageUrl: 'test_image.jpg',
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
          recipe_step.Step(instruction: 'step1', order: 1, detail: 'detail1', image: 'assets/images/image_box.jpg'),
          recipe_step.Step(instruction: 'step2', order: 2, detail: 'detail2', image: 'assets/images/image_box.jpg'),
        ],
      );

      // Act
      final json = recipe.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Recipe');
      expect(json['description'], 'Test Description');
      expect(json['imageUrl'], 'test_image.jpg');
      expect(json['category'], 'Main Course');
      expect(json['tags'], ['test', 'example']);
      expect(json['duration'], 30);
      expect(json['servings'], 4);
      expect(json['difficulty'], 'Medium');
      expect(json['author'], 'Test Author');
      expect(json['cookTime'], 20);
      expect(json['totalTime'], 50);
      expect(json['notes'], 'Test Notes');
      expect(json['ingredients'].length, 2);
      expect(json['steps'].length, 2);
    });
  });
}
