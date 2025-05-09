import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  final String title;
  final String time;
  const TimeColumn({super.key, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4, width: 10,),
        Text(time),
      ],
    );
  }
}