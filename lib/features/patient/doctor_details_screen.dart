import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/doctor.dart';
import 'booking_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Doctor Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // DOCTOR PROFILE
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 55,
                      color: AppTheme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          doctor.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                      ),
                      if (doctor.verified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          size: 21,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 7),

                  // Specialty
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondaryColor,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Qualification
                  Text(
                    doctor.qualification,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 22,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        doctor.rating.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '(${doctor.reviewCount} reviews)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // QUICK INFORMATION
            // =========================
            const Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.work_outline,
                    title: 'Experience',
                    value: '${doctor.experienceYears} Years',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.payments_outlined,
                    title: 'Consultation',
                    value: '₹${doctor.consultationFee.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _DetailsCard(
              icon: Icons.local_hospital_outlined,
              title: 'Clinic',
              value: doctor.clinicName,
            ),

            const SizedBox(height: 10),

            _DetailsCard(
              icon: Icons.location_on_outlined,
              title: 'Location',
              value: doctor.location,
            ),

            const SizedBox(height: 24),

            // =========================
            // ABOUT DOCTOR
            // =========================
            const Text(
              'About Doctor',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                doctor.about,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // CONSULTATION MODES
            // =========================
            const Text(
              'Consultation Modes',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: doctor.consultationModes.map(
                    (mode) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          mode.toLowerCase().contains('online')
                              ? Icons.video_call_outlined
                              : Icons.local_hospital_outlined,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          mode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 30),

            // =========================
            // BOOK APPOINTMENT BUTTON
            // =========================
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        doctor: doctor,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.calendar_month_outlined,
                ),
                label: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// INFO CARD
// ======================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 25,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// DETAILS CARD
// ======================================================

class _DetailsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailsCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}