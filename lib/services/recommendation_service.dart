import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe.dart';
import '../models/user_preferences.dart';

class RecommendationService {
  static final RecommendationService _instance =
      RecommendationService._internal();
  factory RecommendationService() => _instance;
  RecommendationService._internal();

  List<Recipe> _allRecipes = [];
  UserPreferences? _userPreferences;

  // Khởi tạo service
  Future<void> initialize() async {
    await _loadAllRecipes();
  }

  // Tải tất cả công thức từ các file JSON
  Future<void> _loadAllRecipes() async {
    final jsonFiles = [
      'assets/baby.json',
      'assets/cake.json',
      'assets/office.json',
      'assets/confectionery.json',
    ];

    for (String filePath in jsonFiles) {
      try {
        final String response = await rootBundle.loadString(filePath);
        final List<dynamic> data = json.decode(response);
        _allRecipes.addAll(data.map((json) => Recipe.fromJson(json)).toList());
      } catch (e) {
        print('Error loading recipe data from $filePath: $e');
      }
    }
  }

  // Cập nhật preferences của user
  void updateUserPreferences(UserPreferences preferences) {
    _userPreferences = preferences;
  }

  // Thuật toán gợi ý chính
  List<Recipe> getRecommendations({
    List<String>? availableIngredients,
    int? maxCookingTime,
    String? dietaryRestriction,
    String? mealType,
    int limit = 10,
  }) {
    List<RecipeScore> scoredRecipes = [];

    for (Recipe recipe in _allRecipes) {
      double score = _calculateRecipeScore(
        recipe,
        availableIngredients: availableIngredients,
        maxCookingTime: maxCookingTime,
        dietaryRestriction: dietaryRestriction,
        mealType: mealType,
      );

      if (score > 0) {
        scoredRecipes.add(RecipeScore(recipe: recipe, score: score));
      }
    }

    // Sắp xếp theo điểm số giảm dần
    scoredRecipes.sort((a, b) => b.score.compareTo(a.score));

    // Thêm randomization để tạo sự đa dạng
    List<Recipe> recommendations = [];

    if (scoredRecipes.isNotEmpty) {
      // Lấy top 20% món ăn có điểm cao nhất
      int topCount = (scoredRecipes.length * 0.2).ceil();
      topCount = topCount > 0 ? topCount : 1;

      List<RecipeScore> topRecipes = scoredRecipes.take(topCount).toList();

      // Randomize top recipes
      topRecipes.shuffle();

      // Thêm một số món ăn ngẫu nhiên từ top 50%
      int randomCount = (scoredRecipes.length * 0.5).ceil();
      randomCount = randomCount > topCount ? randomCount : topCount + 1;

      List<RecipeScore> randomRecipes =
          scoredRecipes.take(randomCount).toList();
      randomRecipes.shuffle();

      // Kết hợp top recipes và random recipes
      Set<String> addedIds = {};

      // Thêm từ top recipes trước
      for (var recipeScore in topRecipes) {
        if (recommendations.length >= limit) break;
        if (!addedIds.contains(recipeScore.recipe.id)) {
          recommendations.add(recipeScore.recipe);
          addedIds.add(recipeScore.recipe.id);
        }
      }

      // Thêm từ random recipes nếu chưa đủ
      for (var recipeScore in randomRecipes) {
        if (recommendations.length >= limit) break;
        if (!addedIds.contains(recipeScore.recipe.id)) {
          recommendations.add(recipeScore.recipe);
          addedIds.add(recipeScore.recipe.id);
        }
      }

      // Nếu vẫn chưa đủ, thêm ngẫu nhiên từ tất cả
      if (recommendations.length < limit) {
        List<RecipeScore> remainingRecipes =
            scoredRecipes
                .where((rs) => !addedIds.contains(rs.recipe.id))
                .toList();
        remainingRecipes.shuffle();

        for (var recipeScore in remainingRecipes) {
          if (recommendations.length >= limit) break;
          recommendations.add(recipeScore.recipe);
        }
      }
    }

    return recommendations;
  }

