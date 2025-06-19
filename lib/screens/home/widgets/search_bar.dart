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

  Future<void> _loadRecipes() async {
    List<Recipe> loadedRecipes = [];
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
        loadedRecipes.addAll(
          data.map((json) => Recipe.fromJson(json)).toList(),
        );
      } catch (e) {
        // Handle errors, e.g., file not found or invalid JSON
        print('Error loading recipe data from $filePath: $e');
      }
    }
    setState(() {
      _allRecipes = loadedRecipes;
      _filtered = loadedRecipes; // Initially, show all loaded recipes
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered =
            _allRecipes
                .where((recipe) => !recipe.title.toLowerCase().contains('cháo'))
                .toList();
      } else {
        _filtered =
            _allRecipes
                .where(
                  (recipe) =>
                      recipe.title.toLowerCase().contains(
                        query.toLowerCase(),
                      ) &&
                      !recipe.title.toLowerCase().contains('cháo'),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              right: 12,
              left: 12,
            ), // Added left padding for balance
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên món ăn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide.none, // Removed border for cleaner look
                      ),
                      filled: true, // Added fill color
                      fillColor: Colors.white, // Set fill color to white
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ), // Adjusted padding
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _filtered.isEmpty &&
                        (_allRecipes
                            .isNotEmpty) // Show "not found" only if search yields no results from existing recipes
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/images/search_not_found.png', // Consider a different image for "not found"
                          //   width: 150,
                          // ),
                          const SizedBox(height: 12),
                          const Text(
                            "Không tìm thấy món ăn nào phù hợp.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : _allRecipes.isEmpty &&
                        _filtered
                            .isEmpty // Show initial message if no recipes loaded or initial state
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/search.png', width: 200),
                          const SizedBox(height: 12),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 26),
                            child: const Center(
                              child: Text(
                                "Nhập để tìm kiếm món ăn từ các danh mục được chọn!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final recipe = _filtered[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
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
                                child:
                                    recipe.imageUrl.startsWith('http')
                                        ? Image.network(
                                          recipe.imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Image.asset(
                                                'assets/images/default_dish.png',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ), // Fallback for network image
                                        )
                                        : Image.asset(
                                          recipe.imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Image.asset(
                                                'assets/images/default_dish.png',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ), // Fallback for asset image
                                        ),
                              ),
                              title: Text(
                                recipe.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${recipe.duration} phút | ${recipe.difficulty}",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
