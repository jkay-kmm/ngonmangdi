
import 'package:go_router/go_router.dart';
import 'package:ngon_mang_di/screens/home/home_screen.dart';
import 'package:ngon_mang_di/screens/recipe/recipe_list_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const SplashScreen(),
    // ),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/recipe_list_screen',
      builder: (context, state) => const RecipeListScreen(),
    ),

  ],
);
