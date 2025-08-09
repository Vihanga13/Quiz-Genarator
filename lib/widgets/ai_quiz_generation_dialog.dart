import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz.dart';
import '../config/app_theme.dart';
import '../services/ai_quiz_generation_service.dart';
import '../providers/quiz_provider.dart';
import '../screens/quiz_screen.dart';

class AIQuizGenerationDialog extends StatefulWidget {
  const AIQuizGenerationDialog({super.key});

  @override
  State<AIQuizGenerationDialog> createState() => _AIQuizGenerationDialogState();
}

class _AIQuizGenerationDialogState extends State<AIQuizGenerationDialog> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _topicController = TextEditingController();
  
  QuizCategory _selectedCategory = QuizCategory.programming;
  QuizDifficulty _selectedDifficulty = QuizDifficulty.medium;
  int _questionCount = 10;
  int _duration = 30; // in minutes
  bool _isGenerating = false;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxHeight: 700),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppColors.white, Color(0xFFF8F9FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child: _isGenerating ? _buildGeneratingView() : _buildForm(),
                    ),
                  ),
                  if (!_isGenerating) ...[
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cyberYellow.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            FontAwesomeIcons.robot,
            color: AppColors.deepBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Quiz Generator',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.graphiteBlack,
                ),
              ),
              Text(
                'Create personalized quizzes with AI',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: AppColors.mediumGray),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuizTitleField(),
          const SizedBox(height: 20),
          _buildCategorySelection(),
          const SizedBox(height: 20),
          _buildDifficultySelection(),
          const SizedBox(height: 20),
          _buildQuestionCountSlider(),
          const SizedBox(height: 20),
          _buildDurationSlider(),
          const SizedBox(height: 20),
          _buildTopicField(),
        ],
      ),
    );
  }

  Widget _buildQuizTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Title (Optional)',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'AI will generate a title if left empty',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.deepBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: QuizCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.deepBlue : AppColors.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.deepBlue : AppColors.lightGray,
                  ),
                ),
                child: Text(
                  category.displayName,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.graphiteBlack,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Difficulty Level',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: QuizDifficulty.values.map((difficulty) {
            final isSelected = _selectedDifficulty == difficulty;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDifficulty = difficulty),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? _getDifficultyColor(difficulty) : AppColors.lightGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? _getDifficultyColor(difficulty) : AppColors.lightGray,
                    ),
                  ),
                  child: Text(
                    difficulty.displayName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.graphiteBlack,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionCountSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Number of Questions',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.graphiteBlack,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cyberYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_questionCount',
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlue,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _questionCount.toDouble(),
          min: 5,
          max: 25,
          divisions: 20,
          activeColor: AppColors.deepBlue,
          onChanged: (value) => setState(() => _questionCount = value.round()),
        ),
      ],
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Duration (minutes)',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.graphiteBlack,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cyberYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_duration min',
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlue,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: _duration.toDouble(),
          min: 10,
          max: 120,
          divisions: 22,
          activeColor: AppColors.deepBlue,
          onChanged: (value) => setState(() => _duration = value.round()),
        ),
      ],
    );
  }

  Widget _buildTopicField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specific Topic (Optional)',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _topicController,
          decoration: InputDecoration(
            hintText: 'e.g., React Hooks, Binary Trees, etc.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.deepBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.cyberYellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              FontAwesomeIcons.robot,
              color: AppColors.deepBlue,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepBlue),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI is generating your quiz...',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.graphiteBlack,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This may take a few seconds',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.mediumGray,
              side: const BorderSide(color: AppColors.lightGray),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _generateQuiz,
            icon: const Icon(FontAwesomeIcons.wandMagicSparkles, size: 16),
            label: const Text('Generate Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
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
        return Colors.purple;
    }
  }

  Future<void> _generateQuiz() async {
    if (!AIQuizGenerationService.validateParameters(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      questionCount: _questionCount,
      duration: _duration,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid quiz parameters. Please check your inputs.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final quiz = await AIQuizGenerationService.generateQuiz(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        questionCount: _questionCount,
        duration: _duration,
        specificTopic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
      );

      // Add the generated quiz to the provider
      if (mounted) {
        // Use await to ensure proper async handling
        await context.read<QuizProvider>().addGeneratedQuiz(quiz);
        
        // Close dialog and start quiz
        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                quizId: quiz.id,
                quizTitle: quiz.title,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate quiz: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
