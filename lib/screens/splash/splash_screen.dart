import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Nếu bạn dùng go_router

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAB6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/images/splash.png', width: 180),
            ),
            const SizedBox(height: 32),
            const Text(
              'NgonMangDi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFFB05C00),
                letterSpacing: 2,
                fontFamily: 'Montserrat', // Nếu bạn có font này
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ẩm thực bốn phương, gần ngay bên bạn',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7C4F00),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB05C00)),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
