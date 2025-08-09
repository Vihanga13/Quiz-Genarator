import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz.dart';
import '../config/app_theme.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final Function(dynamic) onAnswerSelected;
  final dynamic selectedAnswer;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.onAnswerSelected,
    this.selectedAnswer,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  dynamic _currentAnswer;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAnswer = widget.selectedAnswer;
    if (widget.question.type == QuestionType.textInput && _currentAnswer != null) {
      _textController.text = _currentAnswer.toString();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(),
          const SizedBox(height: 16),
          _buildQuestionText(),
          if (widget.question.codeSnippet != null) ...[
            const SizedBox(height: 16),
            _buildCodeSnippet(),
          ],
          const SizedBox(height: 24),
          _buildAnswerSection(),
          const SizedBox(height: 24),
          _buildQuestionInfo(),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mediumGray.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Q${widget.questionNumber}',
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getQuestionTypeLabel(widget.question.type),
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.question.points} ${widget.question.points == 1 ? 'point' : 'points'}',
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14,
                    color: AppColors.deepBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (_currentAnswer != null)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                FontAwesomeIcons.check,
                color: AppColors.white,
                size: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mediumGray.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.question.question,
        style: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.graphiteBlack,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCodeSnippet() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.graphiteBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cyberYellow.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.code,
                color: AppColors.cyberYellow,
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Code Snippet',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  color: AppColors.cyberYellow,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.question.codeSnippet!,
            style: const TextStyle(
              fontFamily: AppFonts.jetBrainsMono,
              color: AppColors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection() {
    switch (widget.question.type) {
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceOptions();
      case QuestionType.trueFalse:
        return _buildTrueFalseOptions();
      case QuestionType.textInput:
        return _buildTextInput();
      case QuestionType.codeReview:
        return _buildMultipleChoiceOptions(); // Same as multiple choice for now
      case QuestionType.logicalReasoning:
        return _buildMultipleChoiceOptions(); // Same as multiple choice for now
    }
  }

  Widget _buildMultipleChoiceOptions() {
    return Column(
      children: widget.question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _currentAnswer == option;
        
        return GestureDetector(
          onTap: () => _selectAnswer(option),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.deepBlue.withOpacity(0.1)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? AppColors.deepBlue 
                    : AppColors.mediumGray.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.deepBlue : AppColors.white,
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.deepBlue 
                          : AppColors.mediumGray,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.deepBlue 
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        color: isSelected 
                            ? AppColors.white 
                            : AppColors.graphiteBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16,
                      color: isSelected 
                          ? AppColors.deepBlue 
                          : AppColors.graphiteBlack,
                      fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalseOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildTrueFalseOption('True', true),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTrueFalseOption('False', false),
        ),
      ],
    );
  }

  Widget _buildTrueFalseOption(String label, bool value) {
    final isSelected = _currentAnswer?.toString() == value.toString();
    
    return GestureDetector(
      onTap: () => _selectAnswer(value.toString()),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.deepBlue.withOpacity(0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.deepBlue 
                : AppColors.mediumGray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.deepBlue : AppColors.lightGray,
              ),
              child: Icon(
                value ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
                color: isSelected ? AppColors.white : AppColors.mediumGray,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? AppColors.deepBlue 
                    : AppColors.graphiteBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mediumGray.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _textController,
        onChanged: (value) => _selectAnswer(value),
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Type your answer here...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintStyle: TextStyle(
            color: AppColors.mediumGray,
            fontFamily: AppFonts.poppins,
          ),
        ),
        style: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16,
          color: AppColors.graphiteBlack,
        ),
      ),
    );
  }

  Widget _buildQuestionInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.lightbulb,
            color: AppColors.info,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Select your answer and click Next to continue.',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 12,
                color: AppColors.info,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(dynamic answer) {
    setState(() {
      _currentAnswer = answer;
    });
    widget.onAnswerSelected(answer);
  }

  String _getQuestionTypeLabel(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.textInput:
        return 'Text Input';
      case QuestionType.codeReview:
        return 'Code Review';
      case QuestionType.logicalReasoning:
        return 'Logical Reasoning';
    }
  }
}
