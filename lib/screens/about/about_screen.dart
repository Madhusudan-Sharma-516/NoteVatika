import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/templates/ad_banner_widget.dart';

/// About screen with developer card, social buttons, and motivational quote.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<double> _cardScale;
  late Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _cardScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);

    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const AppBarWidget(title: 'About Us'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingMD),
                  // Developer Card
                  ScaleTransition(
                    scale: _cardScale,
                    child: FadeTransition(
                      opacity: _cardFade,
                      child: _buildDeveloperCard(),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLG),
                  // Motivational Quote
                  FadeTransition(
                    opacity: _cardFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMD,
                      ),
                      child: Text(
                        AppConstants.motivationalQuote,
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.secondaryColor,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLG),
                ],
              ),
            ),
          ),
          // Bottom ad banner
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Developer photo with green ring
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.secondaryColor, width: 3),
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundImage: const AssetImage(AppConstants.devImgPath),
              backgroundColor: AppTheme.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            AppConstants.developerName,
            style: AppTheme.headingMedium.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          // Role
          Text(
            AppConstants.developerRole,
            style: AppTheme.bodyMedium.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 14),
          // Bio
          Text(
            AppConstants.developerBio,
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(height: 1.5, fontSize: 13),
          ),
          const SizedBox(height: 20),
          // Social Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: '🐙',
                label: 'GitHub',
                color: const Color(0xFF24292E),
                onTap: () => _launchUrl(AppConstants.githubUrl),
              ),
              const SizedBox(width: 12),
              _buildInstagramButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstagramButton() {
    return InkWell(
      onTap: () => _launchUrl(AppConstants.instagramUrl),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📸', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              'Instagram',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
