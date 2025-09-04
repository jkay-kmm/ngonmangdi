import 'package:flutter/material.dart';
import '../../../models/recipe.dart';
import '../../recipe/recipe_detail_screen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _filtered = [];
  String _currentQuery = '';

  // Filter states
  List<String> _selectedCategories = [];
  List<String> _selectedDifficulties = [];
  int? _maxCookingTime;
  bool _excludePorridge =
      false; // Default to show all recipes including porridge

  Future<void> _loadRecipes() async {
    List<Recipe> loadedRecipes = [];
    final jsonFiles = [
      'assets/office.json', // Load office recipes first (more diverse)
      'assets/cake.json',
      'assets/confectionery.json',
      'assets/baby.json', // Load baby recipes last
    ];

    for (String filePath in jsonFiles) {
      try {
        final String response = await rootBundle.loadString(filePath);
        final List<dynamic> data = json.decode(response);
        final List<Recipe> fileRecipes =
            data.map((json) => Recipe.fromJson(json)).toList();
        loadedRecipes.addAll(fileRecipes);
        print('Loaded ${fileRecipes.length} recipes from $filePath');
      } catch (e) {
        print('Error loading recipe data from $filePath: $e');
      }
    }

    print('Total recipes loaded: ${loadedRecipes.length}');

    // Debug: Print some sample recipe titles and categories
    print('Sample recipes:');
    for (
      int i = 0;
      i < (loadedRecipes.length > 10 ? 10 : loadedRecipes.length);
      i++
    ) {
      print(
        '${i + 1}. ${loadedRecipes[i].title} - Category: ${loadedRecipes[i].category}',
      );
    }

    // Shuffle recipes for more diversity in initial display
    loadedRecipes.shuffle();

    setState(() {
      _allRecipes = loadedRecipes;
      _filtered = loadedRecipes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _onSearch(String query) {
    setState(() {
      _currentQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filtered =
          _allRecipes.where((recipe) {
            // Text search
            bool matchesQuery =
                _currentQuery.isEmpty ||
                recipe.title.toLowerCase().contains(
                  _currentQuery.toLowerCase(),
                ) ||
                recipe.description.toLowerCase().contains(
                  _currentQuery.toLowerCase(),
                );

            // Category filter (simplified - would need proper category mapping)
            bool matchesCategory =
                _selectedCategories.isEmpty ||
                _selectedCategories.any(
                  (category) =>
                      _getCategoryForRecipe(recipe).contains(category),
                );

            // Difficulty filter
            bool matchesDifficulty =
                _selectedDifficulties.isEmpty ||
                _selectedDifficulties.contains(recipe.difficulty);

            // Cooking time filter
            bool matchesTime =
                _maxCookingTime == null || recipe.duration <= _maxCookingTime!;

            // Exclude porridge filter
            bool isNotPorridge =
                !_excludePorridge ||
                !recipe.title.toLowerCase().contains('cháo');

            return matchesQuery &&
                matchesCategory &&
                matchesDifficulty &&
                matchesTime &&
                isNotPorridge;
          }).toList();
    });
  }

  // Enhanced category mapping based on recipe data
  List<String> _getCategoryForRecipe(Recipe recipe) {
    List<String> categories = [];
    String title = recipe.title.toLowerCase();
    String description = recipe.description.toLowerCase();

    // Check by recipe category field if available
    String recipeCategory = recipe.category?.toLowerCase() ?? '';

    // Breakfast items
    if (title.contains('sáng') ||
        title.contains('breakfast') ||
        recipeCategory.contains('sáng')) {
      categories.add('Món ăn sáng');
    }

    // Desserts and sweets
    if (title.contains('bánh') ||
        title.contains('dessert') ||
        title.contains('ngọt') ||
        title.contains('donut') ||
        recipeCategory.contains('bánh') ||
        recipeCategory.contains('ngọt') ||
        description.contains('ngọt')) {
      categories.add('Món tráng miệng');
    }

    // Vegetarian
    if (title.contains('chay') ||
        title.contains('vegetarian') ||
        description.contains('chay')) {
      categories.add('Món chay');
    }

    // Appetizers
    if (title.contains('khai vị') ||
        title.contains('appetizer') ||
        title.contains('gỏi') ||
        title.contains('salad')) {
      categories.add('Món khai vị');
    }

    // Side dishes
    if (title.contains('phụ') ||
        title.contains('side') ||
        description.contains('ăn kèm')) {
      categories.add('Món phụ');
    }

    // Lunch items
    if (title.contains('trưa') ||
        title.contains('lunch') ||
        title.contains('cơm hộp') ||
        title.contains('cơm văn phòng') ||
        recipeCategory.contains('cơm')) {
      categories.add('Món ăn trưa');
    }

    // Dinner items
    if (title.contains('tối') ||
        title.contains('dinner') ||
        title.contains('cơm tối')) {
      categories.add('Món ăn tối');
    }

    // Default categorization based on common Vietnamese dishes
    if (categories.isEmpty) {
      if (title.contains('cơm') || title.contains('rice')) {
        categories.add('Món chính');
        categories.add('Món ăn trưa');
      } else if (title.contains('cháo') || title.contains('porridge')) {
        categories.add('Món chính');
        if (description.contains('bé') || recipeCategory.contains('bé')) {
          // Don't categorize baby food specifically, let it be main dish
        }
      } else if (title.contains('bánh') || title.contains('cake')) {
        categories.add('Món tráng miệng');
      } else {
        categories.add('Món chính');
      }
    }

    return categories;
  }

  void _showSearchFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder:
                  (context, scrollController) => _SearchFiltersSheet(
                    scrollController: scrollController,
                    selectedCategories: _selectedCategories,
                    selectedDifficulties: _selectedDifficulties,
                    maxCookingTime: _maxCookingTime,
                    excludePorridge: _excludePorridge,
                    onFiltersChanged: (filters) {
                      setState(() {
                        _selectedCategories =
                            filters['categories'] as List<String>;
                        _selectedDifficulties =
                            filters['difficulties'] as List<String>;
                        _maxCookingTime = filters['maxCookingTime'] as int?;
                        _excludePorridge = filters['excludePorridge'] as bool;
                      });
                      _applyFilters();
                    },
                  ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header với search bar và filter button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFFFF6B35),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF6B35).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        onChanged: _onSearch,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên món ăn...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFFFF6B35),
                              size: 24,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter button
                  Container(
                    decoration: BoxDecoration(
                      color:
                          _hasActiveFilters()
                              ? const Color(0xFFFF6B35)
                              : const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune_rounded,
                        color:
                            _hasActiveFilters()
                                ? Colors.white
                                : const Color(0xFFFF6B35),
                      ),
                      onPressed: _showSearchFilters,
                    ),
                  ),
                ],
              ),
            ),

            // Active filters display
            if (_hasActiveFilters())
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildActiveFilterChips(),
                ),
              ),

            // Content area
            Expanded(
              child:
                  _filtered.isEmpty && _allRecipes.isNotEmpty
                      ? _buildNoResultsView()
                      : _allRecipes.isEmpty && _filtered.isEmpty
                      ? _buildInitialView()
                      : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategories.isNotEmpty ||
        _selectedDifficulties.isNotEmpty ||
        _maxCookingTime != null ||
        _excludePorridge;
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    // Category chips
    for (String category in _selectedCategories) {
      chips.add(
        _buildFilterChip(category, () {
          setState(() {
            _selectedCategories.remove(category);
          });
          _applyFilters();
        }),
      );
    }

    // Difficulty chips
    for (String difficulty in _selectedDifficulties) {
      chips.add(
        _buildFilterChip(difficulty, () {
          setState(() {
            _selectedDifficulties.remove(difficulty);
          });
          _applyFilters();
        }),
      );
    }

    // Time chip
    if (_maxCookingTime != null) {
      chips.add(
        _buildFilterChip('≤ $_maxCookingTime phút', () {
          setState(() {
            _maxCookingTime = null;
          });
          _applyFilters();
        }),
      );
    }

    // Exclude porridge chip
    if (_excludePorridge) {
      chips.add(
        _buildFilterChip('Không có cháo', () {
          setState(() {
            _excludePorridge = false;
          });
          _applyFilters();
        }),
      );
    }

    // Clear all button
    if (chips.isNotEmpty) {
      chips.add(
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedCategories.clear();
              _selectedDifficulties.clear();
              _maxCookingTime = null;
              _excludePorridge = false;
            });
            _applyFilters();
          },
          icon: const Icon(Icons.clear_all, size: 16),
          label: const Text('Xóa tất cả'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    return chips;
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onDeleted: onDelete,
      deleteIcon: const Icon(Icons.close, size: 16),
      backgroundColor: const Color(0xFFFF6B35).withOpacity(0.1),
      deleteIconColor: const Color(0xFFFF6B35),
      labelStyle: const TextStyle(color: Color(0xFFFF6B35)),
    );
  }

  // ... rest of the build methods remain the same
  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Không tìm thấy món ăn nào",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Thử tìm kiếm với từ khóa khác hoặc điều chỉnh bộ lọc",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView() {
    // If we have recipes loaded but no search query, show some sample recipes
    if (_allRecipes.isNotEmpty &&
        _currentQuery.isEmpty &&
        !_hasActiveFilters()) {
      return _buildSearchResults(); // Show all recipes when no filters
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Khám phá món ăn mới",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Đang tải công thức... ${_allRecipes.length} món ăn sẵn sàng!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final recipe = _filtered[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(0, 2),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          recipe.imageUrl.startsWith('http')
                              ? Image.network(
                                recipe.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildDefaultImage(),
                              )
                              : Image.asset(
                                recipe.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildDefaultImage(),
                              ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6B35,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 16,
                                      color: Color(0xFFFF6B35),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${recipe.duration} phút',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF6B35),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(
                                    recipe.difficulty,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  recipe.difficulty,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getDifficultyColor(
                                      recipe.difficulty,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFFF6B35),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.restaurant_rounded, color: Colors.grey, size: 32),
    );
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
}

