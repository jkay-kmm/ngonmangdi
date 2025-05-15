import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../../widgets/time_column.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Color(0xFFDED2F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(widget.recipe.imageUrl, fit: BoxFit.contain),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.recipe.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, top: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TimeColumn(
                            title: 'Chuẩn bị',
                            time: '${widget.recipe.duration} phút',
                          ),
                          SizedBox(width: 36),
                          TimeColumn(
                            title: 'Chế biến',
                            time: '${widget.recipe.cookTime} phút',
                          ),
                          SizedBox(width: 36),
                          TimeColumn(
                            title: 'Tổng thời gian',
                            time: '${widget.recipe.totalTime} phút',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thành phần",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEE7A08),
                    ),
                  ),
                  ...widget.recipe.ingredients.map(
                    (i) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xFFEE7A08),
                      ),
                      title: Text("${i.quantity} ${i.unit} ${i.name}"),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Quá trình",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEE7A08),
                ),
              ),
            ),
            ...widget.recipe.steps.map(
  (s) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.shade300,
          ),
          alignment: Alignment.center,
          child: Text(
            '${s.order}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.instruction,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (s.detail != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    s.detail!,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              if (s.image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      s.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
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
