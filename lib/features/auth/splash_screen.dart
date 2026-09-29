import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _startApp();
  }

  void _startApp() {
    Timer(
      const Duration(seconds: 2),
          () {
        if (!mounted) return;

        // Abhi real session/authentication nahi laga hai.
        // Isliye temporarily Login screen par ja rahe hain.
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // App Logo
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  size: 58,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 28),

              // App Name
              const Text(
                'DoctorEase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Your Health, Our Priority',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 45),

              // Loading Indicator
              const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}