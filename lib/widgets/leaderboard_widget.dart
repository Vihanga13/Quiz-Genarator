import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/app_theme.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock leaderboard data
    final leaderboardData = [
      LeaderboardEntry(
        rank: 1,
        name: 'Sarah Chen',
        score: 95.5,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 2,
        name: 'John Doe',
        score: 87.3,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=John',
        isCurrentUser: true,
      ),
      LeaderboardEntry(
        rank: 3,
        name: 'Mike Johnson',
        score: 82.1,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Mike',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 4,
        name: 'Lisa Wang',
        score: 79.8,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Lisa',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        rank: 5,
        name: 'Alex Rodriguez',
        score: 76.4,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex',
        isCurrentUser: false,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.graphiteBlack.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.trophy,
                  color: AppColors.cyberYellow,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Top Performers',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cyberYellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Live',
                    style: TextStyle(
                      color: AppColors.cyberYellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leaderboardData.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppColors.lightGray,
            ),
            itemBuilder: (context, index) {
              final entry = leaderboardData[index];
              return _buildLeaderboardItem(entry);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: entry.isCurrentUser 
            ? AppColors.cyberYellow.withOpacity(0.1)
            : AppColors.white,
        borderRadius: entry.rank == 5 
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : null,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(entry.rank),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: entry.rank <= 3
                  ? Icon(
                      _getRankIcon(entry.rank),
                      color: AppColors.white,
                      size: 16,
                    )
                  : Text(
                      entry.rank.toString(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.lightGray,
            child: ClipOval(
              child: Icon(
                FontAwesomeIcons.user,
                color: AppColors.mediumGray,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w600,
                        color: entry.isCurrentUser 
                            ? AppColors.deepBlue 
                            : AppColors.graphiteBlack,
                      ),
                    ),
                    if (entry.isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.deepBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Score: ${entry.score.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getScoreColor(entry.score).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getScoreColor(entry.score),
                width: 1,
              ),
            ),
            child: Text(
              '${entry.score.toStringAsFixed(0)}%',
              style: TextStyle(
                color: _getScoreColor(entry.score),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.mediumGray;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return FontAwesomeIcons.trophy;
      case 2:
        return FontAwesomeIcons.medal;
      case 3:
        return FontAwesomeIcons.award;
      default:
        return FontAwesomeIcons.user;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 90) {
      return AppColors.success;
    } else if (score >= 80) {
      return AppColors.warning;
    } else if (score >= 70) {
      return AppColors.info;
    } else {
      return AppColors.error;
    }
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final double score;
  final String avatar;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
    this.isCurrentUser = false,
  });
}
