import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game/game_view_model.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Top Taps'), centerTitle: true),
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
                    size: 100,
                    color: colorScheme.outline.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No scores yet!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Play a game and set a record!'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              return _buildScoreTile(index + 1, score, colorScheme);
            },
          );
        },
      ),
    );
  }

  Widget _buildScoreTile(int rank, int score, ColorScheme colorScheme) {
    Color? rankColor;
    double? elevation;

    // Apply special styling for top 3
    if (rank == 1) {
      rankColor = Colors.amber;
      elevation = 4;
    } else if (rank == 2) {
      rankColor = Colors.grey[400];
      elevation = 2;
    } else if (rank == 3) {
      rankColor = Colors.brown[300];
      elevation = 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: elevation ?? 0.5,
        color: elevation != null ? colorScheme.surfaceContainerHighest : null,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rankColor ?? colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rankColor != null
                    ? Colors.black
                    : colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          title: Text(
            'Score: $score',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          trailing: const Icon(Icons.timer_outlined, size: 20),
        ),
      ),
    );
  }
}
