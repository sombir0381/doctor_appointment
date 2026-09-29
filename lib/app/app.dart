import 'package:flutter/material.dart';

import 'theme.dart';
import 'routes.dart';

class DoctorEaseApp extends StatelessWidget {
  const DoctorEaseApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DoctorEase',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}