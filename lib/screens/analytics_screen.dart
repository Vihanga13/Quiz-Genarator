import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/analytics_provider.dart';
import '../config/app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, analyticsProvider, child) {
          if (analyticsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (analyticsProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.triangleExclamation,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading analytics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(analyticsProvider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => analyticsProvider.fetchAnalytics(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final analytics = analyticsProvider.analyticsData;
          if (analytics == null) {
            return const Center(
              child: Text('No analytics data available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(analytics),
                const SizedBox(height: 24),
                _buildPerformanceSection(),
                const SizedBox(height: 24),
                _buildRecentActivity(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(AnalyticsData analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: FontAwesomeIcons.clipboardCheck,
                title: 'Total Quizzes',
                value: analytics.totalQuizzesTaken.toString(),
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
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
              child: _buildMetricCard(
                icon: FontAwesomeIcons.chartLine,
                title: 'Average Score',
                value: '${analytics.averageScore.toStringAsFixed(1)}%',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: FontAwesomeIcons.percentage,
                title: 'Pass Rate',
                value: '${analytics.passRate.toStringAsFixed(1)}%',
                color: AppColors.info,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
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
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance by Category',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.graphiteBlack.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildCategoryPerformanceItem('Mobile Development', 85.0),
              _buildCategoryPerformanceItem('Web Development', 78.0),
              _buildCategoryPerformanceItem('Data Structures', 80.0),
              _buildCategoryPerformanceItem('Algorithms', 75.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPerformanceItem(String category, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.graphiteBlack,
                ),
              ),
              Text(
                '${score.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(score),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.graphiteBlack.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: FontAwesomeIcons.clipboardCheck,
                title: 'Completed Flutter Fundamentals',
                subtitle: 'Score: 80%',
                time: '2 hours ago',
                color: AppColors.success,
              ),
              const Divider(height: 1),
              _buildActivityItem(
                icon: FontAwesomeIcons.award,
                title: 'Earned Certificate',
                subtitle: 'Data Structures & Algorithms',
                time: '1 day ago',
                color: AppColors.primaryPurple,
              ),
              const Divider(height: 1),
              _buildActivityItem(
                icon: FontAwesomeIcons.play,
                title: 'Started JavaScript ES6+ Features',
                subtitle: 'Quiz in progress',
                time: '2 days ago',
                color: AppColors.info,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.graphiteBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) {
      return AppColors.success;
    } else if (score >= 80) {
      return AppColors.warning;
    } else if (score >= 70) {
      return AppColors.info;
    } else {
      return AppColors.error;
    }
  }
}
