import 'package:flutter/foundation.dart';
import '../models/quiz.dart';
import '../models/quiz_attempt.dart';

class QuizProvider extends ChangeNotifier {
  List<Quiz> _quizzes = [];
  Quiz? _currentQuiz;
  QuizAttempt? _currentAttempt;
  List<QuestionAttempt> _currentAnswers = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  int _timeRemaining = 0; // in seconds
  bool _isQuizActive = false;
  bool _isInitialized = false;

  // Getters
  List<Quiz> get quizzes => _quizzes;
  Quiz? get currentQuiz => _currentQuiz;
  QuizAttempt? get currentAttempt => _currentAttempt;
  List<QuestionAttempt> get currentAnswers => _currentAnswers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get timeRemaining => _timeRemaining;
  bool get isQuizActive => _isQuizActive;
  bool get isInitialized => _isInitialized;

  Question? get currentQuestion {
    if (_currentQuiz == null || 
        _currentQuestionIndex >= _currentQuiz!.questions.length) {
      return null;
    }
    return _currentQuiz!.questions[_currentQuestionIndex];
  }

  double get progress {
    if (_currentQuiz == null || _currentQuiz!.questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _currentQuiz!.questions.length;
  }

  // Demo data
  final List<Quiz> _demoQuizzes = [
    Quiz(
      id: '1',
      title: 'Flutter Fundamentals',
      description: 'Test your knowledge of Flutter basics including widgets, state management, and navigation.',
      difficulty: QuizDifficulty.medium,
      category: QuizCategory.mobile,
      duration: 30,
      totalQuestions: 10,
      questions: [
        Question(
          id: '1',
          question: 'What is the main building block of Flutter UI?',
          type: QuestionType.multipleChoice,
          options: ['Widgets', 'Components', 'Elements', 'Views'],
          correctAnswer: 'Widgets',
          explanation: 'In Flutter, everything is a widget. Widgets are the main building blocks used to create the user interface.',
          points: 1,
        ),
        Question(
          id: '2',
          question: 'Which widget is used for creating scrollable lists in Flutter?',
          type: QuestionType.multipleChoice,
          options: ['ListView', 'ScrollView', 'ListWidget', 'VerticalList'],
          correctAnswer: 'ListView',
          explanation: 'ListView is the primary widget for creating scrollable lists in Flutter.',
          points: 1,
        ),
        Question(
          id: '3',
          question: 'StatefulWidget can change its state during runtime.',
          type: QuestionType.trueFalse,
          options: ['True', 'False'],
          correctAnswer: 'True',
          explanation: 'StatefulWidget can maintain and change its state during the widget\'s lifetime.',
          points: 1,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      createdBy: 'trainer-1',
      passingScore: 70.0,
    ),
    Quiz(
      id: '2',
      title: 'JavaScript ES6+ Features',
      description: 'Modern JavaScript concepts including arrow functions, async/await, destructuring, and modules.',
      difficulty: QuizDifficulty.hard,
      category: QuizCategory.programming,
      duration: 45,
      totalQuestions: 15,
      questions: [
        Question(
          id: '4',
          question: 'What does the spread operator (...) do in JavaScript?',
          type: QuestionType.multipleChoice,
          options: [
            'Combines arrays',
            'Spreads array elements',
            'Creates a copy of an array',
            'All of the above'
          ],
          correctAnswer: 'All of the above',
          explanation: 'The spread operator can be used to spread array elements, combine arrays, and create shallow copies.',
          points: 2,
        ),
        Question(
          id: '5',
          question: 'Which method is used to handle promises in JavaScript?',
          type: QuestionType.multipleChoice,
          options: ['.then()', '.catch()', '.finally()', 'All of the above'],
          correctAnswer: 'All of the above',
          explanation: 'All these methods are used to handle different aspects of promises.',
          points: 2,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      createdBy: 'trainer-1',
      passingScore: 75.0,
    ),
    Quiz(
      id: '3',
      title: 'Data Structures & Algorithms',
      description: 'Fundamental data structures and algorithmic thinking for technical interviews.',
      difficulty: QuizDifficulty.expert,
      category: QuizCategory.algorithms,
      duration: 60,
      totalQuestions: 20,
      questions: [
        Question(
          id: '6',
          question: 'What is the time complexity of binary search?',
          type: QuestionType.multipleChoice,
          options: ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
          correctAnswer: 'O(log n)',
          explanation: 'Binary search eliminates half of the remaining elements in each step, resulting in O(log n) time complexity.',
          points: 3,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      createdBy: 'trainer-2',
      passingScore: 80.0,
    ),
  ];

  QuizProvider() {
    _loadQuizzes();
  }

  void _loadQuizzes() {
    _quizzes = List.from(_demoQuizzes);
    // Don't call notifyListeners() during initialization
  }

  Future<void> fetchQuizzes() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      _quizzes = List.from(_demoQuizzes);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load quizzes');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startQuiz(String quizId) async {
    _setLoading(true);
    _clearError();

    try {
      final quiz = _quizzes.firstWhere((q) => q.id == quizId);
      _currentQuiz = quiz;
      _currentQuestionIndex = 0;
      _currentAnswers = [];
      _timeRemaining = quiz.duration * 60; // Convert minutes to seconds
      _isQuizActive = true;
      
      // Create new attempt
      _currentAttempt = QuizAttempt(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        quizId: quizId,
        userId: 'current-user-id', // This would come from AuthProvider
        startedAt: DateTime.now(),
        answers: [],
        totalScore: 0,
        maxScore: quiz.questions.fold(0, (sum, q) => sum + q.points),
        percentage: 0.0,
        isPassed: false,
        status: AttemptStatus.inProgress,
        timeSpent: 0,
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to start quiz');
    } finally {
      _setLoading(false);
    }
  }

  void answerQuestion(dynamic answer) {
    if (_currentQuiz == null || currentQuestion == null) return;

    final question = currentQuestion!;
    final isCorrect = _checkAnswer(question, answer);
    final pointsEarned = isCorrect ? question.points : 0;

    final questionAttempt = QuestionAttempt(
      questionId: question.id,
      userAnswer: answer,
      correctAnswer: question.correctAnswer,
      isCorrect: isCorrect,
      pointsEarned: pointsEarned,
      maxPoints: question.points,
      timeSpent: 30, // Mock time spent
    );

    // Update or add answer
    final existingIndex = _currentAnswers.indexWhere(
      (a) => a.questionId == question.id,
    );

    if (existingIndex != -1) {
      _currentAnswers[existingIndex] = questionAttempt;
    } else {
      _currentAnswers.add(questionAttempt);
    }

    notifyListeners();
  }

  bool _checkAnswer(Question question, dynamic userAnswer) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
      case QuestionType.textInput:
        return question.correctAnswer.toString().toLowerCase() == 
               userAnswer.toString().toLowerCase();
      default:
        return false;
    }
  }

  void nextQuestion() {
    if (_currentQuiz != null && 
        _currentQuestionIndex < _currentQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (_currentQuiz != null && 
        index >= 0 && 
        index < _currentQuiz!.questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  Future<QuizAttempt?> submitQuiz() async {
    if (_currentQuiz == null || _currentAttempt == null) return null;

    _setLoading(true);

    try {
      // Calculate final scores
      final totalScore = _currentAnswers.fold(0, (sum, a) => sum + a.pointsEarned);
      final maxScore = _currentQuiz!.questions.fold(0, (sum, q) => sum + q.points);
      final percentage = maxScore > 0 ? (totalScore / maxScore) * 100 : 0.0;
      final isPassed = percentage >= (_currentQuiz!.passingScore ?? 70.0);

      final completedAttempt = QuizAttempt(
        id: _currentAttempt!.id,
        quizId: _currentAttempt!.quizId,
        userId: _currentAttempt!.userId,
        startedAt: _currentAttempt!.startedAt,
        completedAt: DateTime.now(),
        answers: List.from(_currentAnswers),
        totalScore: totalScore,
        maxScore: maxScore,
        percentage: percentage,
        isPassed: isPassed,
        status: AttemptStatus.completed,
        timeSpent: (_currentQuiz!.duration * 60) - _timeRemaining,
      );

      _currentAttempt = completedAttempt;
      _isQuizActive = false;
      notifyListeners();

      return completedAttempt;
    } catch (e) {
      _setError('Failed to submit quiz');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void resetQuiz() {
    _currentQuiz = null;
    _currentAttempt = null;
    _currentAnswers = [];
    _currentQuestionIndex = 0;
    _timeRemaining = 0;
    _isQuizActive = false;
    notifyListeners();
  }

  void updateTimer() {
    if (_isQuizActive && _timeRemaining > 0) {
      _timeRemaining--;
      if (_timeRemaining == 0) {
        // Auto-submit when time expires
        submitQuiz();
      }
      notifyListeners();
    }
  }

  String get formattedTimeRemaining {
    final minutes = _timeRemaining ~/ 60;
    final seconds = _timeRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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

  Future<void> addGeneratedQuiz(Quiz quiz) async {
    _quizzes.insert(0, quiz); // Add at beginning
    // Use Future.delayed to avoid calling notifyListeners during build
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
