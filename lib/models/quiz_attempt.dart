class QuizAttempt {
  final String id;
  final String quizId;
  final String userId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<QuestionAttempt> answers;
  final int totalScore;
  final int maxScore;
  final double percentage;
  final bool isPassed;
  final AttemptStatus status;
  final int timeSpent; // in seconds

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.startedAt,
    this.completedAt,
    required this.answers,
    required this.totalScore,
    required this.maxScore,
    required this.percentage,
    required this.isPassed,
    required this.status,
    required this.timeSpent,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      userId: json['user_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      answers: (json['answers'] as List?)
              ?.map((a) => QuestionAttempt.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      totalScore: json['total_score'] as int,
      maxScore: json['max_score'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      isPassed: json['is_passed'] as bool,
      status: AttemptStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AttemptStatus.inProgress,
      ),
      timeSpent: json['time_spent'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'user_id': userId,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'answers': answers.map((a) => a.toJson()).toList(),
      'total_score': totalScore,
      'max_score': maxScore,
      'percentage': percentage,
      'is_passed': isPassed,
      'status': status.toString().split('.').last,
      'time_spent': timeSpent,
    };
  }

  Duration get duration {
    return Duration(seconds: timeSpent);
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

class QuestionAttempt {
  final String questionId;
  final dynamic userAnswer;
  final dynamic correctAnswer;
  final bool isCorrect;
  final int pointsEarned;
  final int maxPoints;
  final int timeSpent; // in seconds

  QuestionAttempt({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.pointsEarned,
    required this.maxPoints,
    required this.timeSpent,
  });

  factory QuestionAttempt.fromJson(Map<String, dynamic> json) {
    return QuestionAttempt(
      questionId: json['question_id'] as String,
      userAnswer: json['user_answer'],
      correctAnswer: json['correct_answer'],
      isCorrect: json['is_correct'] as bool,
      pointsEarned: json['points_earned'] as int,
      maxPoints: json['max_points'] as int,
      timeSpent: json['time_spent'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'user_answer': userAnswer,
      'correct_answer': correctAnswer,
      'is_correct': isCorrect,
      'points_earned': pointsEarned,
      'max_points': maxPoints,
      'time_spent': timeSpent,
    };
  }
}

enum AttemptStatus {
  inProgress,
  completed,
  abandoned,
  timeExpired,
}

extension AttemptStatusExtension on AttemptStatus {
  String get displayName {
    switch (this) {
      case AttemptStatus.inProgress:
        return 'In Progress';
      case AttemptStatus.completed:
        return 'Completed';
      case AttemptStatus.abandoned:
        return 'Abandoned';
      case AttemptStatus.timeExpired:
        return 'Time Expired';
    }
  }
}
