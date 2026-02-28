import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_view_model.dart';
import '../settings/settings_screen.dart';
import '../high_scores/high_scores_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<GameViewModel>();
      final screenSize = MediaQuery.of(context).size;
      viewModel.initializeScreen(screenSize.width, screenSize.height);
      viewModel.startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: viewModel.onTap,
            child: Stack(
              children: [
                // Game canvas with ball
                CustomPaint(
                  painter: BallPainter(
                    ballX: viewModel.ballX,
                    ballY: viewModel.ballY,
                    ballRadius: GameViewModel.ballRadius,
                    ballColor: colorScheme.primary,
                  ),
                  size: Size.infinite,
                ),
                // Score display
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Score: ${viewModel.score}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                // Navigation buttons
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    color: colorScheme.onSurface,
                    iconSize: 32,
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.emoji_events),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HighScoresScreen(),
                        ),
                      );
                    },
                    color: colorScheme.onSurface,
                    iconSize: 32,
                  ),
                ),
                // Game Over overlay
                if (viewModel.isGameOver)
                  GameOverOverlay(
                    score: viewModel.score,
                    onRestart: viewModel.restartGame,
                    onHome: () => Navigator.pop(context),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballRadius;
  final Color ballColor;

  BallPainter({
    required this.ballX,
    required this.ballY,
    required this.ballRadius,
    required this.ballColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ballColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(ballX, ballY), ballRadius, paint);
  }

  @override
  bool shouldRepaint(BallPainter oldDelegate) {
    return oldDelegate.ballX != ballX || oldDelegate.ballY != ballY;
  }
}

class GameOverOverlay extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const GameOverOverlay({
    required this.score,
    required this.onRestart,
    required this.onHome,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Final Score: $score',
              style: TextStyle(fontSize: 32, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onRestart,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: Text(
                'Restart',
                style: TextStyle(fontSize: 20, color: colorScheme.onPrimary),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onHome,
              child: Text(
                'Home',
                style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
