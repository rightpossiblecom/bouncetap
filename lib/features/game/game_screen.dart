import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_view_model.dart';
import '../../core/theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (viewModel.screenWidth != constraints.maxWidth ||
                  viewModel.screenHeight != constraints.maxHeight) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  viewModel.initializeScreen(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                });
              }

              return GestureDetector(
                onTap: viewModel.onTap,
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: GamePainter(
                        ballX: viewModel.ballX,
                        ballY: viewModel.ballY,
                        ballRadius: GameViewModel.ballRadius,
                        comboMultiplier: viewModel.comboMultiplier,
                        trail: List.from(viewModel.ballTrail),
                        dangerLevel: viewModel.dangerLevel,
                        isGameRunning: viewModel.isGameRunning,
                      ),
                      size: Size.infinite,
                    ),

                    if (viewModel.isGameRunning)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 0,
                        right: 0,
                        child: _buildHUD(viewModel),
                      ),

                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.pop(context),
                        color: AppTheme.slate,
                        iconSize: 26,
                      ),
                    ),

                    if (!viewModel.isGameRunning && !viewModel.isGameOver)
                      const StartOverlay(),

                    if (viewModel.isGameOver)
                      GameOverOverlay(
                        score: viewModel.score,
                        bestCombo: viewModel.bestCombo,
                        totalTaps: viewModel.totalTaps,
                        elapsedSeconds: viewModel.elapsedSeconds,
                        isNewHighScore: viewModel.isNewHighScore,
                        highScore: viewModel.highScore,
                        onRestart: viewModel.restartGame,
                        onHome: () => Navigator.pop(context),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHUD(GameViewModel viewModel) {
    final comboColor = AppTheme.comboColor(viewModel.comboMultiplier);

    return Column(
      children: [
        Text(
          '${viewModel.score}',
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            color: AppTheme.white,
            letterSpacing: -1,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(GameViewModel.maxComboMultiplier, (index) {
            final isActive = index < viewModel.comboMultiplier;
            return Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? comboColor : AppTheme.slate,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: comboColor.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),
        if (viewModel.comboMultiplier > 1)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'x${viewModel.comboMultiplier}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: comboColor,
                letterSpacing: 1,
              ),
            ),
          ),
      ],
    );
  }
}

class GamePainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballRadius;
  final int comboMultiplier;
  final List<Offset> trail;
  final double dangerLevel;
  final bool isGameRunning;

  GamePainter({
    required this.ballX,
    required this.ballY,
    required this.ballRadius,
    required this.comboMultiplier,
    required this.trail,
    required this.dangerLevel,
    required this.isGameRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final comboColor = AppTheme.comboColor(comboMultiplier);

    // Danger zone tint at the bottom of the screen
    if (dangerLevel > 0 && isGameRunning) {
      final dangerRect = Rect.fromLTWH(
        0,
        size.height * 0.75,
        size.width,
        size.height * 0.25,
      );
      final dangerPaint = Paint()
        ..color = AppTheme.dangerRed.withValues(alpha: dangerLevel * 0.12);
      canvas.drawRect(dangerRect, dangerPaint);

      final linePaint = Paint()
        ..color = AppTheme.dangerRed.withValues(alpha: dangerLevel * 0.4)
        ..strokeWidth = 1.5;
      canvas.drawLine(
        Offset(0, size.height * 0.85),
        Offset(size.width, size.height * 0.85),
        linePaint,
      );
    }

    // Ball trail
    if (isGameRunning) {
      for (int i = 0; i < trail.length; i++) {
        final progress = (i + 1) / trail.length;
        final opacity = progress * 0.3;
        final trailRadius = ballRadius * (0.2 + 0.8 * progress);
        final trailPaint = Paint()
          ..color = comboColor.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(trail[i], trailRadius, trailPaint);
      }
    }

    // Combo glow ring
    if (comboMultiplier > 1 && isGameRunning) {
      final glowRadius = ballRadius + 4.0 + (comboMultiplier * 3.0);
      final glowPaint = Paint()
        ..color = comboColor.withValues(alpha: 0.15 + comboMultiplier * 0.03)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          12.0 + comboMultiplier * 2.0,
        );
      canvas.drawCircle(Offset(ballX, ballY), glowRadius, glowPaint);
    }

    // Ball shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(ballX + 2, ballY + 4), ballRadius, shadowPaint);

    // Ball fill
    final ballPaint = Paint()
      ..color =
          (comboMultiplier > 1 && isGameRunning) ? comboColor : AppTheme.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(ballX, ballY), ballRadius, ballPaint);

    // Specular highlight for a classic 3D look
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(ballX - ballRadius * 0.28, ballY - ballRadius * 0.28),
      ballRadius * 0.3,
      highlightPaint,
    );

    // Subtle edge ring
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(ballX, ballY), ballRadius, ringPaint);
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return oldDelegate.ballX != ballX ||
        oldDelegate.ballY != ballY ||
        oldDelegate.comboMultiplier != comboMultiplier ||
        oldDelegate.dangerLevel != dangerLevel ||
        oldDelegate.trail.length != trail.length;
  }
}

class StartOverlay extends StatelessWidget {
  const StartOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navy.withValues(alpha: 0.88),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.touch_app_rounded,
                size: 48,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'TAP TO START',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Keep the ball alive. Chain taps for combos.',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.lightSlate,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  final int score;
  final int bestCombo;
  final int totalTaps;
  final int elapsedSeconds;
  final bool isNewHighScore;
  final int highScore;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const GameOverOverlay({
    required this.score,
    required this.bestCombo,
    required this.totalTaps,
    required this.elapsedSeconds,
    required this.isNewHighScore,
    required this.highScore,
    required this.onRestart,
    required this.onHome,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navy.withValues(alpha: 0.93),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.dangerRed,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'POINTS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightSlate,
                  letterSpacing: 3,
                ),
              ),

              if (isNewHighScore) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppTheme.gold,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'NEW BEST!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.gold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.deepBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1D3461)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('TAPS', '$totalTaps'),
                    _divider(),
                    _buildStat('COMBO', 'x$bestCombo'),
                    _divider(),
                    _buildStat('TIME', '${elapsedSeconds}s'),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onHome,
                child: const Text(
                  'HOME',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightSlate,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightSlate,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: const Color(0xFF1D3461),
    );
  }
}
