import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'search_doctors_screen.dart';
import 'my_appointments_screen.dart';
import 'profile_screen.dart';

class PatientMainScreen extends StatefulWidget {
  const PatientMainScreen({
    super.key,
  });

  @override
  State<PatientMainScreen> createState() =>
      _PatientMainScreenState();
}

class _PatientMainScreenState
    extends State<PatientMainScreen> {

  int selectedIndex = 0;

  // Appointment screen ko refresh karne ke liye
  int appointmentRefreshKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const HomeScreen(),

          const SearchDoctorsScreen(),

          MyAppointmentsScreen(
            key: ValueKey(appointmentRefreshKey),
          ),

          const ProfileScreen(),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;

            // Jab Appointments tab open hoga,
            // screen ko fresh create karenge.
            if (index == 2) {
              appointmentRefreshKey++;
            }
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),

          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: 'Appointments',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}