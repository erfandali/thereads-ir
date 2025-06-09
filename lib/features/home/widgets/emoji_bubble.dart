import 'package:flutter/material.dart';

class EmojiBubble extends StatelessWidget {
  final String emoji;

  const EmojiBubble({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 19),
    );
  }
}
