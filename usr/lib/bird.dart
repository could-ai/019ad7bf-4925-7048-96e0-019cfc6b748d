import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight;

  const MyBird({
    super.key, 
    required this.birdY, 
    required this.birdWidth, 
    required this.birdHeight
  });

  @override
  Widget build(BuildContext context) {
    // Convert relative size to screen percentage for Alignment
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)), // Simplified alignment logic
      child: Image.asset(
        'assets/images/bird.png',
        width: 50, // approximate width
        height: 50, // approximate height
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image is not present
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          );
        },
      ),
    );
  }
}
