import 'package:flutter/foundation.dart';
import '../models/quiz_attempt.dart';
import '../models/certificate.dart';

class AnalyticsData {
  final int totalQuizzesTaken;
  final int totalQuizzesPassed;
  final double averageScore;
  final int totalTimeSpent; // in minutes
  final Map<String, int> categoryPerformance;
  final List<QuizAttempt> recentAttempts;
  final Map<String, double> difficultyStats;

  AnalyticsData({
    required this.totalQuizzesTaken,
    required this.totalQuizzesPassed,
    required this.averageScore,
    required this.totalTimeSpent,
    required this.categoryPerformance,
    required this.recentAttempts,
    required this.difficultyStats,
  });

  double get passRate {
    if (totalQuizzesTaken == 0) return 0.0;
    return (totalQuizzesPassed / totalQuizzesTaken) * 100;
  }

  String get formattedTotalTime {
    final hours = totalTimeSpent ~/ 60;
    final minutes = totalTimeSpent % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class AnalyticsProvider extends ChangeNotifier {
  AnalyticsData? _analyticsData;
  List<Certificate> _certificates = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  AnalyticsData? get analyticsData => _analyticsData;
  List<Certificate> get certificates => _certificates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Demo data
  final List<QuizAttempt> _demoAttempts = [
    QuizAttempt(
      id: '1',
      quizId: '1',
      userId: '1',
      startedAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 1, hours: -1)),
      answers: [],
      totalScore: 8,
      maxScore: 10,
      percentage: 80.0,
      isPassed: true,
      status: AttemptStatus.completed,
      timeSpent: 1800, // 30 minutes
    ),
    QuizAttempt(
      id: '2',
      quizId: '2',
      userId: '1',
      startedAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 3, hours: -1)),
      answers: [],
      totalScore: 22,
      maxScore: 30,
      percentage: 73.3,
      isPassed: false,
      status: AttemptStatus.completed,
      timeSpent: 2700, // 45 minutes
    ),
    QuizAttempt(
      id: '3',
      quizId: '3',
      userId: '1',
      startedAt: DateTime.now().subtract(const Duration(days: 7)),
      completedAt: DateTime.now().subtract(const Duration(days: 7, hours: -1)),
      answers: [],
      totalScore: 48,
      maxScore: 60,
      percentage: 80.0,
      isPassed: true,
      status: AttemptStatus.completed,
      timeSpent: 3600, // 60 minutes
    ),
  ];

  final List<Certificate> _demoCertificates = [
    Certificate(
      id: '1',
      userId: '1',
      quizId: '1',
      quizTitle: 'Flutter Fundamentals',
      userName: 'John Doe',
      score: 80.0,
      passingScore: 70.0,
      issuedAt: DateTime.now().subtract(const Duration(days: 1)),
      certificateUrl: 'https://certificates.techno-quiz.com/cert-1.pdf',
      status: CertificateStatus.active,
      verificationCode: 'TQ-FLUTTER-2024-001',
    ),
    Certificate(
      id: '3',
      userId: '1',
      quizId: '3',
      quizTitle: 'Data Structures & Algorithms',
      userName: 'John Doe',
      score: 80.0,
      passingScore: 80.0,
      issuedAt: DateTime.now().subtract(const Duration(days: 7)),
      certificateUrl: 'https://certificates.techno-quiz.com/cert-3.pdf',
      status: CertificateStatus.active,
      verificationCode: 'TQ-DSA-2024-003',
    ),
  ];

  AnalyticsProvider() {
    _loadAnalytics();
  }

  void _loadAnalytics() {
    _analyticsData = AnalyticsData(
      totalQuizzesTaken: _demoAttempts.length,
      totalQuizzesPassed: _demoAttempts.where((a) => a.isPassed).length,
      averageScore: _demoAttempts.isNotEmpty
          ? _demoAttempts.map((a) => a.percentage).reduce((a, b) => a + b) /
              _demoAttempts.length
          : 0.0,
      totalTimeSpent: _demoAttempts
          .map((a) => a.timeSpent ~/ 60)
          .fold(0, (sum, time) => sum + time),
      categoryPerformance: {
        'Mobile': 1,
        'Programming': 1,
        'Algorithms': 1,
      },
      recentAttempts: List.from(_demoAttempts),
      difficultyStats: {
        'Easy': 0.0,
        'Medium': 80.0,
        'Hard': 73.3,
        'Expert': 80.0,
      },
    );
    _certificates = List.from(_demoCertificates);
    notifyListeners();
  }

  Future<void> fetchAnalytics() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      _loadAnalytics();
    } catch (e) {
      _setError('Failed to load analytics data');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCertificates() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      _certificates = List.from(_demoCertificates);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load certificates');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> downloadCertificate(String certificateId) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate download delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would trigger the actual download
      // For now, we'll just return success
      return true;
    } catch (e) {
      _setError('Failed to download certificate');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<QuizAttempt> getAttemptsByDateRange(DateTime start, DateTime end) {
    return _demoAttempts.where((attempt) {
      final attemptDate = attempt.completedAt ?? attempt.startedAt;
      return attemptDate.isAfter(start) && attemptDate.isBefore(end);
    }).toList();
  }

  Map<String, double> getCategoryPerformance() {
    // Mock category performance data
    return {
      'Mobile Development': 85.0,
      'Web Development': 78.0,
      'Data Structures': 80.0,
      'Algorithms': 75.0,
      'System Design': 70.0,
      'Database': 82.0,
    };
  }

  Map<String, int> getMonthlyAttempts() {
    // Mock monthly attempts data
    return {
      'Jan': 5,
      'Feb': 8,
      'Mar': 12,
      'Apr': 15,
      'May': 10,
      'Jun': 18,
    };
  }

  List<Map<String, dynamic>> getRecentActivity() {
    return [
      {
        'type': 'quiz_completed',
        'title': 'Flutter Fundamentals',
        'score': 80.0,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'type': 'certificate_earned',
        'title': 'Data Structures & Algorithms',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'type': 'quiz_started',
        'title': 'JavaScript ES6+ Features',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      },
    ];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
