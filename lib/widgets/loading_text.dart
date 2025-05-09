import 'package:flutter/cupertino.dart';

class LoadingText extends StatefulWidget {
  const LoadingText({super.key});

  @override
  State<LoadingText> createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText> {
  int dotCount = 0;

  @override
  void initState() {
    super.initState();
    // Tạo Timer lặp lại để cập nhật dấu chấm
    Future.delayed(Duration.zero, () {
      _startDotAnimation();
    });
  }

  void _startDotAnimation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() {
        dotCount = (dotCount + 1) % 4; // 0 → 3 chấm
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * dotCount;
    return Text(
      'Đang tìm$dots',
      style: const TextStyle(fontSize: 16, fontFamily: "ABeeZee"),
    );
  }
}
