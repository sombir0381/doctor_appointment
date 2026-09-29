import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'doctor_dashboard.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_availability_screen.dart';
import 'doctor_profile_screen.dart';

class DoctorMainScreen extends StatefulWidget {
  const DoctorMainScreen({
    super.key,
  });

  @override
  State<DoctorMainScreen> createState() =>
      _DoctorMainScreenState();
}

class _DoctorMainScreenState
    extends State<DoctorMainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    DoctorDashboard(),
    DoctorAppointmentsScreen(),
    DoctorAvailabilityScreen(),
    DoctorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: Colors.white,
        elevation: 3,
        selectedIndex: selectedIndex,

        indicatorColor:
        AppTheme.primaryColor.withOpacity(0.12),

        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
            ),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
            ),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: 'Appointments',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.access_time_outlined,
            ),
            selectedIcon: Icon(
              Icons.access_time_filled,
            ),
            label: 'Availability',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}