import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/assets.dart';
import 'package:provider/provider.dart';
import 'package:planova_app/features/auth/providers/auth_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animations for the initial icon
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;

  // Animations for the full text logo
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimation();
    _navigateToNextScreen();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400), // Total animation time
    );

    // 1. Icon shrinks from 100% to 40% size during the first half
    _iconScale = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInBack),
      ),
    );

    // 2. Icon fades out smoothly
    _iconOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    // 3. Full Logo scales up (starts slightly small, grows to full size)
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // 4. Full Logo fades in during the second half
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimation() {
    // Wait for the native splash screen to settle before animating
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();

      if (authProvider.isLoggedIn && authProvider.isEmailVerified) {
        context.go('/');
      } else {
        context.go('/signIn');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // --- LAYER 1: The Full PLANOVA Logo (Reveals second) ---
            FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  Assets.imagesLogo,
                  width: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // --- LAYER 2: The Standalone Icon (Appears first, then shrinks) ---
            FadeTransition(
              opacity: _iconOpacity,
              child: ScaleTransition(
                scale: _iconScale,
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 120, // Keep this matching the Native OS icon size
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
