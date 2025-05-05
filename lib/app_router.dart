import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/screens/home_screen.dart';
import 'package:ngon_mang_di/screens/recipe_list_screen.dart';
import 'package:ngon_mang_di/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const SplashScreen(),
    // ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/recipe_list_screen',
      builder: (context, state) => const RecipeListScreen(),
    ),
  ],
);