class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.candidate,
      ),
      profileImage: json['profile_image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}

enum UserRole {
  candidate,
  recruiter,
  trainer,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.candidate:
        return 'Candidate';
      case UserRole.recruiter:
        return 'Recruiter';
      case UserRole.trainer:
        return 'Trainer';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  bool get canCreateQuizzes {
    return this == UserRole.recruiter || 
           this == UserRole.trainer || 
           this == UserRole.admin;
  }

  bool get canViewAnalytics {
    return this == UserRole.recruiter || 
           this == UserRole.trainer || 
           this == UserRole.admin;
  }
}
