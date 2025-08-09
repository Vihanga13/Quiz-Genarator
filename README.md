# TheTechnoQuiz Flutter Mobile App

## Project Overview

A comprehensive Flutter mobile application for **TheTechnoQuiz.com** - an AI-powered quiz and assessment platform designed for tech companies, HR teams, coding bootcamps, and EdTech platforms.

## Features

### 🎯 Core Features
- **Cross-platform support** (iOS & Android)
- **Role-based access control** (Candidate, Recruiter, Trainer)
- **Interactive quiz engine** with multiple question types
- **Real-time performance analytics** and insights
- **Digital certificate generation** and management
- **Admin dashboard** for quiz and user management
- **Modern Material Design 3** UI with custom theming

### 👥 User Roles
- **Candidates**: Take quizzes, view results, earn certificates
- **Recruiters**: Manage assessments, invite candidates, view analytics
- **Trainers**: Create content, manage bootcamp assessments

### 📱 Screens & Navigation
1. **Home Screen** - Dashboard with quiz cards, stats, and leaderboard
2. **Quiz Screen** - Interactive quiz interface with timer and progress tracking
3. **Analytics Screen** - Performance metrics and detailed insights
4. **Certificate Screen** - Certificate management with preview and download
5. **Admin Dashboard** - Platform management for authorized users
6. **Profile Screen** - User settings and quiz history

## Technical Architecture

### 🛠 Technology Stack
- **Framework**: Flutter 3.x
- **State Management**: Provider pattern
- **UI**: Material Design 3 with custom theming
- **HTTP Client**: http package for API communication
- **Local Storage**: SharedPreferences for user data
- **Charts**: fl_chart for analytics visualization
- **Icons**: FontAwesome Flutter for rich iconography

### 📦 Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  http: ^1.2.1
  shared_preferences: ^2.2.3
  fl_chart: ^0.68.0
  font_awesome_flutter: ^10.7.0
  cached_network_image: ^3.3.1
  pdf: ^3.10.8
  lottie: ^3.1.2
  flutter_spinkit: ^5.2.1
  fluttertoast: ^8.2.5
  file_picker: ^8.0.3
