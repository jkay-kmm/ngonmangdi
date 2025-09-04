import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Khởi tạo theme service
  Future<void> init() async {
    // Bắt đầu timer để check thời gian
    _startTimeBasedThemeCheck();
    notifyListeners();
  }

  // Lấy theme mode dựa trên thời gian hiện tại
  ThemeMode getCurrentThemeMode() {
    // Logic thời gian: 6h sáng - 5h chiều = light, còn lại = dark
    final now = DateTime.now();
    final hour = now.hour;

    // 6h sáng (6:00) đến 5h chiều (17:00) = light theme
    // 5h chiều (17:00) đến 6h sáng hôm sau (6:00) = dark theme
    if (hour >= 6 && hour < 17) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  // Bắt đầu timer để check thời gian định kỳ
  void _startTimeBasedThemeCheck() {
    // Check mỗi phút để cập nhật theme
    Stream.periodic(const Duration(minutes: 1)).listen((_) {
      notifyListeners();
    });
  }
}
