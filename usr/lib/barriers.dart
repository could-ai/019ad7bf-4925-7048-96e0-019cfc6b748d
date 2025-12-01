import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double size; // Height of the barrier (percentage of screen)
  final bool isBottom; // True if it's a bottom pipe, false for top

  const MyBarrier({super.key, required this.size, required this.isBottom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Fixed width for pipes
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 3, color: Colors.green.shade800),
        borderRadius: BorderRadius.circular(10),
      ),
      // Placeholder for pipe image logic
      // child: Image.asset(
      //   isBottom ? 'assets/images/pipe_bottom.png' : 'assets/images/pipe_top.png',
      //   fit: BoxFit.cover,
      // ),
    );
  }
}
