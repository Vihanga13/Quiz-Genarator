import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz_attempt.dart';
import '../config/app_theme.dart';

class ResultSummaryCard extends StatelessWidget {
  final QuizAttempt attempt;

  const ResultSummaryCard({
    super.key,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.chartPie,
                  color: AppColors.deepBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.graphiteBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Score',
              '${attempt.totalScore} / ${attempt.maxScore}',
              AppColors.deepBlue,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Percentage',
              '${attempt.percentage.toStringAsFixed(1)}%',
              attempt.isPassed ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Status',
              attempt.isPassed ? 'PASSED' : 'FAILED',
              attempt.isPassed ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Time Taken',
              attempt.formattedDuration,
              AppColors.info,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Questions Answered',
              '${attempt.answers.length} / ${attempt.maxScore}', // Assuming 1 point per question
              AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            color: AppColors.mediumGray,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
