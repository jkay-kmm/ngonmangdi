import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ngon_mang_di/firebase_api.dart';
import 'package:ngon_mang_di/firebase_options.dart';
import 'package:ngon_mang_di/config/theme/app_theme.dart';
import 'package:ngon_mang_di/services/theme_service.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();

  // Khởi tạo theme service
  final themeService = ThemeService();
  await themeService.init();

  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;

  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeService,
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp.router(
            title: 'App Công Thức Nấu Ăn',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.getCurrentThemeMode(),
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
