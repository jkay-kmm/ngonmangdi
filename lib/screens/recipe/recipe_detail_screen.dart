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
              margin: EdgeInsets.only(left: 16, right: 16),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Color(0xFFDED2F9),
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(widget.recipe.imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.recipe.description, style: const TextStyle(fontSize: 16)),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       InfoItem(icon: Icons.schedule, label: '${recipe.duration} phút'),
            //       InfoItem(icon: Icons.people, label: '${recipe.servings} phần'),
            //       InfoItem(icon: Icons.local_fire_department, label: recipe.difficulty),
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2FAFA), // Màu nền nhạt
                borderRadius: BorderRadius.circular(12),
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          TimeColumn(title: 'Chuẩn bị', time: '${widget.recipe.duration} phút'),
                          SizedBox(width: 36,),
                          TimeColumn(title: 'Chế biến', time: '6 phút'),
                          SizedBox(width: 36,),
                          TimeColumn(title: 'Tổng thời gian', time: '16 phút'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Khẩu phần
                  const Text(
                    'Khẩu phần',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  Text('${widget.recipe.servings} phần'),

                  const SizedBox(height: 12),

                  // Lưu ý
                  // Text(
                  //   widget.recipe.notes ,
                  //   style: const TextStyle(height: 1.4),
                  // ),
                ],

              ),
            ),

            const Divider(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Thành phần", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xFFEE7A08))),
            ),
            ...widget.recipe.ingredients.map((i) => ListTile(
              leading: const Icon(Icons.circle, size: 8),
              title: Text("${i.quantity} ${i.unit} ${i.name}"),
            )),

            const Divider(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Quá trình", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEE7A08))),
            ),
            ...widget.recipe.steps.map((s) => ListTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.orange.shade300,
                child: Text('${s.order}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text(s.instruction),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


