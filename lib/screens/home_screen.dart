import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/config/theme/app_fonts.dart';

import '../providers/recipe_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {

    final recipeService = RecipeService();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Search bar
            TextField(
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

            const SizedBox(height: 24),

            // Popular Recipes
            SectionHeader(title: "Công thức phổ biến"),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final item = recipes[index];
                  return GestureDetector(
                    onTap: () {
                      context.go('/recipe_list_screen');
                    },
                    child: RecipeCard(
                      image: item['image'],
                      title: item['title'],
                      desc: item['desc'],
                      rating: item['rating'],
                      country: item['country'],
                      bgColor: _parseColor(item['bgColor']),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Tạo công thức
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CC),
                border: Border(
                  left: BorderSide(color: Colors.black, width: 10),
                  bottom: BorderSide(color: Colors.black, width: 10),
                  top: BorderSide(color: Colors.black, width: 1),
                  right: BorderSide(color: Colors.black, width: 1),
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 6),
                        Text('Bạn đang không biết ăn gì?', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Tạo công thức'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Tạo mới'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // New Recipes
            SectionHeader(title: "Công thức mới"),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final item = recipes[index];
                  return RecipeCard(
                    image: item['image'],
                    title: item['title'],
                    desc: item['desc'],
                    rating: item['rating'],
                    country: item['country'],
                    bgColor: _parseColor(item['bgColor']),
                  );
                },
              ),
            ),

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

class FilterChipWidget extends StatelessWidget {
  final String label;
  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        TextButton(onPressed: () {}, child: const Text("Xem thêm")),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final double rating;
  final String country;
  final Color bgColor;

  const RecipeCard({
    required this.image,
    required this.title,
    required this.desc,
    required this.rating,
    required this.country,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(image, height: 100, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(title, style: AppFont.regular_default_18,),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text('$rating  •  $country', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
