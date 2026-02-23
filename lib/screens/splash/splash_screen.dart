import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/remote/api_service.dart';
import '../home/home_screen.dart';

/// Animated splash screen with logo scale+fade, text slide-up, and progress bar.
/// Navigates to HomeScreen after 3 seconds with fade transition.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _taglineController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    // Pre-fetch data in background during splash
    ApiService().getCourses();

    // Logo: scale + fade (800ms, easeOutBack)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Title: slide up + fade (600ms)
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _titleFade = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
        );

    // Tagline: fade (400ms)
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _taglineFade = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    );

    // Animate in sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _titleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _taglineController.forward();
    });

    // Navigate after splash duration
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          _FadePageRoute(page: const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        AppConstants.logoPath,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // App Name
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleFade,
                    child: Text(
                      AppConstants.appName,
                      style: AppTheme.headingLarge.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Tagline
                FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    AppConstants.appTagline,
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom progress bar
          Positioned(
            left: 40,
            right: 40,
            bottom: 60,
            child: FadeTransition(
              opacity: _taglineFade,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.accentColor.withValues(alpha: 0.7),
                  ),
                  minHeight: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom fade page transition.
class _FadePageRoute extends PageRouteBuilder {
  final Widget page;

  _FadePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
}
