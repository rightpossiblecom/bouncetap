import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;

class GameViewModel extends ChangeNotifier {
  static const double initialGravity = 500.0;
  static const double gravityIncreaseRate = 8.0;
  static const double maxGravity = 1000.0;
  static const double bounceForce = 420.0;
  static const double comboBounceBoost = 28.0;
  static const double ballRadius = 22.0;
  static const double initialHorizontalSpeed = 120.0;
  static const double horizontalSpeedIncreaseRate = 4.0;
  static const double maxHorizontalSpeed = 280.0;
  static const int perfectTapWindowMs = 450;
  static const int comboTimeoutMs = 1200;
  static const int maxComboMultiplier = 5;
  static const int maxTrailLength = 12;
  static const double ceilingBounceDamping = 0.5;

  late double ballX;
  late double ballY;
  late double ballVelocityX;
  late double ballVelocityY;
  late double currentGravity;
  late int score;
  late int comboMultiplier;
  late int highScore;
  late List<int> allTimeHighScores;
  late bool isGameOver;
  late bool isGameRunning;

  int totalTaps = 0;
  int bestCombo = 0;
  bool isNewHighScore = false;
  int finalElapsedMs = 0;
  List<Offset> ballTrail = [];

  double screenWidth = 0;
  double screenHeight = 0;

  Timer? _gameTimer;
  Stopwatch? _stopwatch;
  int _lastFrameElapsedMs = 0;
  int _lastTapElapsedMs = 0;
  double _scoreProgress = 0;

  double get dangerLevel {
    if (screenHeight <= 0 || !isGameRunning) return 0;
    final normalizedY = (ballY / screenHeight).clamp(0.0, 1.0);
    return ((normalizedY - 0.6) / 0.3).clamp(0.0, 1.0);
  }

  int get elapsedSeconds {
    final ms = finalElapsedMs > 0
        ? finalElapsedMs
        : (_stopwatch?.elapsedMilliseconds ?? 0);
    return ms ~/ 1000;
  }

  GameViewModel() {
    developer.log('GameViewModel initialized', name: 'GameViewModel');
    highScore = 0;
    allTimeHighScores = [120, 85, 42, 21, 15];
    _resetGame();
  }

  void _resetGame() {
    developer.log('Resetting game state', name: 'GameViewModel');
    ballX = screenWidth > 0 ? screenWidth / 2 : 0;
    ballY = screenHeight > 0 ? screenHeight / 2 : 0;
    ballVelocityX = initialHorizontalSpeed;
    ballVelocityY = 0;
    currentGravity = initialGravity;
    score = 0;
    comboMultiplier = 1;
    totalTaps = 0;
    bestCombo = 0;
    isNewHighScore = false;
    finalElapsedMs = 0;
    ballTrail = [];
    _lastFrameElapsedMs = 0;
    _lastTapElapsedMs = 0;
    _scoreProgress = 0;
    isGameOver = false;
    isGameRunning = false;
  }

  void initializeScreen(double width, double height) {
    developer.log(
      'Initializing screen: $width x $height',
      name: 'GameViewModel',
    );
    screenWidth = width;
    screenHeight = height;

    if (!isGameRunning && !isGameOver) {
      ballX = screenWidth / 2;
      ballY = screenHeight / 2;
      ballVelocityY = 0;
      notifyListeners();
    }
  }

