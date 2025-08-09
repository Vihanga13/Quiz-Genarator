import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  // Hardcoded demo users for testing
  final List<User> _demoUsers = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      role: UserRole.candidate,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLogin: DateTime.now(),
    ),
    User(
      id: '2',
      name: 'Jane Smith',
      email: 'jane.smith@techcorp.com',
      role: UserRole.recruiter,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    User(
      id: '3',
      name: 'Mike Johnson',
      email: 'mike.johnson@bootcamp.edu',
      role: UserRole.trainer,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastLogin: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  AuthProvider() {
    // Auto-login with demo user for testing
    _autoLogin();
  }

  void _autoLogin() {
    // Simulate auto-login with first demo user
    _currentUser = _demoUsers[0];
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Find demo user by email
      final user = _demoUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Invalid email or password');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if user already exists
      final existingUser = _demoUsers.any(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (existingUser) {
        throw Exception('User with this email already exists');
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      _demoUsers.add(newUser);
      _currentUser = newUser;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? profileImage,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Update current user (this would normally be an API call)
      final updatedUser = User(
        id: _currentUser!.id,
        name: name,
        email: _currentUser!.email,
        role: _currentUser!.role,
        profileImage: profileImage ?? _currentUser!.profileImage,
        createdAt: _currentUser!.createdAt,
        lastLogin: DateTime.now(),
      );

      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void switchUser(String userId) {
    final user = _demoUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => _demoUsers[0],
    );
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