  // Tính điểm cho một công thức
  double _calculateRecipeScore(
    Recipe recipe, {
    List<String>? availableIngredients,
    int? maxCookingTime,
    String? dietaryRestriction,
    String? mealType,
  }) {
    double score = 0.0;

    // 1. Điểm dựa trên nguyên liệu có sẵn (40%)
    if (availableIngredients != null) {
      score += _calculateIngredientScore(recipe, availableIngredients) * 0.4;
    }

    // 2. Điểm dựa trên thời gian nấu (20%)
    if (maxCookingTime != null) {
      score += _calculateTimeScore(recipe, maxCookingTime) * 0.2;
    }

    // 3. Điểm dựa trên chế độ ăn (15%)
    if (dietaryRestriction != null) {
      score += _calculateDietaryScore(recipe, dietaryRestriction) * 0.15;
    }

    // 4. Điểm dựa trên loại bữa ăn (10%)
    if (mealType != null) {
      score += _calculateMealTypeScore(recipe, mealType) * 0.1;
    }

    // 5. Điểm dựa trên preferences của user (10%)
    if (_userPreferences != null) {
      score += _calculateUserPreferenceScore(recipe) * 0.1;
    }

    // 6. Điểm dựa trên độ phổ biến (5%)
    score += _calculatePopularityScore(recipe) * 0.05;

    return score;
  }

  // Tính điểm dựa trên nguyên liệu có sẵn
  double _calculateIngredientScore(
    Recipe recipe,
    List<String> availableIngredients,
  ) {
    int matchingIngredients = 0;
    int totalIngredients = recipe.ingredients.length;

    for (var ingredient in recipe.ingredients) {
      String ingredientName = ingredient.name.toLowerCase();

      for (String available in availableIngredients) {
        if (ingredientName.contains(available.toLowerCase()) ||
            available.toLowerCase().contains(ingredientName)) {
          matchingIngredients++;
          break;
        }
      }
    }

    return matchingIngredients / totalIngredients;
  }

  // Tính điểm dựa trên thời gian nấu
  double _calculateTimeScore(Recipe recipe, int maxCookingTime) {
    if (recipe.duration <= maxCookingTime) {
      // Càng nhanh càng được điểm cao
      return 1.0 - (recipe.duration / maxCookingTime) * 0.5;
    }
    return 0.0; // Không đủ thời gian
  }

  // Tính điểm dựa trên chế độ ăn
  double _calculateDietaryScore(Recipe recipe, String dietaryRestriction) {
    String category = recipe.category.toLowerCase();
    String title = recipe.title.toLowerCase();
    List<String> tags = recipe.tags.map((tag) => tag.toLowerCase()).toList();

    switch (dietaryRestriction.toLowerCase()) {
      case 'chay':
        return _isVegetarian(recipe) ? 1.0 : 0.0;
      case 'thuần chay':
        return _isVegan(recipe) ? 1.0 : 0.0;
      case 'ít calo':
        return _isLowCalorie(recipe) ? 1.0 : 0.5;
      case 'không gluten':
        return _isGlutenFree(recipe) ? 1.0 : 0.0;
      default:
        return 0.5; // Mặc định
    }
  }

  // Tính điểm dựa trên loại bữa ăn
  double _calculateMealTypeScore(Recipe recipe, String mealType) {
    String category = recipe.category.toLowerCase();
    String title = recipe.title.toLowerCase();

    switch (mealType.toLowerCase()) {
      case 'sáng':
        return _isBreakfastFood(recipe) ? 1.0 : 0.3;
      case 'trưa':
        return _isLunchFood(recipe) ? 1.0 : 0.3;
      case 'tối':
        return _isDinnerFood(recipe) ? 1.0 : 0.3;
      case 'tráng miệng':
        return _isDessert(recipe) ? 1.0 : 0.0;
      default:
        return 0.5;
    }
  }

  // Tính điểm dựa trên preferences của user
  double _calculateUserPreferenceScore(Recipe recipe) {
    if (_userPreferences == null) return 0.5;

    double score = 0.5; // Điểm cơ bản

    // Kiểm tra category yêu thích
    if (_userPreferences!.favoriteCategories.contains(recipe.category)) {
      score += 0.3;
    }

    // Kiểm tra độ khó phù hợp
    if (_userPreferences!.preferredDifficulty == recipe.difficulty) {
      score += 0.2;
    }

    return score;
  }

