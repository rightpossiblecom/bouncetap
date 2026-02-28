import 'package:flutter/material.dart';
import 'dart:async';

class GameViewModel extends ChangeNotifier {
  // Physics constants
  static const double initialGravity = 500.0; // pixels per second squared
  static const double gravityIncreaseRate = 10.0; // gravity increase per second
  static const double maxGravity =
      1000.0; // maximum gravity to keep game playable
  static const double bounceForce = 400.0; // pixels per second
  static const double ballRadius = 20.0;

  // Game state
  late double ballX;
  late double ballY;
  late double ballVelocityY;
  late double currentGravity;
  late int score;
  late int highScore;
  late List<int> allTimeHighScores;
  late bool isGameOver;
  late bool isGameRunning;

  // Screen dimensions (set by screen)
  late double screenWidth;
  late double screenHeight;

  // Update timer
  Timer? _gameTimer;
  late Stopwatch _stopwatch;

  GameViewModel() {
    screenWidth = 0;
    screenHeight = 0;
    highScore = 0;
    allTimeHighScores = [120, 85, 42, 21, 15]; // Mock high scores
    _resetGame();
  }

  void _resetGame() {
    ballX = 0;
    ballY = 0;
    ballVelocityY = 0;
    currentGravity = initialGravity;
    score = 0;
    isGameOver = false;
    isGameRunning = false;
  }

  void initializeScreen(double width, double height) {
    screenWidth = width;
    screenHeight = height;

    if (!isGameRunning && !isGameOver) {
      // First time initialization
      ballX = screenWidth / 2;
      ballY = screenHeight / 2;
      ballVelocityY = 0;
    }
  }

  void startGame() {
    _resetGame();
    isGameRunning = true;
    ballX = screenWidth / 2;
    ballY = screenHeight / 2;

    _stopwatch = Stopwatch()..start();

    // Update game state every 16ms (~60 FPS)
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _updateGame();
    });

    notifyListeners();
  }

  void _updateGame() {
    if (!isGameRunning || isGameOver) return;

    double deltaTime = 0.016; // 16ms in seconds

    // Increase gravity over time (but cap it at maxGravity)
    currentGravity =
        (initialGravity +
                (_stopwatch.elapsedMilliseconds / 1000) * gravityIncreaseRate)
            .clamp(initialGravity, maxGravity);

    // Apply gravity
    ballVelocityY += currentGravity * deltaTime;

    // Update position
    ballY += ballVelocityY * deltaTime;

    // Update score based on elapsed time (1 point per second)
    score = _stopwatch.elapsedMilliseconds ~/ 1000;

    // Check game over condition (ball hit bottom)
    if (ballY + ballRadius >= screenHeight) {
      endGame();
      return;
    }

    // Keep ball within screen bounds horizontally (shouldn't happen but safety)
    if (ballX - ballRadius < 0) {
      ballX = ballRadius;
    } else if (ballX + ballRadius > screenWidth) {
      ballX = screenWidth - ballRadius;
    }

    notifyListeners();
  }

  void onTap() {
    if (!isGameRunning || isGameOver) {
      startGame();
      return;
    }

    // Apply upward force
    ballVelocityY = -bounceForce;
    notifyListeners();
  }

  void endGame() {
    isGameRunning = false;
    isGameOver = true;

    // Check high score
    if (score > highScore) {
      highScore = score;
    }

    // Add to all-time high scores if it's high enough and sort/trim list
    if (!allTimeHighScores.contains(score) && score > 0) {
      allTimeHighScores.add(score);
      allTimeHighScores.sort((a, b) => b.compareTo(a));
      if (allTimeHighScores.length > 10) {
        allTimeHighScores = allTimeHighScores.sublist(0, 10);
      }
    }

    _gameTimer?.cancel();
    _stopwatch.stop();
    notifyListeners();
  }

  void restartGame() {
    _gameTimer?.cancel();
    startGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
