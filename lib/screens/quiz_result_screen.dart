import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz_attempt.dart';
import '../config/app_theme.dart';
import '../widgets/result_summary_card.dart';
import '../widgets/performance_chart.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizAttempt attempt;

  const QuizResultScreen({
    super.key,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Results',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: attempt.isPassed ? AppColors.success : AppColors.error,
        foregroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _shareResults(context),
            icon: const Icon(FontAwesomeIcons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildResultHeader(),
            _buildResultSummary(),
            _buildPerformanceDetails(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: attempt.isPassed ? AppColors.success : AppColors.error,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.2),
            ),
            child: Icon(
              attempt.isPassed ? FontAwesomeIcons.trophy : FontAwesomeIcons.xmark,
              size: 48,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            attempt.isPassed ? 'Congratulations!' : 'Better Luck Next Time!',
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            attempt.isPassed 
                ? 'You have successfully passed the quiz!'
                : 'Keep practicing and try again.',
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 16,
              color: AppColors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '${attempt.percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: attempt.isPassed ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ResultSummaryCard(attempt: attempt),
    );
  }

  Widget _buildPerformanceDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Breakdown',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.graphiteBlack,
            ),
          ),
          const SizedBox(height: 16),
          PerformanceChart(attempt: attempt),
          const SizedBox(height: 20),
          _buildStatistics(),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final correctAnswers = attempt.answers.where((a) => a.isCorrect).length;
    final incorrectAnswers = attempt.answers.length - correctAnswers;
    final averageTimePerQuestion = attempt.answers.isNotEmpty 
        ? attempt.timeSpent / attempt.answers.length 
        : 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: FontAwesomeIcons.check,
                title: 'Correct',
                value: correctAnswers.toString(),
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: FontAwesomeIcons.xmark,
                title: 'Incorrect',
                value: incorrectAnswers.toString(),
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: FontAwesomeIcons.clock,
                title: 'Total Time',
                value: attempt.formattedDuration,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: FontAwesomeIcons.chartBar,
                title: 'Avg per Q',
                value: '${averageTimePerQuestion.toInt()}s',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 20,
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (attempt.isPassed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadCertificate(context),
                icon: const Icon(FontAwesomeIcons.download),
                label: const Text('Download Certificate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _reviewAnswers(context),
                  icon: const Icon(FontAwesomeIcons.eye),
                  label: const Text('Review Answers'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _retakeQuiz(context),
                  icon: const Icon(FontAwesomeIcons.redo),
                  label: const Text('Retake Quiz'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).popUntil(
                (route) => route.isFirst,
              ),
              icon: const Icon(FontAwesomeIcons.house),
              label: const Text('Back to Home'),
            ),
          ),
        ],
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
      ),
    );
  }

  void _downloadCertificate(BuildContext context) {
    // TODO: Implement certificate download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate download started!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _reviewAnswers(BuildContext context) {
    // TODO: Navigate to answer review screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Answer review coming soon!'),
      ),
    );
  }

  void _retakeQuiz(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    // TODO: Navigate back to quiz selection
  }
}
