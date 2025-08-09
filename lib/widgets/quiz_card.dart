import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz.dart';
import '../config/app_theme.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          quiz.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.mediumGray,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(quiz.difficulty).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getDifficultyColor(quiz.difficulty),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      quiz.difficulty.displayName,
                      style: TextStyle(
                        color: _getDifficultyColor(quiz.difficulty),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(
                    icon: FontAwesomeIcons.clock,
                    label: '${quiz.duration} min',
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: FontAwesomeIcons.listCheck,
                    label: '${quiz.totalQuestions} questions',
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: FontAwesomeIcons.tag,
                    label: quiz.category.displayName,
                    color: AppColors.deepBlue,
                  ),
                ],
              ),
              if (quiz.passingScore != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.bullseye,
                      size: 12,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Passing Score: ${quiz.passingScore!.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created ${_formatDate(quiz.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    children: [
                      Text(
                        'Start Quiz',
                        style: TextStyle(
                          color: AppColors.deepBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        FontAwesomeIcons.arrowRight,
                        size: 14,
                        color: AppColors.deepBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return AppColors.success;
      case QuizDifficulty.medium:
        return AppColors.warning;
      case QuizDifficulty.hard:
        return AppColors.error;
      case QuizDifficulty.expert:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
