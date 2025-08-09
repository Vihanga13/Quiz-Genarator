import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';
import '../config/app_theme.dart';
import '../widgets/question_widget.dart';
import '../widgets/quiz_timer.dart';
import '../widgets/progress_indicator_widget.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String? quizId;
  final String? quizTitle;

  const QuizScreen({
    super.key,
    this.quizId,
    this.quizTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Defer quiz initialization to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQuiz();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeQuiz() async {
    if (!mounted) return;
    
    if (widget.quizId != null) {
      final quizProvider = context.read<QuizProvider>();
      await quizProvider.startQuiz(widget.quizId!);
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final quiz = quizProvider.currentQuiz;
        
        if (quiz == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quiz Not Found'),
            ),
            body: const Center(
              child: Text('Quiz not found or failed to load.'),
            ),
          );
        }

        return WillPopScope(
          onWillPop: () => _showExitConfirmation(),
          child: Scaffold(
            appBar: _buildAppBar(quiz, quizProvider),
            body: Column(
              children: [
                _buildProgressSection(quizProvider),
                Expanded(
                  child: _buildQuizContent(quiz, quizProvider),
                ),
                _buildNavigationButtons(quizProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(Quiz quiz, QuizProvider quizProvider) {
    return AppBar(
      title: Text(
        quiz.title,
        style: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.deepBlue,
      foregroundColor: AppColors.white,
      elevation: 0,
      actions: [
        QuizTimer(
          timeRemaining: quizProvider.timeRemaining,
          isActive: quizProvider.isQuizActive,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'pause':
                _pauseQuiz();
                break;
              case 'exit':
                _showExitConfirmation();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'pause',
              child: Row(
                children: [
                  Icon(Icons.pause, color: AppColors.warning),
                  SizedBox(width: 8),
                  Text('Pause Quiz'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'exit',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Exit Quiz'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(QuizProvider quizProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          ProgressIndicatorWidget(
            progress: quizProvider.progress,
            currentQuestion: quizProvider.currentQuestionIndex + 1,
            totalQuestions: quizProvider.currentQuiz?.totalQuestions ?? 0,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${quizProvider.currentQuestionIndex + 1} of ${quizProvider.currentQuiz?.totalQuestions ?? 0}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${quizProvider.currentAnswers.length} answered',
                style: const TextStyle(
                  color: AppColors.cyberYellow,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent(Quiz quiz, QuizProvider quizProvider) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        quizProvider.goToQuestion(index);
      },
      itemCount: quiz.questions.length,
      itemBuilder: (context, index) {
        final question = quiz.questions[index];
        return QuestionWidget(
          question: question,
          questionNumber: index + 1,
          onAnswerSelected: (answer) {
            quizProvider.answerQuestion(answer);
          },
          selectedAnswer: _getSelectedAnswer(question.id, quizProvider),
        );
      },
    );
  }

  Widget _buildNavigationButtons(QuizProvider quizProvider) {
    final isLastQuestion = quizProvider.currentQuestionIndex == 
        (quizProvider.currentQuiz?.questions.length ?? 0) - 1;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.graphiteBlack.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (quizProvider.currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  quizProvider.previousQuestion();
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(FontAwesomeIcons.chevronLeft, size: 16),
                label: const Text('Previous'),
              ),
            ),
          if (quizProvider.currentQuestionIndex > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _handleNextOrSubmit(quizProvider, isLastQuestion),
              icon: Icon(
                isLastQuestion 
                    ? FontAwesomeIcons.check 
                    : FontAwesomeIcons.chevronRight,
                size: 16,
              ),
              label: Text(isLastQuestion ? 'Submit Quiz' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastQuestion 
                    ? AppColors.success 
                    : AppColors.deepBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic _getSelectedAnswer(String questionId, QuizProvider quizProvider) {
    final attempts = quizProvider.currentAnswers;
    final attemptIndex = attempts.indexWhere((a) => a.questionId == questionId);
    
    if (attemptIndex != -1) {
      return attempts[attemptIndex].userAnswer;
    }
    
    // Return null if no answer found (question not answered yet)
    return null;
  }

  void _handleNextOrSubmit(QuizProvider quizProvider, bool isLastQuestion) {
    if (isLastQuestion) {
      _showSubmitConfirmation(quizProvider);
    } else {
      quizProvider.nextQuestion();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSubmitConfirmation(QuizProvider quizProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to submit your quiz?'),
            const SizedBox(height: 16),
            Text(
              'Answered: ${quizProvider.currentAnswers.length}/${quizProvider.currentQuiz?.totalQuestions ?? 0}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (quizProvider.currentAnswers.length < 
                (quizProvider.currentQuiz?.totalQuestions ?? 0))
              const Text(
                'Unanswered questions will be marked as incorrect.',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _submitQuiz(quizProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuiz(QuizProvider quizProvider) async {
    Navigator.of(context).pop(); // Close dialog
    
    final result = await quizProvider.submitQuiz();
    
    if (result != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(attempt: result),
        ),
      );
    }
  }

  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      context.read<QuizProvider>().resetQuiz();
      Navigator.of(context).pop();
    }
    
    return result ?? false;
  }

  void _pauseQuiz() {
    // TODO: Implement pause functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pause functionality coming soon!'),
      ),
    );
  }
}
