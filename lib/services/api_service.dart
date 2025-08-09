import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/quiz.dart';
import '../models/quiz_attempt.dart';
import '../models/certificate.dart';

class ApiService {
  // Replace with your actual backend URL
  static const String baseUrl = 'https://api.thetechnoquiz.com';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> get _authHeaders => {
        ..._headers,
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Authentication APIs
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role.name,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _authHeaders,
      );
      _authToken = null;
    } catch (e) {
      throw ApiException('Logout failed: $e');
    }
  }

  // User APIs
  Future<User> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: _authHeaders,
      );

      final data = _handleResponse(response);
      return User.fromJson(data['user']);
    } catch (e) {
      throw ApiException('Failed to get user: $e');
    }
  }

  Future<User> updateProfile({
    required String name,
    String? profileImage,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: _authHeaders,
        body: jsonEncode({
          'name': name,
          if (profileImage != null) 'profile_image': profileImage,
        }),
      );

      final data = _handleResponse(response);
      return User.fromJson(data['user']);
    } catch (e) {
      throw ApiException('Failed to update profile: $e');
    }
  }

  // Quiz APIs
  Future<List<Quiz>> getQuizzes({
    int page = 1,
    int limit = 20,
    String? category,
    QuizDifficulty? difficulty,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (difficulty != null) 'difficulty': difficulty.name,
      };

      final uri = Uri.parse('$baseUrl/quizzes').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _authHeaders);
      final data = _handleResponse(response);

      return (data['quizzes'] as List)
          .map((json) => Quiz.fromJson(json))
          .toList();
    } catch (e) {
      throw ApiException('Failed to get quizzes: $e');
    }
  }

  Future<Quiz> getQuizById(String quizId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quizzes/$quizId'),
        headers: _authHeaders,
      );

      final data = _handleResponse(response);
      return Quiz.fromJson(data['quiz']);
    } catch (e) {
      throw ApiException('Failed to get quiz: $e');
    }
  }

  Future<Quiz> createQuiz(Quiz quiz) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quizzes'),
        headers: _authHeaders,
        body: jsonEncode(quiz.toJson()),
      );

      final data = _handleResponse(response);
      return Quiz.fromJson(data['quiz']);
    } catch (e) {
      throw ApiException('Failed to create quiz: $e');
    }
  }

  Future<Quiz> updateQuiz(String quizId, Quiz quiz) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/quizzes/$quizId'),
        headers: _authHeaders,
        body: jsonEncode(quiz.toJson()),
      );

      final data = _handleResponse(response);
      return Quiz.fromJson(data['quiz']);
    } catch (e) {
      throw ApiException('Failed to update quiz: $e');
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/quizzes/$quizId'),
        headers: _authHeaders,
      );

      _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to delete quiz: $e');
    }
  }

  // Quiz Attempt APIs
  Future<QuizAttempt> startQuizAttempt(String quizId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quizzes/$quizId/attempts'),
        headers: _authHeaders,
      );

      final data = _handleResponse(response);
      return QuizAttempt.fromJson(data['attempt']);
    } catch (e) {
      throw ApiException('Failed to start quiz attempt: $e');
    }
  }

  Future<QuizAttempt> submitAnswer({
    required String attemptId,
    required String questionId,
    required List<String> selectedAnswers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz-attempts/$attemptId/answers'),
        headers: _authHeaders,
        body: jsonEncode({
          'question_id': questionId,
          'selected_answers': selectedAnswers,
        }),
      );

      final data = _handleResponse(response);
      return QuizAttempt.fromJson(data['attempt']);
    } catch (e) {
      throw ApiException('Failed to submit answer: $e');
    }
  }

  Future<QuizAttempt> finishQuizAttempt(String attemptId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz-attempts/$attemptId/finish'),
        headers: _authHeaders,
      );

      final data = _handleResponse(response);
      return QuizAttempt.fromJson(data['attempt']);
    } catch (e) {
      throw ApiException('Failed to finish quiz attempt: $e');
    }
  }

  Future<List<QuizAttempt>> getUserAttempts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/user/attempts').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _authHeaders);
      final data = _handleResponse(response);

      return (data['attempts'] as List)
          .map((json) => QuizAttempt.fromJson(json))
          .toList();
    } catch (e) {
      throw ApiException('Failed to get user attempts: $e');
    }
  }

  // Certificate APIs
  Future<List<Certificate>> getUserCertificates({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/user/certificates').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri, headers: _authHeaders);
      final data = _handleResponse(response);

      return (data['certificates'] as List)
          .map((json) => Certificate.fromJson(json))
          .toList();
    } catch (e) {
      throw ApiException('Failed to get certificates: $e');
    }
  }

  Future<Certificate> getCertificateById(String certificateId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/certificates/$certificateId'),
        headers: _authHeaders,
      );

      final data = _handleResponse(response);
      return Certificate.fromJson(data['certificate']);
    } catch (e) {
      throw ApiException('Failed to get certificate: $e');
    }
  }

  Future<String> downloadCertificate(String certificateId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/certificates/$certificateId/download'),
        headers: _authHeaders,
      );

      final data = _handleResponse(response);
      return data['download_url'];
    } catch (e) {
      throw ApiException('Failed to download certificate: $e');
    }
  }

  // Analytics APIs
  Future<Map<String, dynamic>> getUserAnalytics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/analytics'),
        headers: _authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to get user analytics: $e');
    }
  }

  Future<Map<String, dynamic>> getAdminAnalytics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/analytics'),
        headers: _authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Failed to get admin analytics: $e');
    }
  }

  // Helper method to handle HTTP responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      _authToken = null;
      throw ApiException('Unauthorized access');
    } else if (response.statusCode == 403) {
      throw ApiException('Forbidden access');
    } else if (response.statusCode == 404) {
      throw ApiException('Resource not found');
    } else if (response.statusCode >= 500) {
      throw ApiException('Server error');
    } else {
      final errorData = jsonDecode(response.body);
      throw ApiException(errorData['message'] ?? 'API request failed');
    }
  }
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