  // Tính điểm dựa trên độ phổ biến
  double _calculatePopularityScore(Recipe recipe) {
    // Có thể dựa trên số lượt xem, đánh giá, bookmark
    // Hiện tại trả về điểm cố định
    return 0.7;
  }

  // Các hàm helper để kiểm tra loại món ăn
  bool _isVegetarian(Recipe recipe) {
    List<String> nonVegetarianKeywords = [
      'thịt',
      'cá',
      'tôm',
      'cua',
      'gà',
      'vịt',
      'heo',
      'bò',
      'trứng',
    ];

    String title = recipe.title.toLowerCase();
    String description = recipe.description.toLowerCase();

    for (String keyword in nonVegetarianKeywords) {
      if (title.contains(keyword) || description.contains(keyword)) {
        return false;
      }
    }
    return true;
  }

  bool _isVegan(Recipe recipe) {
    // Kiểm tra cả thịt và sữa, trứng
    List<String> nonVeganKeywords = [
      'thịt',
      'cá',
      'tôm',
      'cua',
      'gà',
      'vịt',
      'heo',
      'bò',
      'trứng',
      'sữa',
      'bơ',
      'phô mai',
    ];

    String title = recipe.title.toLowerCase();
    String description = recipe.description.toLowerCase();

    for (String keyword in nonVeganKeywords) {
      if (title.contains(keyword) || description.contains(keyword)) {
        return false;
      }
    }
    return true;
  }

