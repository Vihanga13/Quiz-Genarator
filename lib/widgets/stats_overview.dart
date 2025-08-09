import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/analytics_provider.dart';
import '../config/app_theme.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, child) {
        final analytics = analyticsProvider.analyticsData;
        
        if (analytics == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Your Progress',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.graphiteBlack,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: FontAwesomeIcons.clipboardCheck,
                    title: 'Quizzes Taken',
                    value: analytics.totalQuizzesTaken.toString(),
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: FontAwesomeIcons.trophy,
                    title: 'Passed',
                    value: analytics.totalQuizzesPassed.toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: FontAwesomeIcons.chartLine,
                    title: 'Avg Score',
                    value: '${analytics.averageScore.toStringAsFixed(1)}%',
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: FontAwesomeIcons.clock,
                    title: 'Time Spent',
                    value: analytics.formattedTotalTime,
                    color: AppColors.deepBlue,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(
                FontAwesomeIcons.arrowTrendUp,
                size: 12,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.graphiteBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
