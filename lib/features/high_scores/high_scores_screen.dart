import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../game/game_view_model.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      appBar: AppBar(
        backgroundColor: AppTheme.navy,
        title: const Text('LEADERBOARD'),
        centerTitle: true,
      ),
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          final scores = viewModel.allTimeHighScores;

          if (scores.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80,
                    color: AppTheme.slate,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No scores yet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Play a game to set your first record',
                    style: TextStyle(color: AppTheme.lightSlate),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: scores.length,
            itemBuilder: (context, index) {
              return _buildScoreRow(
                index + 1,
                scores[index],
                viewModel.highScore,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScoreRow(int rank, int score, int highScore) {
    final isTop3 = rank <= 3;
    final Color medalColor;
    final IconData? medalIcon;

    switch (rank) {
      case 1:
        medalColor = AppTheme.gold;
        medalIcon = Icons.looks_one_rounded;
        break;
      case 2:
        medalColor = AppTheme.silver;
        medalIcon = Icons.looks_two_rounded;
        break;
      case 3:
        medalColor = AppTheme.bronze;
        medalIcon = Icons.looks_3_rounded;
        break;
      default:
        medalColor = AppTheme.slate;
        medalIcon = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isTop3 ? AppTheme.deepBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              isTop3 ? medalColor.withValues(alpha: 0.3) : const Color(0xFF1D3461),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: medalIcon != null
                ? Icon(medalIcon, color: medalColor, size: 28)
                : Text(
                    '#$rank',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slate,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: isTop3 ? 24 : 20,
                fontWeight: FontWeight.w800,
                color: isTop3 ? AppTheme.white : AppTheme.lightSlate,
              ),
            ),
          ),
          if (score == highScore)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'BEST',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accent,
                  letterSpacing: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
