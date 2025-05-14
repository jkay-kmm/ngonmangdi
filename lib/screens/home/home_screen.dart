import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/models/recipe.dart';
import 'package:ngon_mang_di/models/recipe_highlight.dart';
import 'package:ngon_mang_di/screens/home/widgets/create_recipe_box.dart';
import 'package:ngon_mang_di/screens/home/widgets/horizontal_recipe_list.dart';
import 'package:ngon_mang_di/screens/home/widgets/recipe_high_light_card.dart';
import 'package:ngon_mang_di/screens/home/widgets/search_input_field.dart';
import 'package:ngon_mang_di/screens/home/widgets/title_bar.dart';
import 'package:ngon_mang_di/screens/recipe/recipe_detail_screen.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

import '../../providers/recipe_service.dart';
import '../../widgets/section_header.dart';

Future<List<RecipeHighlight>> fetchHighlightRecipes() async {
  try {
    final String response = await rootBundle.loadString(
      'assets/highlight_recipes.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => RecipeHighlight.fromJson(json)).toList();
  } catch (e) {
    print('Error loading highlight_recipes.json: $e');
    return [];
  }
}

Future<Recipe> fetchRecipeDetailsById(String id) async {
  final String response = await rootBundle.loadString(
    'assets/highlight_recipes.json',
  );
  final List<dynamic> data = json.decode(response);
  final recipeJson = data.firstWhere(
    (item) => item['id'] == id,
    orElse: () => null,
  );
  if (recipeJson != null) {
    return Recipe.fromJson(recipeJson as Map<String, dynamic>);
  }
  throw Exception(
    'Recipe with id $id not found or highlight_recipes.json does not contain full details',
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final RecipeService _recipeService = RecipeService();
  late Future<List<RecipeHighlight>> _highlightRecipesFuture;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 700,
      ), // You can adjust the duration
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Start from 50% below the screen
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // You can try different curves
      ),
    );

    _animationController.forward();
    _highlightRecipesFuture = fetchHighlightRecipes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _recipeService.fetchRecipes(),
          builder: (context, snapshotGeneralRecipes) {
            if (snapshotGeneralRecipes.connectionState !=
                ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshotGeneralRecipes.hasData ||
                snapshotGeneralRecipes.data == null) {
              return const Center(
                child: Text("Không thể tải dữ liệu công thức chung"),
              );
            }

            final generalRecipes = snapshotGeneralRecipes.data!;

            return SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchInputField(),
                    const SizedBox(height: 16),
                    const TitleBar(),
                    const SizedBox(height: 12),
                    SectionHeader(
                      title: "Công thức phổ biến",
                      onSeeMorePressed:
                          () => context.push('/recipe_grid_screen'),
                    ),
                    const SizedBox(height: 8),
                    HorizontalRecipeList(
                      recipes: generalRecipes,
                      clickable: true,
                    ),
                    const SizedBox(height: 18),
                    const CreateRecipeBox(),
                    const SizedBox(height: 24),
                    FutureBuilder<List<RecipeHighlight>>(
                      future: _highlightRecipesFuture,
                      builder: (context, snapshotHighlightRecipes) {
                        if (snapshotHighlightRecipes.connectionState !=
                            ConnectionState.done) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                          );
                        }
                        if (snapshotHighlightRecipes.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Text(
                                "Lỗi tải công thức nổi bật: ${snapshotHighlightRecipes.error}",
                              ),
                            ),
                          );
                        }
                        if (!snapshotHighlightRecipes.hasData ||
                            snapshotHighlightRecipes.data!.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final highlightRecipes = snapshotHighlightRecipes.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (highlightRecipes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  "Có thể bạn sẽ thích",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ...highlightRecipes.map((highlightRecipe) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      final Recipe fullRecipeDetails =
                                          await fetchRecipeDetailsById(
                                            highlightRecipe.id,
                                          );
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => RecipeDetailScreen(
                                                  recipe: fullRecipeDetails,
                                                ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print(
                                        "Error fetching full recipe details: $e",
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Không thể tải chi tiết công thức: ${highlightRecipe.title}",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: RecipeHighlightCard(
                                    recipe: highlightRecipe,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
