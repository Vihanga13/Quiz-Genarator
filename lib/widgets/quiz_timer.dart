import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/app_theme.dart';

class QuizTimer extends StatelessWidget {
  final int timeRemaining;
  final bool isActive;

  const QuizTimer({
    super.key,
    required this.timeRemaining,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = timeRemaining ~/ 60;
    final seconds = timeRemaining % 60;
    final timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    // Determine color based on remaining time
    Color timeColor;
    if (timeRemaining > 300) { // More than 5 minutes
      timeColor = AppColors.white;
    } else if (timeRemaining > 60) { // More than 1 minute
      timeColor = AppColors.cyberYellow;
    } else { // Less than 1 minute
      timeColor = AppColors.error;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: timeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: timeColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.clock,
            size: 14,
            color: timeColor,
          ),
          const SizedBox(width: 6),
          Text(
            timeText,
            style: TextStyle(
              fontFamily: AppFonts.jetBrainsMono,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: timeColor,
            ),
          ),
        ],
      ),
    );
  }
}
