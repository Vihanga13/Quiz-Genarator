import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/certificate_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/';
  static const String quiz = '/quiz';
  static const String analytics = '/analytics';
  static const String certificate = '/certificate';
  static const String adminDashboard = '/admin-dashboard';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      quiz: (context) => const QuizScreen(),
      analytics: (context) => const AnalyticsScreen(),
      certificate: (context) => const CertificateScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case quiz:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => QuizScreen(
            quizId: args?['quizId'] as String?,
            quizTitle: args?['quizTitle'] as String?,
          ),
        );
      case analytics:
        return MaterialPageRoute(builder: (context) => const AnalyticsScreen());
      case certificate:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => CertificateScreen(
            certificateId: args?['certificateId'] as String?,
          ),
        );
      case adminDashboard:
        return MaterialPageRoute(builder: (context) => const AdminDashboardScreen());
      case profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
