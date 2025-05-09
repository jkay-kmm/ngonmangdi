import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/config/theme/app_fonts.dart';
import 'package:ngon_mang_di/screens/home/widgets/create_recipe_box.dart';
import 'package:ngon_mang_di/screens/home/widgets/horizontal_recipe_list.dart';
import 'package:ngon_mang_di/screens/home/widgets/search_bar.dart';
import 'package:ngon_mang_di/screens/home/widgets/title_bar.dart';

import '../../providers/recipe_provider.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Color _parseColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: recipeService.fetchRecipes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Không thể tải dữ liệu"));
            }

            final recipes = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchScreen()),
                      );
                    },
                    child: AbsorbPointer( // Ngăn người dùng nhập ở đây
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm công thức',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const TitleBar(),
                  const SizedBox(height: 12),
                  SectionHeader(
                    title: "Công thức phổ biến",
                    onSeeMorePressed: () => context.push('/recipe_list_screen'),
                  ),
                  const SizedBox(height: 8),
                  HorizontalRecipeList(recipes: recipes, clickable: true),
                  const SizedBox(height: 18),
                  const CreateRecipeBox(),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: "Công thức mới",
                    onSeeMorePressed: () => context.push('/recipe_list_screen'),
                  ),
                  const SizedBox(height: 8),
                  HorizontalRecipeList(recipes: recipes),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
