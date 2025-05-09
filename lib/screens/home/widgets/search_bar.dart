import 'package:flutter/material.dart';
import '../../../models/recipe.dart';
import '../../../providers/recipe_provider.dart';
import '../../recipe/recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _filtered = [];

  @override
  void initState() {
    super.initState();
    loadRecipes().then((recipes) {
      setState(() {
        _allRecipes = recipes;
        _filtered = [];
      });
    });
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = _allRecipes.where((recipe) =>
          recipe.title.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.pop(context); // Quay lại màn hình trước đó
                  },
                ),
                Expanded(
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên món ăn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/search.png',
                  width: 200,
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 26),
                  child: Center( // Căn giữa đoạn văn bản
                    child: const Text(
                      "Không biết nên ăn gì , Đừng lo, NgonMangDi sẽ giúp bạn tìm những món ăn ngon nhất cho bạn!",
                      textAlign: TextAlign.center, // Căn giữa văn bản
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),

              ],
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
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                        child: Image.asset(
                          recipe.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        recipe.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${recipe.duration} phút | ${recipe.difficulty}"),
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
