import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final int currentQuestion;
  final int totalQuestions;

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.cyberYellow,
                  ),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cyberYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cyberYellow),
              ),
              child: Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: AppFonts.jetBrainsMono,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cyberYellow,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
