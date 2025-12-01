import 'dart:async';
import 'package:flutter/material.dart';
import 'bird.dart';
import 'barriers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bird variables
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  
  // Physics
  double velocity = 2.5; // Jump strength
  double gravity = -4.9; // Gravity pull

  // Barrier variables
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  
  // Score
  int score = 0;
  int bestScore = 0;

  // Game Loop
  void startGame() {
    gameHasStarted = true;
    initialHeight = birdYaxis;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      // Physics equation: y = -1/2 * g * t^2 + v * t + initial_y
      // We invert gravity because screen Y increases downwards, but our logic treats up as positive for jump
      // Actually, let's stick to standard Flutter Alignment: -1 is top, 1 is bottom.
      // So gravity should pull towards 1 (positive). Jump should push towards -1 (negative).
      
      // Simplified physics for easier tuning:
      // height = gravity * time * time + velocity * time;
      
      setState(() {
        // Update Bird Position
        // Using equation: h = -4.9 * t^2 + 2.8 * t
        // Adjusted for screen coordinates
        birdYaxis = initialHeight - (velocity * time + gravity * time * time);

        // Move Barriers
        if (barrierXone < -2) {
          barrierXone += 3.5;
          score++;
        } else {
          barrierXone -= 0.05;
        }

        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          score++;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      // Check for Game Over
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  bool birdIsDead() {
    // Check if bird hits top or bottom of screen
    if (birdYaxis > 1.1 || birdYaxis < -1.1) {
      return true;
    }

    // Check collision with Barrier 1
    // Barrier X range is approx -0.2 to 0.2 (width dependent)
    // Barrier Gap is the safe zone.
    // Let's assume fixed gap for simplicity in this version
    
    // Simple collision logic based on alignment values
    // Pipe width is approx 0.2 in alignment units
    if (barrierXone > -0.2 && barrierXone < 0.2) {
      // If bird is NOT in the gap
      // Gap center is 0.0 (middle), Gap size is approx 0.4 total (-0.2 to 0.2)
      // Top pipe ends at -0.3, Bottom pipe starts at 0.3
      if (birdYaxis < -0.3 || birdYaxis > 0.3) {
        return true;
      }
    }

    if (barrierXtwo > -0.2 && barrierXtwo < 0.2) {
      if (birdYaxis < -0.3 || birdYaxis > 0.3) {
        return true;
      }
    }

    return false;
  }

  void resetGame() {
    Navigator.pop(context); // Dismiss dialog
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      if (score > bestScore) {
        bestScore = score;
      }
      score = 0;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Text(
            "G A M E  O V E R",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Score: $score",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: const Text(
                "PLAY AGAIN",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Background
                  Container(
                    color: Colors.blue,
                  ),
                  
                  // Bird
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBird(
                      birdY: 0, 
                      birdWidth: 50, 
                      birdHeight: 50
                    ),
                  ),

                  // Barrier 1 (Top)
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarrier(
                      size: 200.0, // Fixed height for demo
                      isBottom: false,
                    ),
                  ),
                  // Barrier 1 (Bottom)
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarrier(
                      size: 200.0,
                      isBottom: true,
                    ),
                  ),

                  // Barrier 2 (Top)
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarrier(
                      size: 150.0,
                      isBottom: false,
                    ),
                  ),
                  // Barrier 2 (Bottom)
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarrier(
                      size: 250.0,
                      isBottom: true,
                    ),
                  ),

                  // Tap to Play Text
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: gameHasStarted
                        ? const SizedBox()
                        : const Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("SCORE", style: TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 20),
                        Text(score.toString(), style: const TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("BEST", style: TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 20),
                        Text(bestScore.toString(), style: const TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