  bool _isLowCalorie(Recipe recipe) {
    // Món ăn ít calo thường có từ khóa như: salad, rau, luộc, hấp
    List<String> lowCalorieKeywords = ['salad', 'rau', 'luộc', 'hấp', 'súp'];
    String title = recipe.title.toLowerCase();

    for (String keyword in lowCalorieKeywords) {
      if (title.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  bool _isGlutenFree(Recipe recipe) {
    // Kiểm tra các nguyên liệu có gluten
    List<String> glutenKeywords = ['bột mì', 'bánh mì', 'mì', 'noodle'];
    String title = recipe.title.toLowerCase();

    for (String keyword in glutenKeywords) {
      if (title.contains(keyword)) {
        return false;
      }
    }
    return true;
  }

  bool _isBreakfastFood(Recipe recipe) {
    List<String> breakfastKeywords = [
      'cháo',
      'phở',
      'bún',
      'bánh mì',
      'trứng',
      'sữa',
    ];
    String title = recipe.title.toLowerCase();

    for (String keyword in breakfastKeywords) {
      if (title.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  bool _isLunchFood(Recipe recipe) {
    List<String> lunchKeywords = ['cơm', 'canh', 'xào', 'kho', 'nướng'];
    String title = recipe.title.toLowerCase();

    for (String keyword in lunchKeywords) {
      if (title.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  bool _isDinnerFood(Recipe recipe) {
    // Tương tự lunch food
    return _isLunchFood(recipe);
  }

  bool _isDessert(Recipe recipe) {
    List<String> dessertKeywords = [
      'bánh',
      'kem',
      'chè',
      'sữa chua',
      'trái cây',
    ];
    String title = recipe.title.toLowerCase();
    String category = recipe.category.toLowerCase();

    for (String keyword in dessertKeywords) {
      if (title.contains(keyword) || category.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  // Gợi ý dựa trên món ăn hiện tại
  List<Recipe> getSimilarRecipes(Recipe currentRecipe, {int limit = 5}) {
    List<RecipeScore> scoredRecipes = [];

    for (Recipe recipe in _allRecipes) {
      if (recipe.id == currentRecipe.id) continue; // Bỏ qua món hiện tại

      double score = _calculateSimilarityScore(currentRecipe, recipe);
      scoredRecipes.add(RecipeScore(recipe: recipe, score: score));
    }

    scoredRecipes.sort((a, b) => b.score.compareTo(a.score));
    return scoredRecipes
        .take(limit)
        .map((recipeScore) => recipeScore.recipe)
        .toList();
  }

  // Tính điểm tương đồng giữa 2 món ăn
  double _calculateSimilarityScore(Recipe recipe1, Recipe recipe2) {
    double score = 0.0;

    // So sánh category (30%)
    if (recipe1.category == recipe2.category) {
      score += 0.3;
    }

    // So sánh tags (25%)
    int commonTags = 0;
    for (String tag in recipe1.tags) {
      if (recipe2.tags.contains(tag)) {
        commonTags++;
      }
    }
    score += (commonTags / recipe1.tags.length) * 0.25;

    // So sánh độ khó (15%)
    if (recipe1.difficulty == recipe2.difficulty) {
      score += 0.15;
    }

    // So sánh thời gian nấu (15%)
    double timeDiff =
        (recipe1.duration - recipe2.duration).abs() / recipe1.duration;
    score += (1 - timeDiff) * 0.15;

    // So sánh nguyên liệu (15%)
    int commonIngredients = 0;
    for (var ingredient1 in recipe1.ingredients) {
      for (var ingredient2 in recipe2.ingredients) {
        if (ingredient1.name.toLowerCase() == ingredient2.name.toLowerCase()) {
          commonIngredients++;
          break;
        }
      }
    }
    score += (commonIngredients / recipe1.ingredients.length) * 0.15;

    return score;
  }

  // Gợi ý dựa trên thời gian trong ngày
  List<Recipe> getTimeBasedRecommendations({int limit = 5}) {
    DateTime now = DateTime.now();
    int hour = now.hour;

    String mealType;
    if (hour >= 6 && hour < 11) {
      mealType = 'sáng';
    } else if (hour >= 11 && hour < 14) {
      mealType = 'trưa';
    } else if (hour >= 17 && hour < 20) {
      mealType = 'tối';
    } else {
      mealType = 'tráng miệng';
    }

    return getRecommendations(mealType: mealType, limit: limit);
  }

  // Gợi ý dựa trên mùa vụ
  List<Recipe> getSeasonalRecommendations({int limit = 5}) {
    DateTime now = DateTime.now();
    int month = now.month;

    List<String> seasonalIngredients = [];

    // Mùa xuân (3-5)
    if (month >= 3 && month <= 5) {
      seasonalIngredients = ['rau cải', 'cà chua', 'dưa leo', 'hành'];
    }
    // Mùa hè (6-8)
    else if (month >= 6 && month <= 8) {
      seasonalIngredients = ['dưa hấu', 'dứa', 'xoài', 'rau muống'];
    }
    // Mùa thu (9-11)
    else if (month >= 9 && month <= 11) {
      seasonalIngredients = ['bí đỏ', 'khoai lang', 'cà rốt', 'hành tây'];
    }
    // Mùa đông (12-2)
    else {
      seasonalIngredients = ['cải thảo', 'su hào', 'cà rốt', 'khoai tây'];
    }

    return getRecommendations(
      availableIngredients: seasonalIngredients,
      limit: limit,
    );
  }

  // Gợi ý dựa trên độ khó
  List<Recipe> getDifficultyBasedRecommendations({
    String difficulty = 'Dễ',
    int limit = 5,
  }) {
    List<RecipeScore> scoredRecipes = [];

    for (Recipe recipe in _allRecipes) {
      if (recipe.difficulty.toLowerCase() == difficulty.toLowerCase()) {
        double score = _calculateRecipeScore(recipe);
        scoredRecipes.add(RecipeScore(recipe: recipe, score: score));
      }
    }

    scoredRecipes.sort((a, b) => b.score.compareTo(a.score));
    scoredRecipes.shuffle(); // Randomize kết quả

    return scoredRecipes
        .take(limit)
        .map((recipeScore) => recipeScore.recipe)
        .toList();
  }

  // Gợi ý dựa trên thời gian nấu
  List<Recipe> getQuickRecipes({int maxTime = 30, int limit = 5}) {
    List<RecipeScore> scoredRecipes = [];

    for (Recipe recipe in _allRecipes) {
      if (recipe.duration <= maxTime) {
        double score = _calculateRecipeScore(recipe);
        scoredRecipes.add(RecipeScore(recipe: recipe, score: score));
      }
    }

    scoredRecipes.sort((a, b) => b.score.compareTo(a.score));
    scoredRecipes.shuffle(); // Randomize kết quả

    return scoredRecipes
        .take(limit)
        .map((recipeScore) => recipeScore.recipe)
        .toList();
  }
}

// Class để lưu trữ điểm số của công thức
class RecipeScore {
  final Recipe recipe;
  final double score;

  RecipeScore({required this.recipe, required this.score});
}
