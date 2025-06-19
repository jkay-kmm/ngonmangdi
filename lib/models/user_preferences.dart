class UserPreferences {
  final List<String> favoriteCategories;
  final String preferredDifficulty;
  final List<String> dietaryRestrictions;
  final List<String> favoriteIngredients;
  final int preferredCookingTime;
  final List<String> mealTypes;
  final List<String> viewedRecipes;
  final List<String> bookmarkedRecipes;
  final List<String> ratedRecipes;

  UserPreferences({
    this.favoriteCategories = const [],
    this.preferredDifficulty = 'Dễ',
    this.dietaryRestrictions = const [],
    this.favoriteIngredients = const [],
    this.preferredCookingTime = 30,
    this.mealTypes = const ['sáng', 'trưa', 'tối'],
    this.viewedRecipes = const [],
    this.bookmarkedRecipes = const [],
    this.ratedRecipes = const [],
  });

  UserPreferences copyWith({
    List<String>? favoriteCategories,
    String? preferredDifficulty,
    List<String>? dietaryRestrictions,
    List<String>? favoriteIngredients,
    int? preferredCookingTime,
    List<String>? mealTypes,
    List<String>? viewedRecipes,
    List<String>? bookmarkedRecipes,
    List<String>? ratedRecipes,
  }) {
    return UserPreferences(
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      preferredDifficulty: preferredDifficulty ?? this.preferredDifficulty,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      favoriteIngredients: favoriteIngredients ?? this.favoriteIngredients,
      preferredCookingTime: preferredCookingTime ?? this.preferredCookingTime,
      mealTypes: mealTypes ?? this.mealTypes,
      viewedRecipes: viewedRecipes ?? this.viewedRecipes,
      bookmarkedRecipes: bookmarkedRecipes ?? this.bookmarkedRecipes,
      ratedRecipes: ratedRecipes ?? this.ratedRecipes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteCategories': favoriteCategories,
      'preferredDifficulty': preferredDifficulty,
      'dietaryRestrictions': dietaryRestrictions,
      'favoriteIngredients': favoriteIngredients,
      'preferredCookingTime': preferredCookingTime,
      'mealTypes': mealTypes,
      'viewedRecipes': viewedRecipes,
      'bookmarkedRecipes': bookmarkedRecipes,
      'ratedRecipes': ratedRecipes,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      preferredDifficulty: json['preferredDifficulty'] ?? 'Dễ',
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] ?? []),
      favoriteIngredients: List<String>.from(json['favoriteIngredients'] ?? []),
      preferredCookingTime: json['preferredCookingTime'] ?? 30,
      mealTypes: List<String>.from(
        json['mealTypes'] ?? ['sáng', 'trưa', 'tối'],
      ),
      viewedRecipes: List<String>.from(json['viewedRecipes'] ?? []),
      bookmarkedRecipes: List<String>.from(json['bookmarkedRecipes'] ?? []),
      ratedRecipes: List<String>.from(json['ratedRecipes'] ?? []),
    );
  }

  // Thêm món ăn vào danh sách đã xem
  UserPreferences addViewedRecipe(String recipeId) {
    List<String> newViewedRecipes = List.from(viewedRecipes);
    if (!newViewedRecipes.contains(recipeId)) {
      newViewedRecipes.add(recipeId);
    }
    return copyWith(viewedRecipes: newViewedRecipes);
  }

  // Thêm món ăn vào bookmark
  UserPreferences addBookmarkedRecipe(String recipeId) {
    List<String> newBookmarkedRecipes = List.from(bookmarkedRecipes);
    if (!newBookmarkedRecipes.contains(recipeId)) {
      newBookmarkedRecipes.add(recipeId);
    }
    return copyWith(bookmarkedRecipes: newBookmarkedRecipes);
  }

  // Xóa món ăn khỏi bookmark
  UserPreferences removeBookmarkedRecipe(String recipeId) {
    List<String> newBookmarkedRecipes = List.from(bookmarkedRecipes);
    newBookmarkedRecipes.remove(recipeId);
    return copyWith(bookmarkedRecipes: newBookmarkedRecipes);
  }

  // Thêm đánh giá món ăn
  UserPreferences addRatedRecipe(String recipeId) {
    List<String> newRatedRecipes = List.from(ratedRecipes);
    if (!newRatedRecipes.contains(recipeId)) {
      newRatedRecipes.add(recipeId);
    }
    return copyWith(ratedRecipes: newRatedRecipes);
  }

  // Thêm category yêu thích
  UserPreferences addFavoriteCategory(String category) {
    List<String> newFavoriteCategories = List.from(favoriteCategories);
    if (!newFavoriteCategories.contains(category)) {
      newFavoriteCategories.add(category);
    }
    return copyWith(favoriteCategories: newFavoriteCategories);
  }

  // Xóa category yêu thích
  UserPreferences removeFavoriteCategory(String category) {
    List<String> newFavoriteCategories = List.from(favoriteCategories);
    newFavoriteCategories.remove(category);
    return copyWith(favoriteCategories: newFavoriteCategories);
  }

  // Thêm nguyên liệu yêu thích
  UserPreferences addFavoriteIngredient(String ingredient) {
    List<String> newFavoriteIngredients = List.from(favoriteIngredients);
    if (!newFavoriteIngredients.contains(ingredient)) {
      newFavoriteIngredients.add(ingredient);
    }
    return copyWith(favoriteIngredients: newFavoriteIngredients);
  }

  // Xóa nguyên liệu yêu thích
  UserPreferences removeFavoriteIngredient(String ingredient) {
    List<String> newFavoriteIngredients = List.from(favoriteIngredients);
    newFavoriteIngredients.remove(ingredient);
    return copyWith(favoriteIngredients: newFavoriteIngredients);
  }

  // Thêm chế độ ăn
  UserPreferences addDietaryRestriction(String restriction) {
    List<String> newDietaryRestrictions = List.from(dietaryRestrictions);
    if (!newDietaryRestrictions.contains(restriction)) {
      newDietaryRestrictions.add(restriction);
    }
    return copyWith(dietaryRestrictions: newDietaryRestrictions);
  }

  // Xóa chế độ ăn
  UserPreferences removeDietaryRestriction(String restriction) {
    List<String> newDietaryRestrictions = List.from(dietaryRestrictions);
    newDietaryRestrictions.remove(restriction);
    return copyWith(dietaryRestrictions: newDietaryRestrictions);
  }
}
