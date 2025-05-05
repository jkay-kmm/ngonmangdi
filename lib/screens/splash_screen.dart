// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart'; // Nếu bạn dùng go_router
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     print("SplashScreen init");
//
//     Future.delayed(const Duration(seconds: 2), () {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           print("Navigating to /home");
//           context.go('/home');
//         }
//       });
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFEAB6),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Image.asset('assets/images/splash.png', width: 200),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
