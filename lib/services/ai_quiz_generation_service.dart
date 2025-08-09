import 'package:flutter/foundation.dart';
import '../models/quiz.dart';

class AIQuizGenerationService {
  static const Map<QuizCategory, List<String>> _categoryTopics = {
    QuizCategory.programming: [
      'Variables and Data Types',
      'Control Structures',
      'Functions and Methods',
      'Object-Oriented Programming',
      'Error Handling',
      'Memory Management',
    ],
    QuizCategory.algorithms: [
      'Sorting Algorithms',
      'Search Algorithms',
      'Graph Algorithms',
      'Dynamic Programming',
      'Greedy Algorithms',
      'Tree Traversal',
    ],
    QuizCategory.dataStructures: [
      'Arrays and Lists',
      'Stacks and Queues',
      'Trees and Heaps',
      'Hash Tables',
      'Graphs',
      'Linked Lists',
    ],
    QuizCategory.frontend: [
      'HTML5 and Semantic Web',
      'CSS3 and Responsive Design',
      'JavaScript ES6+',
      'React/Vue/Angular',
      'DOM Manipulation',
      'Performance Optimization',
    ],
    QuizCategory.backend: [
      'RESTful APIs',
      'Database Design',
      'Server Architecture',
      'Authentication & Authorization',
      'Caching Strategies',
      'Microservices',
    ],
    QuizCategory.mobile: [
      'Cross-platform Development',
      'Native vs Hybrid',
      'State Management',
      'UI/UX Patterns',
      'Performance Optimization',
      'Platform APIs',
    ],
    QuizCategory.database: [
      'SQL Fundamentals',
      'Database Normalization',
      'Indexing Strategies',
      'ACID Properties',
      'NoSQL Databases',
      'Query Optimization',
    ],
    QuizCategory.networking: [
      'TCP/IP Protocol Suite',
      'HTTP/HTTPS',
      'Network Security',
      'Load Balancing',
      'CDN and Caching',
      'API Gateway',
    ],
    QuizCategory.security: [
      'Authentication Methods',
      'Encryption Techniques',
      'Common Vulnerabilities',
      'Secure Coding Practices',
      'Network Security',
      'Data Protection',
    ],
    QuizCategory.devops: [
      'CI/CD Pipelines',
      'Containerization',
      'Infrastructure as Code',
      'Monitoring and Logging',
      'Cloud Platforms',
      'Version Control',
    ],
    QuizCategory.systemDesign: [
      'Scalability Patterns',
      'Load Balancing',
      'Database Sharding',
      'Caching Strategies',
      'Microservices Architecture',
      'System Reliability',
    ],
    QuizCategory.general: [
      'Software Development Lifecycle',
      'Agile Methodologies',
      'Code Quality',
      'Testing Strategies',
      'Documentation',
      'Team Collaboration',
    ],
  };

