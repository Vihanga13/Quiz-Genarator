import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/analytics_provider.dart';
import '../models/certificate.dart';
import '../config/app_theme.dart';

class CertificateScreen extends StatefulWidget {
  final String? certificateId;

  const CertificateScreen({
    super.key,
    this.certificateId,
  });

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().fetchCertificates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Certificates',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.deepBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, analyticsProvider, child) {
          if (analyticsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (analyticsProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.triangleExclamation,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading certificates',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(analyticsProvider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => analyticsProvider.fetchCertificates(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final certificates = analyticsProvider.certificates;

          if (certificates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.award,
                    size: 64,
                    color: AppColors.mediumGray,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Certificates Yet',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.graphiteBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete quizzes and pass them to earn certificates!',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      color: AppColors.mediumGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(FontAwesomeIcons.play),
                    label: const Text('Take a Quiz'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: certificates.length,
            itemBuilder: (context, index) {
              final certificate = certificates[index];
              return _buildCertificateCard(certificate, analyticsProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildCertificateCard(Certificate certificate, AnalyticsProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.deepBlue, AppColors.cyberYellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.award,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certificate.quizTitle,
                          style: const TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Certificate of Achievement',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14,
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      certificate.status.displayName,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(certificate.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCertificateDetail(
                          'Score',
                          certificate.scorePercentage,
                          FontAwesomeIcons.chartBar,
                        ),
                        _buildCertificateDetail(
                          'Issued',
                          certificate.formattedIssueDate,
                          FontAwesomeIcons.calendar,
                        ),
                        _buildCertificateDetail(
                          'Verification',
                          certificate.verificationCode?.substring(0, 8) ?? 'N/A',
                          FontAwesomeIcons.shieldHalved,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewCertificate(certificate),
                      icon: const Icon(FontAwesomeIcons.eye, size: 16),
                      label: const Text('View'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadCertificate(certificate, provider),
                      icon: const Icon(FontAwesomeIcons.download, size: 16),
                      label: const Text('Download'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.deepBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.white,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 10,
            color: AppColors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(CertificateStatus status) {
    switch (status) {
      case CertificateStatus.active:
        return AppColors.success;
      case CertificateStatus.revoked:
        return AppColors.error;
      case CertificateStatus.expired:
        return AppColors.warning;
    }
  }

  void _viewCertificate(Certificate certificate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Certificate Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.award,
              size: 64,
              color: AppColors.cyberYellow,
            ),
            const SizedBox(height: 16),
            const Text(
              'TheTechnoQuiz',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Certificate of Achievement'),
            const SizedBox(height: 16),
            Text(
              'This certifies that',
              style: TextStyle(
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              certificate.userName,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'has successfully completed',
              style: TextStyle(
                color: AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              certificate.quizTitle,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${certificate.scorePercentage}',
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _downloadCertificate(Certificate certificate, AnalyticsProvider provider) async {
    final success = await provider.downloadCertificate(certificate.id);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success 
                ? 'Certificate downloaded successfully!' 
                : 'Failed to download certificate',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }
}
