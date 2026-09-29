import 'package:flutter/material.dart';

import '../features/auth/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/patient/home_screen.dart';
import '../features/doctor/doctor_main_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String doctorHome = '/doctor-home';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    doctorHome: (context) => const DoctorMainScreen(),
  };
}