class _SearchFiltersSheet extends StatefulWidget {
  final ScrollController scrollController;
  final List<String> selectedCategories;
  final List<String> selectedDifficulties;
  final int? maxCookingTime;
  final bool excludePorridge;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const _SearchFiltersSheet({
    required this.scrollController,
    required this.selectedCategories,
    required this.selectedDifficulties,
    required this.maxCookingTime,
    required this.excludePorridge,
    required this.onFiltersChanged,
  });

  @override
  State<_SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<_SearchFiltersSheet> {
  late List<String> selectedCategories;
  late List<String> selectedDifficulties;
  late int? maxCookingTime;
  late bool excludePorridge;

  final List<String> categories = [
    'Món chính',
    'Món phụ',
    'Món tráng miệng',
    'Món khai vị',
    'Món chay',
    'Món ăn sáng',
    'Món ăn trưa',
    'Món ăn tối',
  ];

  final List<String> difficulties = ['Dễ', 'Trung bình', 'Khó'];

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.selectedCategories);
    selectedDifficulties = List.from(widget.selectedDifficulties);
    maxCookingTime = widget.maxCookingTime;
    excludePorridge = widget.excludePorridge;
  }

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
                  'Tùy chỉnh tìm kiếm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danh mục
            const Text(
              'Danh mục:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  categories.map((category) {
                    bool isSelected = selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Độ khó
            const Text(
              'Độ khó:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  difficulties.map((difficulty) {
                    bool isSelected = selectedDifficulties.contains(difficulty);
                    return FilterChip(
                      label: Text(difficulty),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDifficulties.add(difficulty);
                          } else {
                            selectedDifficulties.remove(difficulty);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Thời gian nấu tối đa
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
                    bool isSelected = maxCookingTime == time;
                    return FilterChip(
                      label: Text('$time phút'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          maxCookingTime = selected ? time : null;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Loại trừ cháo
            SwitchListTile(
              title: const Text('Loại trừ món cháo'),
              subtitle: const Text('Không hiển thị các món cháo trong kết quả'),
              value: excludePorridge,
              onChanged: (value) {
                setState(() {
                  excludePorridge = value;
                });
              },
              activeColor: const Color(0xFFFF6B35),
            ),

            const SizedBox(height: 24),

            // Nút áp dụng
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
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
                      'categories': selectedCategories,
                      'difficulties': selectedDifficulties,
                      'maxCookingTime': maxCookingTime,
                      'excludePorridge': excludePorridge,
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
