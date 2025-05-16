import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/models/recipe.dart';
import 'package:ngon_mang_di/screens/home/home_screen.dart';
import 'package:ngon_mang_di/screens/recipe/recipe_detail_screen.dart';
import 'package:ngon_mang_di/screens/recipe/recipe_list_screen.dart';
import 'package:ngon_mang_di/screens/recipe/recipe_grid_screen.dart';
import 'package:ngon_mang_di/screens/splash/splash_screen.dart';
import 'screens/notification_screen.dart';
import 'firebase_api.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/recipe_list_screen',
      builder: (context, state) {
        final jsonFile = state.uri.queryParameters['jsonFile'];
        return RecipeListScreen(jsonFile: jsonFile);
      },
    ),
    GoRoute(
      path: '/recipe_grid_screen',
      builder: (context, state) => const RecipeGridScreen(),
    ),
    GoRoute(
      path: '/recipe_detail_screen',
      builder: (context, state) {
        final recipe = state.extra as Recipe;
        return RecipeDetailScreen(recipe: recipe);
      },
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return NotificationScreen(
          title: extra['title'] as String? ?? '',
          body: extra['body'] as String? ?? '',
          timestamp: extra['timestamp'] as DateTime?,
        );
      },
    ),
  ],
);
