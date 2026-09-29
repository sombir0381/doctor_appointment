import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../services/appointment_service.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({
    super.key,
  });

  @override
  State<DoctorDashboard> createState() =>
      _DoctorDashboardState();
}

class _DoctorDashboardState
    extends State<DoctorDashboard> {
  // Mock logged-in doctor.
  // Backend connect hone par ye data service/API se aayega.
  final Doctor doctor = const Doctor(
    id: 'doctor_001',
    userId: 'doctor_user_001',
    name: 'Dr. Sarah Khan',
    profileImage: null,
    specialty: 'Cardiologist',
    qualification: 'MBBS, MD Cardiology',
    experienceYears: 10,
    rating: 4.8,
    reviewCount: 245,
    clinicName: 'Heart Care Clinic',
    location: 'Ludhiana, Punjab',
    consultationFee: 800,
    about:
    'Experienced cardiologist providing patient-focused cardiac care.',
    consultationModes: [
      'In-person',
      'Video',
    ],
    verified: true,
  );

  final String doctorId = 'doctor_001';

  List<Appointment> get doctorAppointments {
    return AppointmentService.appointments
        .where(
          (appointment) =>
      appointment.doctorId == doctorId,
    )
        .toList();
  }

  List<Appointment> get todayAppointments {
    final DateTime now = DateTime.now();

    return doctorAppointments.where(
          (appointment) {
        return appointment.date.year == now.year &&
            appointment.date.month == now.month &&
            appointment.date.day == now.day;
      },
    ).toList();
  }

  List<Appointment> get pendingAppointments {
    return doctorAppointments
        .where(
          (appointment) =>
      appointment.status == 'pending',
    )
        .toList();
  }

  List<Appointment> get confirmedAppointments {
    return doctorAppointments
        .where(
          (appointment) =>
      appointment.status == 'confirmed',
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),

      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _buildWelcomeHeader(),

            const SizedBox(height: 22),

            _buildStatistics(),

            const SizedBox(height: 26),

            _buildSectionHeader(
              title: "Today's Appointments",
              actionText: 'View All',
              onActionTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Doctor Appointments screen '
                          'will be connected next.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildTodayAppointments(),

            const SizedBox(height: 26),

            _buildSectionHeader(
              title: 'Quick Actions',
            ),

            const SizedBox(height: 12),

            _buildQuickActions(),

            const SizedBox(height: 26),

            _buildAvailabilityCard(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Doctor Dashboard',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Doctor notifications will be '
                      'connected later.',
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor:
            Colors.white.withOpacity(0.18),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  doctor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  doctor.specialty,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (doctor.verified)
            const Icon(
              Icons.verified_rounded,
              color: Colors.white,
              size: 25,
            ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'Today',
            value:
            todayAppointments.length.toString(),
            icon: Icons.calendar_today_rounded,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _statCard(
            title: 'Pending',
            value:
            pendingAppointments.length.toString(),
            icon: Icons.pending_actions_rounded,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _statCard(
            title: 'Confirmed',
            value:
            confirmedAppointments.length.toString(),
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor
                  .withOpacity(0.08),
              borderRadius:
              BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color:
              AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTodayAppointments() {
    if (todayAppointments.isEmpty) {
      return _buildEmptyTodayAppointments();
    }

    return Column(
      children: todayAppointments
          .take(3)
          .map(
            (appointment) =>
            _buildAppointmentCard(
              appointment,
            ),
      )
          .toList(),
    );
  }

  Widget _buildAppointmentCard(
      Appointment appointment,
      ) {
    final String patientName =
    _getPatientName(appointment.patientId);

    final Color statusColor =
    _statusColor(appointment.status);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                AppTheme.primaryColor
                    .withOpacity(0.08),
                child: const Icon(
                  Icons.person_rounded,
                  color:
                  AppTheme.primaryColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      appointment.consultationType,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme
                            .secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(
                appointment.status,
                statusColor,
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(height: 1),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 18,
                color:
                AppTheme.primaryColor,
              ),

              const SizedBox(width: 7),

              Text(
                appointment.time,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.video_call_outlined,
                size: 18,
                color:
                AppTheme.primaryColor,
              ),

              const SizedBox(width: 5),

              Text(
                appointment.consultationType,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme
                      .secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(
      String status,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        _formatStatus(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmptyTodayAppointments() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor
                  .withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available_rounded,
              size: 32,
              color:
              AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'No appointments today',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Your scheduled appointments will '
                'appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color:
              AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickAction(
            icon: Icons.calendar_month_outlined,
            title: 'Appointments',
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Appointments screen is next.',
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _quickAction(
            icon: Icons.schedule_outlined,
            title: 'Availability',
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Availability screen is next.',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor
                    .withOpacity(0.08),
                borderRadius:
                BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color:
                AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green
                  .withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.circle,
              color: Colors.green,
              size: 18,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You are currently available',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Availability management '
                        'will be added next.',
                  ),
                ),
              );
            },
            child: const Text('Manage'),
          ),
        ],
      ),
    );
  }

  String _getPatientName(String patientId) {
    // Mock patient data.
    // Backend connect hone par patient service
    // se actual name aayega.

    if (patientId == 'patient_001') {
      return 'Sombir';
    }

    return 'Patient';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;

      case 'confirmed':
        return Colors.green;

      case 'completed':
        return Colors.teal;

      case 'cancelled':
        return Colors.red;

      case 'rejected':
        return Colors.redAccent;

      case 'rescheduled':
        return Colors.deepPurple;

      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return status;
    }

    return status[0].toUpperCase() +
        status.substring(1);
  }

  Future<void> _refreshDashboard() async {
    setState(() {});
  }
}