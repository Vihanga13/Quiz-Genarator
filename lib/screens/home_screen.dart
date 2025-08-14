import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';
import '../config/app_theme.dart';
import '../config/app_routes.dart';
import '../widgets/quiz_card.dart';
import '../widgets/leaderboard_widget.dart';
import '../widgets/stats_overview.dart';
import '../widgets/ai_quiz_generation_dialog.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load quizzes when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchQuizzes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          if (user?.role.name == 'trainer' || user?.role.name == 'recruiter') {
            return FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/admin-dashboard'),
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: AppColors.graphiteBlack,
              child: const Icon(FontAwesomeIcons.gear),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedBottomNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _navigateToAnalytics();
      case 2:
        return _navigateToCertificates();
      case 3:
        return _navigateToProfile();
      default:
        return _buildHomeContent();
    }
  }

  Widget _navigateToAnalytics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/analytics').then((_) {
        setState(() => _selectedBottomNavIndex = 0);
      });
    });
    return _buildHomeContent();
  }

  Widget _navigateToCertificates() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/certificate').then((_) {
        setState(() => _selectedBottomNavIndex = 0);
      });
    });
    return _buildHomeContent();
  }

  Widget _navigateToProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/profile').then((_) {
        setState(() => _selectedBottomNavIndex = 0);
      });
    });
    return _buildHomeContent();
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildHeroSection(),
        _buildStatsOverview(),
        _buildQuizSection(),
        _buildLeaderboardSection(),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primaryBlack,
      flexibleSpace: FlexibleSpaceBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.currentUser;
            return Flexible(
              child: Text(
                'Welcome, ${user?.name ?? 'User'}!',
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            );
          },
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.white),
          onPressed: () {
            // TODO: Show notifications
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: AppColors.white),
          onSelected: (value) {
            switch (value) {
              case 'login':
                Navigator.pushNamed(context, AppRoutes.login);
                break;
              case 'profile':
                Navigator.pushNamed(context, '/profile');
                break;
              case 'logout':
                context.read<AuthProvider>().logout();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'login',
              child: Row(
                children: [
                  Icon(Icons.login, color: AppColors.primaryPurple),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Login',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, color: AppColors.primaryPurple),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Profile',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppColors.error),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Logout',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryBlack, AppColors.primaryPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI-Powered Smart Assessments for Tech Professionals',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Generate personalized quizzes with AI or choose from curated content to evaluate coding skills, logical reasoning, and technical knowledge.',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                color: AppColors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAIQuizGenerationDialog(),
                    icon: const Icon(FontAwesomeIcons.robot, size: 16),
                    label: const Text('AI Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showQuizSelectionDialog(),
                    icon: const Icon(FontAwesomeIcons.list, size: 16),
                    label: const Text('Browse Quizzes'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: const BorderSide(color: AppColors.white),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: StatsOverview(),
      ),
    );
  }

  Widget _buildQuizSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Available Quizzes',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.graphiteBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => _showAIQuizGenerationDialog(),
                          icon: const Icon(FontAwesomeIcons.robot, size: 14),
                          label: const Text('Generate AI Quiz'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryPurple,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to all quizzes
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                if (quizProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (quizProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          'Error: ${quizProvider.errorMessage}',
                          style: const TextStyle(color: AppColors.error),
                        ),
                        ElevatedButton(
                          onPressed: () => quizProvider.fetchQuizzes(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final quizzes = quizProvider.quizzes.take(3).toList();
                
                if (quizzes.isEmpty && !quizProvider.isLoading) {
                  return const Center(
                    child: Text(
                      'No quizzes available',
                      style: TextStyle(
                        color: AppColors.mediumGray,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: quizzes.map((quiz) => QuizCard(
                    quiz: quiz,
                    onTap: () => _startQuiz(quiz),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Leaderboard',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.graphiteBlack,
              ),
            ),
            const SizedBox(height: 16),
            const LeaderboardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNavIndex,
      onTap: (index) => setState(() => _selectedBottomNavIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryPurple,
      unselectedItemColor: AppColors.mediumGray,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.chartLine),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.award),
          label: 'Certificates',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Profile',
        ),
      ],
    );
  }

  void _showAIQuizGenerationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AIQuizGenerationDialog(),
    );
  }

  void _showQuizSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select a Quiz'),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: quizProvider.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizProvider.quizzes[index];
                  return ListTile(
                    title: Text(quiz.title),
                    subtitle: Text(quiz.description),
                    trailing: Chip(
                      label: Text(quiz.difficulty.displayName),
                      backgroundColor: _getDifficultyColor(quiz.difficulty),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _startQuiz(quiz);
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
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

  void _startQuiz(Quiz quiz) {
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
