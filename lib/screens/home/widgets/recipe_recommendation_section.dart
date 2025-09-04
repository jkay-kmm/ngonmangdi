import 'package:flutter/material.dart';
import '../../../models/recipe.dart';
import '../../../models/user_preferences.dart';
import '../../../services/recommendation_service.dart';
import '../../recipe/recipe_detail_screen.dart';
import '../../../widgets/recipe_card.dart';
import 'package:go_router/go_router.dart';

class RecipeRecommendationSection extends StatefulWidget {
  final UserPreferences? userPreferences;
  final List<String>? availableIngredients;
  final int? maxCookingTime;
  final String? dietaryRestriction;
  final String? mealType;
  final String title;
  final int limit;

  const RecipeRecommendationSection({
    super.key,
    this.userPreferences,
    this.availableIngredients,
    this.maxCookingTime,
    this.dietaryRestriction,
    this.mealType,
    this.title = 'Gợi ý cho bạn',
    this.limit = 5,
  });

  @override
  State<RecipeRecommendationSection> createState() =>
      _RecipeRecommendationSectionState();
}

class _RecipeRecommendationSectionState
    extends State<RecipeRecommendationSection> {
  Future<List<Recipe>>? _recommendationsFuture;
  final RecommendationService _recommendationService = RecommendationService();
  int _currentRecommendationType = 0;

  @override
  void initState() {
    super.initState();
    _initializeRecommendations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Tự động refresh khi dependencies thay đổi (từ parent refresh)
    if (_recommendationsFuture != null) {
      _refreshRecommendations();
    }
  }

  // Public method để expose showRecommendationFilters
  void showRecommendationFilters(BuildContext context) {
    _showRecommendationFilters(context);
  }

  Future<void> _initializeRecommendations() async {
    await _recommendationService.initialize();
    if (widget.userPreferences != null) {
      _recommendationService.updateUserPreferences(widget.userPreferences!);
    }

    _loadRecommendations();
  }

  void _loadRecommendations() {
    setState(() {
      _recommendationsFuture = Future.value(_getRecommendationsByType());
    });
  }

  List<Recipe> _getRecommendationsByType() {
    switch (_currentRecommendationType) {
      case 0:
        return _recommendationService.getRecommendations(
          availableIngredients: widget.availableIngredients,
          maxCookingTime: widget.maxCookingTime,
          dietaryRestriction: widget.dietaryRestriction,
          mealType: widget.mealType,
          limit: widget.limit,
        );
      case 1:
        return _recommendationService.getTimeBasedRecommendations(
          limit: widget.limit,
        );
      case 2:
        return _recommendationService.getSeasonalRecommendations(
          limit: widget.limit,
        );
      case 3:
        return _recommendationService.getDifficultyBasedRecommendations(
          difficulty: 'Dễ',
          limit: widget.limit,
        );
      case 4:
        return _recommendationService.getQuickRecipes(
          maxTime: 30,
          limit: widget.limit,
        );
      default:
        return _recommendationService.getRecommendations(limit: widget.limit);
    }
  }

  void _refreshRecommendations() {
    // Thay đổi loại gợi ý mỗi lần refresh
    _currentRecommendationType = (_currentRecommendationType + 1) % 5;
    _loadRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child:
          _recommendationsFuture == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<Recipe>>(
                future: _recommendationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Không thể tải gợi ý',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  final recipes = snapshot.data ?? [];

                  if (recipes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.restaurant_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Không có gợi ý phù hợp',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/recipe_detail_screen', extra: recipe);
                        },
                        child: Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getCardColor(index),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    recipe.imageUrl,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              height: 100,
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.restaurant,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recipe.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${recipe.duration} phút',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getDifficultyColor(
                                        recipe.difficulty,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      recipe.difficulty,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recipe.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFFFFEAB6), // Vàng nhạt
      const Color(0xFFFFD6D6), // Hồng nhạt
      const Color(0xFFD6E5FF), // Xanh nhạt
      const Color(0xFFE5FFD6), // Xanh lá nhạt
      const Color(0xFFFFE5D6), // Cam nhạt
    ];
    return colors[index % colors.length];
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'dễ':
        return Colors.green;
      case 'trung bình':
        return Colors.orange;
      case 'khó':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showRecommendationFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => _RecommendationFiltersSheet(
                  scrollController: scrollController,
                  onFiltersChanged: (filters) {
                    setState(() {
                      _recommendationsFuture = Future.value(
                        _recommendationService.getRecommendations(
                          availableIngredients:
                              filters['ingredients'] as List<String>?,
                          maxCookingTime: filters['cookingTime'] as int?,
                          dietaryRestriction: filters['dietary'] as String?,
                          mealType: filters['mealType'] as String?,
                          limit: widget.limit,
                        ),
                      );
                    });
                  },
                ),
          ),
    );
  }
}

class _RecommendationFiltersSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final ScrollController scrollController;

  const _RecommendationFiltersSheet({
    required this.onFiltersChanged,
    required this.scrollController,
  });

  @override
  State<_RecommendationFiltersSheet> createState() =>
      _RecommendationFiltersSheetState();
}

class _RecommendationFiltersSheetState
    extends State<_RecommendationFiltersSheet> {
  List<String> selectedIngredients = [];
  int? selectedCookingTime;
  String? selectedDietary;
  String? selectedMealType;

  final List<String> commonIngredients = [
    'gạo',
    'thịt heo',
    'thịt bò',
    'cá',
    'tôm',
    'trứng',
    'rau cải',
    'cà chua',
    'hành',
    'tỏi',
    'ớt',
    'dầu ăn',
    'nước mắm',
    'muối',
    'đường',
    'bột mì',
  ];

  final List<String> dietaryOptions = [
    'Chay',
    'Thuần chay',
    'Ít calo',
    'Không gluten',
  ];

  final List<String> mealTypes = ['Sáng', 'Trưa', 'Tối', 'Tráng miệng'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tùy chỉnh gợi ý',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nguyên liệu có sẵn
            const Text(
              'Nguyên liệu có sẵn:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  commonIngredients.map((ingredient) {
                    bool isSelected = selectedIngredients.contains(ingredient);
                    return FilterChip(
                      label: Text(ingredient),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedIngredients.add(ingredient);
                          } else {
                            selectedIngredients.remove(ingredient);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Thời gian nấu
            const Text(
              'Thời gian nấu tối đa:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [15, 30, 45, 60, 90].map((time) {
                    bool isSelected = selectedCookingTime == time;
                    return FilterChip(
                      label: Text('$time phút'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCookingTime = selected ? time : null;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Chế độ ăn
            const Text(
              'Chế độ ăn:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  dietaryOptions.map((dietary) {
                    bool isSelected = selectedDietary == dietary;
                    return FilterChip(
                      label: Text(dietary),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedDietary = selected ? dietary : null;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Loại bữa ăn
            const Text(
              'Loại bữa ăn:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  mealTypes.map((mealType) {
                    bool isSelected = selectedMealType == mealType;
                    return FilterChip(
                      label: Text(mealType),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedMealType = selected ? mealType : null;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            // Nút áp dụng
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    widget.onFiltersChanged({
                      'ingredients': selectedIngredients,
                      'cookingTime': selectedCookingTime,
                      'dietary': selectedDietary,
                      'mealType': selectedMealType,
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Áp dụng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Thêm padding bottom để tránh bị che bởi keyboard
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
