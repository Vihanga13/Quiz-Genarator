import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz_attempt.dart';
import '../config/app_theme.dart';

class PerformanceChart extends StatelessWidget {
  final QuizAttempt attempt;

  const PerformanceChart({
    super.key,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    final correctAnswers = attempt.answers.where((a) => a.isCorrect).length;
    final incorrectAnswers = attempt.answers.length - correctAnswers;
    final unanswered = attempt.maxScore - attempt.answers.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.chartBar,
                  color: AppColors.deepBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Performance Chart',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.graphiteBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Custom circular progress indicator
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    // Background circle
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 12,
                        backgroundColor: AppColors.lightGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.lightGray,
                        ),
                      ),
                    ),
                    // Correct answers progress
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: correctAnswers / attempt.maxScore,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.success,
                        ),
                      ),
                    ),
                    // Center content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${attempt.percentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.graphiteBlack,
                            ),
                          ),
                          const Text(
                            'Score',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 14,
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                  'Correct',
                  correctAnswers,
                  AppColors.success,
                ),
                _buildLegendItem(
                  'Incorrect',
                  incorrectAnswers,
                  AppColors.error,
                ),
                if (unanswered > 0)
                  _buildLegendItem(
                    'Unanswered',
                    unanswered,
                    AppColors.mediumGray,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 12,
            color: AppColors.mediumGray,
          ),
        ),
      ],
    );
  }
}