  void startGame() {
    if (screenWidth <= 0 || screenHeight <= 0) {
      developer.log(
        'Cannot start game: invalid screen dimensions ($screenWidth x $screenHeight)',
        name: 'GameViewModel',
        level: 900,
      );
      return;
    }

    developer.log('Starting game', name: 'GameViewModel');
    _gameTimer?.cancel();
    _stopwatch?.stop();

    _resetGame();
    isGameRunning = true;
    ballX = screenWidth / 2;
    ballY = screenHeight / 2;

    _stopwatch = Stopwatch()..start();
    _lastFrameElapsedMs = 0;
    _lastTapElapsedMs = 0;

    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _updateGame();
    });

    notifyListeners();
  }

  void _updateGame() {
    if (!isGameRunning || isGameOver) return;
    if (_stopwatch == null) return;

    final elapsedMs = _stopwatch!.elapsedMilliseconds;
    final frameDeltaMs =
        _lastFrameElapsedMs == 0 ? 16 : elapsedMs - _lastFrameElapsedMs;
    _lastFrameElapsedMs = elapsedMs;

    final double deltaTime = (frameDeltaMs / 1000).clamp(0.001, 0.05);

    currentGravity =
        (initialGravity + (elapsedMs / 1000) * gravityIncreaseRate)
            .clamp(initialGravity, maxGravity);

    final currentHorizontalSpeed =
        (initialHorizontalSpeed +
                (elapsedMs / 1000) * horizontalSpeedIncreaseRate)
            .clamp(initialHorizontalSpeed, maxHorizontalSpeed);
    ballVelocityX =
        ballVelocityX.isNegative
            ? -currentHorizontalSpeed
            : currentHorizontalSpeed;

    ballVelocityY += currentGravity * deltaTime;
    ballX += ballVelocityX * deltaTime;
    ballY += ballVelocityY * deltaTime;

    if (elapsedMs - _lastTapElapsedMs > comboTimeoutMs) {
      comboMultiplier = 1;
    }

    _scoreProgress += deltaTime * comboMultiplier;
    score = _scoreProgress.floor();

    ballTrail.add(Offset(ballX, ballY));
    if (ballTrail.length > maxTrailLength) {
      ballTrail.removeAt(0);
    }

    if (ballY + ballRadius >= screenHeight) {
      developer.log(
        'Game Over: ball hit bottom at $ballY (screenHeight: $screenHeight)',
        name: 'GameViewModel',
      );
      endGame();
      return;
    }

    if (ballY - ballRadius < 0) {
      ballY = ballRadius;
      ballVelocityY = ballVelocityY.abs() * ceilingBounceDamping;
    }

    if (ballX - ballRadius < 0) {
      ballX = ballRadius;
      ballVelocityX = ballVelocityX.abs();
    } else if (ballX + ballRadius > screenWidth) {
      ballX = screenWidth - ballRadius;
      ballVelocityX = -ballVelocityX.abs();
    }

    notifyListeners();
  }

  void onTap() {
    if (!isGameRunning || isGameOver) {
      developer.log(
        'Tap on game over/menu, starting game',
        name: 'GameViewModel',
      );
      startGame();
      return;
    }

    totalTaps++;

    final elapsedMs = _stopwatch?.elapsedMilliseconds ?? 0;
    final tapGap = elapsedMs - _lastTapElapsedMs;
    if (_lastTapElapsedMs > 0 && tapGap <= perfectTapWindowMs) {
      comboMultiplier = (comboMultiplier + 1).clamp(1, maxComboMultiplier);
    } else {
      comboMultiplier = 1;
    }
    _lastTapElapsedMs = elapsedMs;

    if (comboMultiplier > bestCombo) {
      bestCombo = comboMultiplier;
    }

    final boostedBounce =
        bounceForce + (comboMultiplier - 1) * comboBounceBoost;
    ballVelocityY = -boostedBounce;

    _scoreProgress += (0.4 * comboMultiplier);
    score = _scoreProgress.floor();

    notifyListeners();
  }

  void endGame() {
    developer.log('Ending game. Score: $score', name: 'GameViewModel');
    isGameRunning = false;
    isGameOver = true;
    finalElapsedMs = _stopwatch?.elapsedMilliseconds ?? 0;

    if (score > highScore) {
      highScore = score;
      isNewHighScore = true;
    }

    if (!allTimeHighScores.contains(score) && score > 0) {
      allTimeHighScores.add(score);
      allTimeHighScores.sort((a, b) => b.compareTo(a));
      if (allTimeHighScores.length > 10) {
        allTimeHighScores = allTimeHighScores.sublist(0, 10);
      }
    }

    _gameTimer?.cancel();
    _stopwatch?.stop();
    notifyListeners();
  }

  void restartGame() {
    developer.log('Restarting game', name: 'GameViewModel');
    _gameTimer?.cancel();
    startGame();
  }

  @override
  void dispose() {
    developer.log('Disposing GameViewModel', name: 'GameViewModel');
    _gameTimer?.cancel();
    _stopwatch?.stop();
    super.dispose();
  }
}