```

### 🏗 Project Structure
```
lib/
├── config/
│   ├── app_theme.dart          # Theme configuration
│   └── app_routes.dart         # Route management
├── models/
│   ├── user.dart              # User data model
│   ├── quiz.dart              # Quiz data model
│   ├── quiz_attempt.dart      # Quiz attempt model
│   └── certificate.dart       # Certificate model
├── providers/
│   ├── auth_provider.dart     # Authentication state
│   ├── quiz_provider.dart     # Quiz state management
│   └── analytics_provider.dart # Analytics data
├── screens/
│   ├── home_screen.dart       # Main dashboard
│   ├── quiz_screen.dart       # Quiz interface
│   ├── analytics_screen.dart  # Performance analytics
│   ├── certificate_screen.dart # Certificate management
│   ├── admin_dashboard_screen.dart # Admin panel
│   ├── profile_screen.dart    # User profile
│   └── quiz_result_screen.dart # Quiz results
├── widgets/
│   ├── quiz_card.dart         # Reusable quiz card
│   ├── question_widget.dart   # Question display
│   ├── quiz_timer.dart        # Timer component
│   ├── progress_indicator_widget.dart # Progress tracking
│   ├── leaderboard_widget.dart # Leaderboard display
│   ├── stats_overview.dart    # Statistics overview
│   ├── result_summary_card.dart # Result summary
│   └── performance_chart.dart  # Analytics charts
├── services/
│   └── api_service.dart       # Backend API integration
└── main.dart                  # App entry point
```

## Design System

### 🎨 Color Palette
- **Primary**: Deep Blue (#1E3A8A) - Professional and trustworthy
- **Secondary**: Cyber Yellow (#FFD700) - Energetic accent color
- **Neutral**: Graphite Black (#1F2937) - Modern and sophisticated
- **Supporting**: Success, Warning, Error, Info colors

### 🔤 Typography
- **Primary Font**: Roboto (system default)
- **Monospace**: Default monospace for code-related content
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### 🧩 Components
- Custom buttons with gradient effects
- Card-based layouts with elevation
- Progress indicators and timers
- Interactive charts and graphs
- Modal dialogs and bottom sheets

## State Management

### 📊 Provider Architecture
The app uses the Provider pattern for state management with three main providers:

#### AuthProvider
- User authentication and authorization
- Role-based access control
- User profile management
- Demo user system for testing

#### QuizProvider
- Quiz data management
- Question and answer handling
- Quiz attempt tracking
- Score calculation and evaluation

#### AnalyticsProvider
- Performance metrics collection
- Progress tracking over time
- Leaderboard and ranking systems
- Statistical analysis and insights

## API Integration

### 🔌 Backend Communication
The `ApiService` class provides a complete interface for backend communication:

#### Authentication Endpoints
- `POST /auth/login` - User login
- `POST /auth/register` - User registration  
- `POST /auth/logout` - User logout

#### Quiz Management
- `GET /quizzes` - Fetch available quizzes
- `GET /quizzes/{id}` - Get specific quiz
- `POST /quizzes` - Create new quiz (admin)
- `PUT /quizzes/{id}` - Update quiz (admin)
- `DELETE /quizzes/{id}` - Delete quiz (admin)

#### Quiz Attempts
- `POST /quizzes/{id}/attempts` - Start quiz attempt
- `POST /quiz-attempts/{id}/answers` - Submit answers
- `POST /quiz-attempts/{id}/finish` - Complete quiz
- `GET /user/attempts` - Get user's quiz history

#### Certificates & Analytics
- `GET /user/certificates` - User certificates
- `GET /certificates/{id}/download` - Download certificate
- `GET /user/analytics` - User performance data
- `GET /admin/analytics` - Platform analytics (admin)

## Demo Data

### 👤 Demo Users
The app includes three demo users for testing different roles:

1. **John Doe** (Candidate)
   - Email: john.doe@example.com
   - Role: Taking quizzes and earning certificates

2. **Jane Smith** (Recruiter)  
   - Email: jane.smith@techcorp.com
   - Role: Managing recruitment assessments

3. **Mike Johnson** (Trainer)
   - Email: mike.johnson@bootcamp.edu
   - Role: Creating educational content

### 📝 Sample Quizzes
- JavaScript Fundamentals (Beginner)
- React Components (Intermediate)
- Python Data Structures (Advanced)
- Node.js & Express (Intermediate)
- Database Design (Advanced)

## Getting Started

### 📋 Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Git

### 🚀 Installation
1. Clone the repository
2. Navigate to project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

### 🔧 Configuration
- Update `baseUrl` in `ApiService` to your backend URL
- Configure authentication tokens and API keys
- Customize theme colors and fonts as needed

## Deployment

### 📱 Build Commands
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# iOS build
flutter build ios --release
```

### 🚀 Distribution
- Android: Google Play Store
- iOS: Apple App Store
- Web: Progressive Web App deployment

## Future Enhancements

### 🔮 Planned Features
- **AI-powered question generation** and adaptive assessments
- **Video interview integration** with AI evaluation
- **Offline mode support** for quiz taking
- **Real-time collaboration** features
- **Advanced analytics** with ML insights
- **Custom branding** for enterprise clients
- **Integration with ATS systems** and job boards
- **Gamification elements** like badges and achievements

### 🌟 Advanced Features
- Voice-enabled questions and responses
- Augmented reality coding challenges
- Blockchain-based certificate verification
- Social learning and peer interaction
- Multi-language support and localization

## Contributing

### 🤝 Development Guidelines
- Follow Flutter best practices and conventions
- Use meaningful commit messages
- Write comprehensive tests for new features
- Update documentation for any API changes
- Ensure code quality with flutter analyze

### 📝 Code Style
- Use consistent naming conventions
- Follow Dart style guide
- Add comments for complex logic
- Keep widgets focused and reusable
- Implement proper error handling

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For technical support or feature requests, please contact:
- **Email**: support@thetechnoquiz.com
- **Documentation**: https://docs.thetechnoquiz.com
- **Community**: https://community.thetechnoquiz.com

---

**TheTechnoQuiz** - Empowering the future of technical assessments with AI-driven insights and seamless user experiences.
#   Q u i z - G e n a r a t o r  
 