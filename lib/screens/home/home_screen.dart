import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/fade_page_route.dart';
import '../courses/course_list_screen.dart';
import '../about/about_screen.dart';

/// Home screen with custom header, animated CTA buttons, and botanical footer.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _leftButtonController;
  late AnimationController _rightButtonController;
  late Animation<Offset> _leftSlide;
  late Animation<Offset> _rightSlide;
  late Animation<double> _leftFade;
  late Animation<double> _rightFade;

  @override
  void initState() {
    super.initState();

    // Start Learning button slides in from left
    _leftButtonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _leftSlide = Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _leftButtonController,
            curve: Curves.easeOutCubic,
          ),
        );
    _leftFade = CurvedAnimation(
      parent: _leftButtonController,
      curve: Curves.easeOut,
    );

    // About Us button slides in from right
    _rightButtonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rightSlide = Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _rightButtonController,
            curve: Curves.easeOutCubic,
          ),
        );
    _rightFade = CurvedAnimation(
      parent: _rightButtonController,
      curve: Curves.easeOut,
    );

    // Stagger the animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _leftButtonController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _rightButtonController.forward();
    });
  }

  @override
  void dispose() {
    _leftButtonController.dispose();
    _rightButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom Header ──
            _buildHeader(),
            // ── Body ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLG,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingLG),
                    Text(
                      'Welcome, Student 🌿',
                      style: AppTheme.headingLarge.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'What would you like to do today?',
                      style: AppTheme.bodyMedium,
                    ),
                    const Spacer(),
                    // CTA Buttons
                    _buildAnimatedButtons(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            // ── Botanical Footer ──
            _buildBotanicalFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMD,
        vertical: AppTheme.spacingSM * 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              AppConstants.homeLogoPath,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${AppConstants.appName} 🌿',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButtons() {
    return Column(
      children: [
        // Start Learning — filled button, slides from left
        SlideTransition(
          position: _leftSlide,
          child: FadeTransition(
            opacity: _leftFade,
            child: _ScaleTapButton(
              onTap: () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const CourseListScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '📚 Start Learning',
                    style: AppTheme.buttonText.copyWith(fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // About Us — outlined button, slides from right
        SlideTransition(
          position: _rightSlide,
          child: FadeTransition(
            opacity: _rightFade,
            child: _ScaleTapButton(
              onTap: () {
                Navigator.push(
                  context,
                  FadePageRoute(page: const AboutScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    '👨‍💻 About Us',
                    style: AppTheme.buttonText.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotanicalFooter() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withValues(alpha: 0.3),
            AppTheme.secondaryColor.withValues(alpha: 0.15),
            AppTheme.accentColor.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '🌿  🍃  🌱  🍀  🌿  🍃  🌱  🍀  🌿',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 4,
            color: AppTheme.secondaryColor.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

/// Scale-on-tap wrapper for buttons.
class _ScaleTapButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ScaleTapButton({required this.child, required this.onTap});

  @override
  State<_ScaleTapButton> createState() => _ScaleTapButtonState();
}

class _ScaleTapButtonState extends State<_ScaleTapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
