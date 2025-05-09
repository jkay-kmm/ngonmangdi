
import 'package:flutter/material.dart';

class CreateRecipeBox extends StatelessWidget {
  const CreateRecipeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CC),
        border: Border(
          left: BorderSide(color: Colors.black, width: 8),
          bottom: BorderSide(color: Colors.black, width: 8),
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
              children: [
                Image.asset("assets/images/Group 2.png"),
                const SizedBox(height: 16),
                const Text('Bạn đang không biết ăn gì?', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),

              ],
            ),
          ),
          Image.asset("assets/images/image_box.png",width: 100,height: 100,)
        ],
      ),
    );
  }
}
