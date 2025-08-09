class Quiz {
  final String id;
  final String title;
  final String description;
  final QuizDifficulty difficulty;
  final QuizCategory category;
  final int duration; // in minutes
  final int totalQuestions;
  final List<Question> questions;
  final DateTime createdAt;
  final String createdBy;
  final bool isActive;
  final double? passingScore;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.duration,
    required this.totalQuestions,
    required this.questions,
    required this.createdAt,
    required this.createdBy,
    this.isActive = true,
    this.passingScore,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == json['difficulty'],
        orElse: () => QuizDifficulty.easy,
      ),
      category: QuizCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => QuizCategory.general,
      ),
      duration: json['duration'] as int,
      totalQuestions: json['total_questions'] as int,
      questions: (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
      isActive: json['is_active'] as bool? ?? true,
      passingScore: (json['passing_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty.toString().split('.').last,
      'category': category.toString().split('.').last,
      'duration': duration,
      'total_questions': totalQuestions,
      'questions': questions.map((q) => q.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
      'is_active': isActive,
      'passing_score': passingScore,
    };
  }
}

class Question {
  final String id;
  final String question;
  final QuestionType type;
  final List<String> options;
  final dynamic correctAnswer; // String for MCQ, List<String> for multiple answers
  final String? explanation;
  final int points;
  final String? codeSnippet;

  Question({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.points = 1,
    this.codeSnippet,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<String>.from(json['options'] as List? ?? []),
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'] as String?,
      points: json['points'] as int? ?? 1,
      codeSnippet: json['code_snippet'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.toString().split('.').last,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'points': points,
      'code_snippet': codeSnippet,
    };
  }
}

enum QuizDifficulty {
  easy,
  medium,
  hard,
  expert,
}

enum QuizCategory {
  general,
  programming,
  algorithms,
  dataStructures,
  systemDesign,
  database,
  networking,
  security,
  frontend,
  backend,
  mobile,
  devops,
}

enum QuestionType {
  multipleChoice,
  trueFalse,
  textInput,
  codeReview,
  logicalReasoning,
}

extension QuizDifficultyExtension on QuizDifficulty {
  String get displayName {
    switch (this) {
      case QuizDifficulty.easy:
        return 'Easy';
      case QuizDifficulty.medium:
        return 'Medium';
      case QuizDifficulty.hard:
        return 'Hard';
      case QuizDifficulty.expert:
        return 'Expert';
    }
  }

  String get colorHex {
    switch (this) {
      case QuizDifficulty.easy:
        return '#10B981'; // Green
      case QuizDifficulty.medium:
        return '#F59E0B'; // Yellow
      case QuizDifficulty.hard:
        return '#EF4444'; // Red
      case QuizDifficulty.expert:
        return '#8B5CF6'; // Purple
    }
  }
}

extension QuizCategoryExtension on QuizCategory {
  String get displayName {
    switch (this) {
      case QuizCategory.general:
        return 'General';
      case QuizCategory.programming:
        return 'Programming';
      case QuizCategory.algorithms:
        return 'Algorithms';
      case QuizCategory.dataStructures:
        return 'Data Structures';
      case QuizCategory.systemDesign:
        return 'System Design';
      case QuizCategory.database:
        return 'Database';
      case QuizCategory.networking:
        return 'Networking';
      case QuizCategory.security:
        return 'Security';
      case QuizCategory.frontend:
        return 'Frontend';
      case QuizCategory.backend:
        return 'Backend';
      case QuizCategory.mobile:
        return 'Mobile';
      case QuizCategory.devops:
        return 'DevOps';
    }
  }
}
