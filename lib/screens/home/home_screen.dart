// File: home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/models/recipe_highlight.dart';
import 'package:ngon_mang_di/screens/home/widgets/create_recipe_box.dart';
import 'package:ngon_mang_di/screens/home/widgets/horizontal_recipe_list.dart';
import 'package:ngon_mang_di/screens/home/widgets/recipe_highlight_section.dart';
import 'package:ngon_mang_di/screens/home/widgets/recipe_recommendation_section.dart';
import 'package:ngon_mang_di/screens/home/widgets/search_input_field.dart';
import 'package:ngon_mang_di/screens/home/widgets/title_bar.dart';
import 'package:flutter/services.dart';
import 'package:ngon_mang_di/services/recipe_service.dart';

import '../../widgets/section_header.dart';

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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _refreshData();
  }

  Future<void> _refreshData() async {
    // Refresh công thức nổi bật
    setState(() {
      _highlightRecipesFuture = fetchHighlightRecipes();
    });

    // Tạo delay để simulate loading và tránh giật màn hình
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showRecommendationFilters() {
    // Tạo một modal đơn giản để mở filter
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tùy chỉnh gợi ý'),
            content: const Text('Tính năng này sẽ được phát triển sau.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
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
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshData,
                color: Colors.orange,
                backgroundColor: Colors.white,
                strokeWidth: 3.0,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      const SizedBox(height: 32),
                      SectionHeader(
                        title: "Để NgonMangDi gợi ý 👉",
                        customButtonText: "Tùy chỉnh",
                        onCustomButtonPressed: _showRecommendationFilters,
                      ),
                      const SizedBox(height: 8),
                      const RecipeRecommendationSection(
                        title: 'Để NgonMangDi gợi ý 👉',
                        limit: 5,
                      ),
                      const SizedBox(height: 40),
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
                      const SizedBox(height: 18),
                      RecipeHighlightSection(future: _highlightRecipesFuture),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
