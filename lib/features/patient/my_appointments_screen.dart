import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../services/appointment_service.dart';
import 'appointment_details_screen.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({
    super.key,
  });

  @override
  State<MyAppointmentsScreen> createState() =>
      _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState
    extends State<MyAppointmentsScreen> {
  final String patientId = 'patient_001';

  final List<Doctor> doctors = [
    const Doctor(
      id: 'doctor_001',
      userId: 'user_001',
      name: 'Dr. Sarah Wilson',
      profileImage: null,
      specialty: 'Cardiologist',
      qualification: 'MD, Cardiology',
      experienceYears: 12,
      rating: 4.9,
      reviewCount: 248,
      clinicName: 'Heart Care Clinic',
      location: 'Dubai Healthcare City',
      consultationFee: 500,
      about:
      'Experienced cardiologist providing comprehensive heart care and preventive cardiology services.',
      consultationModes: [
        'In-person',
        'Video Consultation',
      ],
      verified: true,
    ),
    const Doctor(
      id: 'doctor_002',
      userId: 'user_002',
      name: 'Dr. Michael Brown',
      profileImage: null,
      specialty: 'Dermatologist',
      qualification: 'MD, Dermatology',
      experienceYears: 10,
      rating: 4.8,
      reviewCount: 186,
      clinicName: 'Skin Wellness Clinic',
      location: 'Downtown Dubai',
      consultationFee: 400,
      about:
      'Specialist dermatologist focused on skin, hair and cosmetic dermatology.',
      consultationModes: [
        'In-person',
        'Video Consultation',
      ],
      verified: true,
    ),
    const Doctor(
      id: 'doctor_003',
      userId: 'user_003',
      name: 'Dr. Emily Johnson',
      profileImage: null,
      specialty: 'General Physician',
      qualification: 'MBBS, MD',
      experienceYears: 8,
      rating: 4.7,
      reviewCount: 154,
      clinicName: 'City Medical Center',
      location: 'Jumeirah',
      consultationFee: 300,
      about:
      'General physician providing primary healthcare and routine medical consultations.',
      consultationModes: [
        'In-person',
        'Video Consultation',
      ],
      verified: true,
    ),
    const Doctor(
      id: 'doctor_004',
      userId: 'user_004',
      name: 'Dr. David Miller',
      profileImage: null,
      specialty: 'Dentist',
      qualification: 'BDS, MDS',
      experienceYears: 9,
      rating: 4.6,
      reviewCount: 132,
      clinicName: 'Bright Smile Dental',
      location: 'Business Bay',
      consultationFee: 350,
      about:
      'Experienced dentist providing general, cosmetic and preventive dental care.',
      consultationModes: [
        'In-person',
      ],
      verified: true,
    ),
    const Doctor(
      id: 'doctor_005',
      userId: 'user_005',
      name: 'Dr. Sophia Anderson',
      profileImage: null,
      specialty: 'Pediatrician',
      qualification: 'MD, Pediatrics',
      experienceYears: 11,
      rating: 4.9,
      reviewCount: 210,
      clinicName: 'Little Care Hospital',
      location: 'Al Barsha',
      consultationFee: 450,
      about:
      'Pediatrician specializing in child healthcare, development and preventive care.',
      consultationModes: [
        'In-person',
        'Video Consultation',
      ],
      verified: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Refresh once when screen is created.
    _refreshAppointments();
  }

  void _refreshAppointments() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<Appointment> get appointments {
    return AppointmentService.getPatientAppointments(
      patientId,
    );
  }

  Doctor? getDoctor(String doctorId) {
    for (final Doctor doctor in doctors) {
      if (doctor.id == doctorId) {
        return doctor;
      }
    }

    return null;
  }

  void openAppointmentDetails(
      Appointment appointment,
      ) {
    final Doctor? doctor = getDoctor(
      appointment.doctorId,
    );

    if (doctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Doctor information not found.',
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AppointmentDetailsScreen(
            appointment: appointment,
            doctor: doctor,
          );
        },
      ),
    ).then((_) {
      // Refresh appointment list after returning
      // from appointment details screen.
      _refreshAppointments();
    });
  }

  String formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;

      case 'completed':
        return Colors.blue;

      case 'cancelled':
        return Colors.red;

      case 'rejected':
        return Colors.red;

      case 'rescheduled':
        return Colors.orange;

      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';

      case 'completed':
        return 'Completed';

      case 'cancelled':
        return 'Cancelled';

      case 'rejected':
        return 'Rejected';

      case 'rescheduled':
        return 'Rescheduled';

      case 'pending':
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Appointment> appointmentList =
        appointments;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: appointmentList.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: () async {
          _refreshAppointments();
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: appointmentList.length,
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 14,
            );
          },
          itemBuilder: (context, index) {
            final Appointment appointment =
            appointmentList[index];

            final Doctor? doctor = getDoctor(
              appointment.doctorId,
            );

            return _AppointmentCard(
              appointment: appointment,
              doctor: doctor,
              formatDate: formatDate,
              statusColor: getStatusColor(
                appointment.status,
              ),
              statusText: getStatusText(
                appointment.status,
              ),
              onTap: () {
                openAppointmentDetails(
                  appointment,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(
                  0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'No Appointments Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your booked appointments will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// APPOINTMENT CARD
// ============================================================

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Doctor? doctor;
  final String Function(DateTime) formatDate;
  final Color statusColor;
  final String statusText;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.doctor,
    required this.formatDate,
    required this.statusColor,
    required this.statusText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String doctorName =
        doctor?.name ?? 'Doctor';

    final String specialty =
        doctor?.specialty ?? 'Specialist';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Container(
                    height: 60,
                    width: 60,

                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor
                          .withOpacity(0.10),
                      borderRadius:
                      BorderRadius.circular(15),
                    ),

                    child: const Icon(
                      Icons.person_rounded,
                      color:
                      AppTheme.primaryColor,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          doctorName,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          specialty,
                          style: const TextStyle(
                            fontSize: 13,
                            color:
                            AppTheme
                                .secondaryTextColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: statusColor
                                .withOpacity(0.10),
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),

                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color:
                    AppTheme.secondaryTextColor,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Divider(height: 1),

              const SizedBox(height: 14),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color:
                    AppTheme.primaryColor,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      formatDate(
                        appointment.date,
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color:
                    AppTheme.primaryColor,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    appointment.time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.medical_services_outlined,
                    size: 18,
                    color:
                    AppTheme.primaryColor,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      appointment.consultationType,
                      style: const TextStyle(
                        fontSize: 13,
                        color:
                        AppTheme
                            .secondaryTextColor,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color:
                    AppTheme.secondaryTextColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}