import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.deepBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement notifications
            },
            icon: const Icon(FontAwesomeIcons.bell),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildQuizManagement();
      case 2:
        return _buildUserManagement();
      case 3:
        return _buildReports();
      default:
        return _buildOverview();
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.deepBlue,
      unselectedItemColor: AppColors.mediumGray,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.chartLine),
          label: 'Overview',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.clipboard),
          label: 'Quizzes',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.users),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.fileLines),
          label: 'Reports',
        ),
      ],
    );
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Statistics',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(
              icon: FontAwesomeIcons.users,
              title: 'Total Users',
              value: '1,247',
              color: AppColors.deepBlue,
              trend: '+12%',
            ),
            _buildStatCard(
              icon: FontAwesomeIcons.clipboard,
              title: 'Active Quizzes',
              value: '89',
              color: AppColors.success,
              trend: '+5%',
            ),
            _buildStatCard(
              icon: FontAwesomeIcons.play,
              title: 'Quiz Attempts',
              value: '3,456',
              color: AppColors.warning,
              trend: '+18%',
            ),
            _buildStatCard(
              icon: FontAwesomeIcons.award,
              title: 'Certificates',
              value: '892',
              color: AppColors.cyberYellow,
              trend: '+8%',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: FontAwesomeIcons.plus,
                title: 'Create Quiz',
                subtitle: 'Add new quiz',
                color: AppColors.deepBlue,
                onTap: () => _createQuiz(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: FontAwesomeIcons.userPlus,
                title: 'Invite Users',
                subtitle: 'Send invitations',
                color: AppColors.success,
                onTap: () => _inviteUsers(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: FontAwesomeIcons.chartBar,
                title: 'View Reports',
                subtitle: 'Analytics & insights',
                color: AppColors.warning,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: FontAwesomeIcons.gear,
                title: 'Settings',
                subtitle: 'Configure platform',
                color: AppColors.mediumGray,
                onTap: () => _openSettings(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.graphiteBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.graphiteBlack.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'New user registration: john.doe@example.com',
                '5 minutes ago',
                FontAwesomeIcons.userPlus,
                AppColors.success,
              ),
              const Divider(height: 1),
              _buildActivityItem(
                'Quiz "React Fundamentals" completed by 15 users',
                '1 hour ago',
                FontAwesomeIcons.clipboardCheck,
                AppColors.info,
              ),
              const Divider(height: 1),
              _buildActivityItem(
                'New quiz "Python Basics" created',
                '3 hours ago',
                FontAwesomeIcons.plus,
                AppColors.deepBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14,
                    color: AppColors.graphiteBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizManagement() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.clipboard,
            size: 64,
            color: AppColors.mediumGray,
          ),
          SizedBox(height: 16),
          Text(
            'Quiz Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.graphiteBlack,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create, edit, and manage quizzes',
            style: TextStyle(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserManagement() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.users,
            size: 64,
            color: AppColors.mediumGray,
          ),
          SizedBox(height: 16),
          Text(
            'User Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.graphiteBlack,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage users and permissions',
            style: TextStyle(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReports() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.fileLines,
            size: 64,
            color: AppColors.mediumGray,
          ),
          SizedBox(height: 16),
          Text(
            'Reports & Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.graphiteBlack,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'View detailed reports and analytics',
            style: TextStyle(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  void _createQuiz() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz creation feature coming soon!'),
      ),
    );
  }

  void _inviteUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User invitation feature coming soon!'),
      ),
    );
  }

  void _openSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings feature coming soon!'),
      ),
    );
  }
}
