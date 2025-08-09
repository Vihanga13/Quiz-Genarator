class Certificate {
  final String id;
  final String userId;
  final String quizId;
  final String quizTitle;
  final String userName;
  final double score;
  final double passingScore;
  final DateTime issuedAt;
  final String certificateUrl;
  final CertificateStatus status;
  final String? verificationCode;

  Certificate({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.userName,
    required this.score,
    required this.passingScore,
    required this.issuedAt,
    required this.certificateUrl,
    required this.status,
    this.verificationCode,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      quizId: json['quiz_id'] as String,
      quizTitle: json['quiz_title'] as String,
      userName: json['user_name'] as String,
      score: (json['score'] as num).toDouble(),
      passingScore: (json['passing_score'] as num).toDouble(),
      issuedAt: DateTime.parse(json['issued_at'] as String),
      certificateUrl: json['certificate_url'] as String,
      status: CertificateStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CertificateStatus.active,
      ),
      verificationCode: json['verification_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quiz_id': quizId,
      'quiz_title': quizTitle,
      'user_name': userName,
      'score': score,
      'passing_score': passingScore,
      'issued_at': issuedAt.toIso8601String(),
      'certificate_url': certificateUrl,
      'status': status.toString().split('.').last,
      'verification_code': verificationCode,
    };
  }

  bool get isPassed => score >= passingScore;

  String get scorePercentage => '${score.toStringAsFixed(1)}%';

  String get formattedIssueDate {
    return '${issuedAt.day}/${issuedAt.month}/${issuedAt.year}';
  }
}

enum CertificateStatus {
  active,
  revoked,
  expired,
}

extension CertificateStatusExtension on CertificateStatus {
  String get displayName {
    switch (this) {
      case CertificateStatus.active:
        return 'Active';
      case CertificateStatus.revoked:
        return 'Revoked';
      case CertificateStatus.expired:
        return 'Expired';
    }
  }
}
