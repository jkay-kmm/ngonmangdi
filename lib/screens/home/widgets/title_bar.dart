import 'package:flutter/material.dart';
import 'package:ngon_mang_di/config/theme/app_colors.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow_light_2, // màu nền toàn khối
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8, // độ mờ của bóng
            offset: const Offset(0, 4), // vị trí đổ bóng
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "NgonMangDi",
                style: TextStyle(
                  color: AppColors.orange_bright,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Text(
              "Đồng hành cùng bạn từng món ăn ngon !",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