  static const Map<QuizCategory, Map<QuizDifficulty, List<Map<String, dynamic>>>> _questionTemplates = {
    QuizCategory.programming: {
      QuizDifficulty.easy: [
        {
          'question': 'What is the correct way to declare a variable in {language}?',
          'options': ['var x = 5;', 'variable x = 5;', 'x := 5;', 'declare x = 5;'],
          'correctAnswer': 'var x = 5;',
          'explanation': 'In most programming languages, variables are declared using keywords like var, let, or direct type declaration.',
          'type': QuestionType.multipleChoice,
        },
        {
          'question': 'A for loop is used to repeat code a specific number of times.',
          'options': ['True', 'False'],
          'correctAnswer': 'True',
          'explanation': 'For loops are designed to iterate a predetermined number of times.',
          'type': QuestionType.trueFalse,
        },
      ],
      QuizDifficulty.medium: [
        {
          'question': 'What is the time complexity of accessing an element in an array by index?',
          'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n²)'],
          'correctAnswer': 'O(1)',
          'explanation': 'Array access by index is constant time as it uses direct memory addressing.',
          'type': QuestionType.multipleChoice,
        },
        {
          'question': 'Which design pattern ensures a class has only one instance?',
          'options': ['Singleton', 'Factory', 'Observer', 'Strategy'],
          'correctAnswer': 'Singleton',
          'explanation': 'The Singleton pattern restricts instantiation of a class to one object.',
          'type': QuestionType.multipleChoice,
        },
      ],
      QuizDifficulty.hard: [
        {
          'question': 'In functional programming, what is a higher-order function?',
          'options': [
            'A function that returns another function',
            'A function that takes another function as parameter',
            'Both A and B',
            'A function with complex logic'
          ],
          'correctAnswer': 'Both A and B',
          'explanation': 'Higher-order functions can both take functions as parameters and return functions.',
          'type': QuestionType.multipleChoice,
        },
      ],
    },
    QuizCategory.algorithms: {
      QuizDifficulty.easy: [
        {
          'question': 'What is the purpose of a sorting algorithm?',
          'options': ['To search data', 'To arrange data in order', 'To delete data', 'To copy data'],
          'correctAnswer': 'To arrange data in order',
          'explanation': 'Sorting algorithms arrange elements in a specific order (ascending or descending).',
          'type': QuestionType.multipleChoice,
        },
      ],
      QuizDifficulty.medium: [
        {
          'question': 'What is the average time complexity of Quick Sort?',
          'options': ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
          'correctAnswer': 'O(n log n)',
          'explanation': 'Quick Sort has an average case time complexity of O(n log n).',
          'type': QuestionType.multipleChoice,
        },
      ],
      QuizDifficulty.hard: [
        {
          'question': 'Which algorithm is used to find the shortest path in a weighted graph?',
          'options': ['BFS', 'DFS', 'Dijkstra', 'Binary Search'],
          'correctAnswer': 'Dijkstra',
          'explanation': 'Dijkstra\'s algorithm finds the shortest path between nodes in a weighted graph.',
          'type': QuestionType.multipleChoice,
        },
      ],
    },
    // Add more categories as needed...
  };

  /// Generates an AI-powered quiz based on the specified parameters
  static Future<Quiz> generateQuiz({
    required String title,
    required QuizCategory category,
    required QuizDifficulty difficulty,
    required int questionCount,
    required int duration,
    String? specificTopic,
    String? focusArea,
  }) async {
    try {
      // Simulate AI processing time
      await Future.delayed(const Duration(seconds: 2));

      // Generate questions based on the category and difficulty
      final questions = await _generateQuestions(
        category: category,
        difficulty: difficulty,
        count: questionCount,
        specificTopic: specificTopic,
        focusArea: focusArea,
      );

      // Create and return the quiz
      return Quiz(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        title: title.isEmpty ? _generateQuizTitle(category, difficulty) : title,
        description: _generateQuizDescription(category, difficulty, questionCount),
        difficulty: difficulty,
        category: category,
        duration: duration,
        totalQuestions: questionCount,
        questions: questions,
        createdAt: DateTime.now(),
        createdBy: 'AI Generator',
        isActive: true,
        passingScore: _calculatePassingScore(difficulty),
      );
    } catch (e) {
      debugPrint('Error generating AI quiz: $e');
      rethrow;
    }
  }

  static Future<List<Question>> _generateQuestions({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    required int count,
    String? specificTopic,
    String? focusArea,
  }) async {
    final questions = <Question>[];
    final templates = _questionTemplates[category]?[difficulty] ?? [];
    
    if (templates.isEmpty) {
      // Fallback to general programming questions
      return _generateFallbackQuestions(category, difficulty, count);
    }

    for (int i = 0; i < count; i++) {
      final template = templates[i % templates.length];
      final question = Question(
        id: 'ai_q_${DateTime.now().millisecondsSinceEpoch}_$i',
        question: _customizeQuestion(template['question'], category, specificTopic),
        type: template['type'] as QuestionType,
        options: List<String>.from(template['options']),
        correctAnswer: template['correctAnswer'],
        explanation: template['explanation'],
        points: _getPointsForDifficulty(difficulty),
      );
      questions.add(question);
    }

    return questions;
  }

  static List<Question> _generateFallbackQuestions(
    QuizCategory category,
    QuizDifficulty difficulty,
    int count,
  ) {
    final questions = <Question>[];
    
    for (int i = 0; i < count; i++) {
      questions.add(Question(
        id: 'ai_fallback_${DateTime.now().millisecondsSinceEpoch}_$i',
        question: 'What is a key concept in ${category.displayName}?',
        type: QuestionType.multipleChoice,
        options: [
          'Concept A',
          'Concept B', 
          'Concept C',
          'All of the above'
        ],
        correctAnswer: 'All of the above',
        explanation: 'This is a dynamically generated question about ${category.displayName}.',
        points: _getPointsForDifficulty(difficulty),
      ));
    }
    
    return questions;
  }

  static String _customizeQuestion(String template, QuizCategory category, String? specificTopic) {
    String customized = template;
    
    // Replace placeholders based on category
    switch (category) {
      case QuizCategory.programming:
        customized = customized.replaceAll('{language}', 'JavaScript');
        break;
      case QuizCategory.mobile:
        customized = customized.replaceAll('{platform}', 'Flutter');
        break;
      default:
        break;
    }
    
    // Add specific topic if provided
    if (specificTopic != null && specificTopic.isNotEmpty) {
      customized = customized.replaceAll('{topic}', specificTopic);
    }
    
    return customized;
  }

  static String _generateQuizTitle(QuizCategory category, QuizDifficulty difficulty) {
    final topics = _categoryTopics[category] ?? ['General Concepts'];
    final randomTopic = topics[DateTime.now().millisecond % topics.length];
    return '${difficulty.displayName} ${category.displayName}: $randomTopic';
  }

  static String _generateQuizDescription(QuizCategory category, QuizDifficulty difficulty, int questionCount) {
    return 'AI-generated ${difficulty.displayName.toLowerCase()} level quiz on ${category.displayName} '
        'with $questionCount questions. Test your knowledge and improve your skills!';
  }

  static double _calculatePassingScore(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return 60.0;
      case QuizDifficulty.medium:
        return 70.0;
      case QuizDifficulty.hard:
        return 75.0;
      case QuizDifficulty.expert:
        return 80.0;
    }
  }

  static int _getPointsForDifficulty(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return 1;
      case QuizDifficulty.medium:
        return 2;
      case QuizDifficulty.hard:
        return 3;
      case QuizDifficulty.expert:
        return 5;
    }
  }

  /// Get suggested topics for a category
  static List<String> getTopicsForCategory(QuizCategory category) {
    return _categoryTopics[category] ?? [];
  }

  /// Validate quiz generation parameters
  static bool validateParameters({
    required QuizCategory category,
    required QuizDifficulty difficulty,
    required int questionCount,
    required int duration,
  }) {
    return questionCount > 0 && 
           questionCount <= 50 && 
           duration >= 5 && 
           duration <= 180;
  }
}
