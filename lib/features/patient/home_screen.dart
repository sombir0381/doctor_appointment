import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../services/appointment_service.dart';
import '../../services/doctor_service.dart';
import '../../services/profile_service.dart';
import '../notifications/notifications_screen.dart';
import 'appointment_details_screen.dart';
import 'booking_screen.dart';
import 'doctor_details_screen.dart';
import 'search_doctors_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String patientId = 'patient_001';

  List<Doctor> get doctors {
    return DoctorService.getDoctors();
  }

  List<Doctor> get featuredDoctors {
    final List<Doctor> result = [...doctors];

    result.sort(
          (a, b) => b.rating.compareTo(a.rating),
    );

    return result.take(4).toList();
  }

  List<Appointment> get patientAppointments {
    return AppointmentService.getPatientAppointments(
      patientId,
    );
  }

  Appointment? get upcomingAppointment {
    final DateTime now = DateTime.now();

    final List<Appointment> upcoming =
    patientAppointments.where((appointment) {
      final bool validStatus =
          appointment.status == 'pending' ||
              appointment.status == 'confirmed' ||
              appointment.status == 'rescheduled';

      final DateTime appointmentDate = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
      );

      final DateTime today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      return validStatus &&
          !appointmentDate.isBefore(today);
    }).toList();

    if (upcoming.isEmpty) {
      return null;
    }

    upcoming.sort(
          (a, b) {
        final DateTime aDateTime = _combineDateAndTime(
          a.date,
          a.time,
        );

        final DateTime bDateTime = _combineDateAndTime(
          b.date,
          b.time,
        );

        return aDateTime.compareTo(bDateTime);
      },
    );

    return upcoming.first;
  }

  Doctor? _getDoctor(String doctorId) {
    return DoctorService.getDoctorById(
      doctorId,
    );
  }

  DateTime _combineDateAndTime(
      DateTime date,
      String time,
      ) {
    final List<String> parts = time.trim().split(' ');

    if (parts.length != 2) {
      return date;
    }

    final List<String> hourMinute = parts[0].split(':');

    if (hourMinute.length != 2) {
      return date;
    }

    int hour = int.tryParse(hourMinute[0]) ?? 0;

    final int minute = int.tryParse(
      hourMinute[1],
    ) ??
        0;

    final String period = parts[1].toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    }

    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SearchDoctorsScreen();
        },
      ),
    );
  }

  void _openSearchBySpecialty(
      String specialty,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SearchDoctorsScreen(
            initialSpecialty: specialty,
          );
        },
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const NotificationsScreen();
        },
      ),
    );
  }

  void _openDoctorDetails(
      Doctor doctor,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DoctorDetailsScreen(
            doctor: doctor,
          );
        },
      ),
    );
  }

  void _openBooking(
      Doctor doctor,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookingScreen(
            doctor: doctor,
          );
        },
      ),
    );
  }

  void _openAppointmentDetails(
      Appointment appointment,
      ) {
    final Doctor? doctor = _getDoctor(
      appointment.doctorId,
    );

    if (doctor == null) {
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
    );
  }

  String _formatAppointmentDate(
      DateTime date,
      ) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getGreeting() {
    final int hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    }

    if (hour < 17) {
      return 'Good Afternoon';
    }

    return 'Good Evening';
  }

  IconData _specialtyIcon(
      String specialty,
      ) {
    final String value = specialty.toLowerCase();

    if (value.contains('cardio')) {
      return Icons.favorite_outline_rounded;
    }

    if (value.contains('derma')) {
      return Icons.face_retouching_natural_outlined;
    }

    if (value.contains('pediatric')) {
      return Icons.child_care_outlined;
    }

    if (value.contains('orthopedic')) {
      return Icons.accessibility_new_rounded;
    }

    if (value.contains('gynec')) {
      return Icons.pregnant_woman_outlined;
    }

    if (value.contains('neuro')) {
      return Icons.psychology_outlined;
    }

    if (value.contains('ent')) {
      return Icons.hearing_outlined;
    }

    if (value.contains('general')) {
      return Icons.medical_services_outlined;
    }

    return Icons.local_hospital_outlined;
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final user = ProfileService.getCurrentUser();

    final List<String> specialties = doctors
        .map(
          (doctor) => doctor.specialty,
    )
        .toSet()
        .toList();

    final Appointment? appointment =
        upcomingAppointment;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              32,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    _ProfileAvatar(
                      name: user.name,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()} 👋',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme
                                  .secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user.name.isEmpty
                                ? 'Welcome to DoctorEase'
                                : user.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              AppTheme.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _HeaderIconButton(
                      icon: Icons
                          .notifications_none_rounded,
                      onPressed:
                      _openNotifications,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // SEARCH TITLE
                const Text(
                  'Find Your Doctor',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Find the right doctor for your healthcare needs.',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                    AppTheme.secondaryTextColor,
                  ),
                ),

                const SizedBox(height: 16),

                // SEARCH BOX
                GestureDetector(
                  onTap: _openSearch,
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                        'Search doctors, specialties...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color:
                          AppTheme.primaryColor,
                        ),
                        suffixIcon: Container(
                          margin:
                          const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color:
                            AppTheme.primaryColor,
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // UPCOMING APPOINTMENT
                if (appointment != null)
                  _buildUpcomingAppointment(
                    appointment,
                  ),

                if (appointment != null)
                  const SizedBox(height: 30),

                // SPECIALTIES
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Specialties',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _openSearch,
                      child: const Text(
                        'See All',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 108,
                  child: ListView.builder(
                    scrollDirection:
                    Axis.horizontal,
                    itemCount: specialties.length,
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final String specialty =
                      specialties[index];

                      return _SpecialtyItem(
                        icon: _specialtyIcon(
                          specialty,
                        ),
                        title: specialty,
                        onTap: () {
                          _openSearchBySpecialty(
                            specialty,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // FEATURED DOCTORS
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Doctors',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _openSearch,
                      child: const Text(
                        'See All',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ...featuredDoctors.map(
                      (doctor) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: _DoctorHomeCard(
                        doctor: doctor,
                        onViewDetails: () {
                          _openDoctorDetails(
                            doctor,
                          );
                        },
                        onBookNow: () {
                          _openBooking(
                            doctor,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointment(
      Appointment appointment,
      ) {
    final Doctor? doctor = _getDoctor(
      appointment.doctorId,
    );

    if (doctor == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Appointment',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () {
            _openAppointmentDetails(
              appointment,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor
                      .withOpacity(0.88),
                ],
              ),
              borderRadius:
              BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor
                      .withOpacity(0.18),
                  blurRadius: 18,
                  offset:
                  const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.18),
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: const Icon(
                    Icons
                        .calendar_month_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          color: Colors.white
                              .withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _AppointmentInfo(
                            icon: Icons
                                .calendar_today_rounded,
                            text:
                            _formatAppointmentDate(
                              appointment.date,
                            ),
                          ),
                          _AppointmentInfo(
                            icon: Icons
                                .access_time_rounded,
                            text:
                            appointment.time,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// PROFILE AVATAR
// ======================================================

class _ProfileAvatar extends StatelessWidget {
  final String name;

  const _ProfileAvatar({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final String initial = name.trim().isEmpty
        ? 'U'
        : name.trim().substring(0, 1).toUpperCase();

    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color:
        AppTheme.primaryColor.withOpacity(0.10),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ======================================================
// HEADER BUTTON
// ======================================================

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppTheme.textColor,
        ),
      ),
    );
  }
}

// ======================================================
// SPECIALTY ITEM
// ======================================================

class _SpecialtyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SpecialtyItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 102,
        margin:
        const EdgeInsets.only(right: 12),
        padding:
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color:
                AppTheme.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// DOCTOR HOME CARD
// ======================================================

class _DoctorHomeCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onViewDetails;
  final VoidCallback onBookNow;

  const _DoctorHomeCard({
    required this.doctor,
    required this.onViewDetails,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                height: 78,
                width: 78,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor
                      .withOpacity(0.08),
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: doctor.profileImage != null
                    ? ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                  child: Image.network(
                    doctor.profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return const Icon(
                        Icons
                            .person_rounded,
                        size: 45,
                        color: AppTheme
                            .primaryColor,
                      );
                    },
                  ),
                )
                    : const Icon(
                  Icons.person_rounded,
                  size: 45,
                  color:
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              AppTheme.textColor,
                            ),
                          ),
                        ),
                        if (doctor.verified)
                          const Icon(
                            Icons
                                .verified_rounded,
                            size: 18,
                            color: AppTheme
                                .secondaryColor,
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        fontSize: 13,
                        color:
                        AppTheme.primaryColor,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 17,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctor.rating
                              .toStringAsFixed(1),
                          style:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${doctor.reviewCount})',
                          style:
                          const TextStyle(
                            fontSize: 12,
                            color: AppTheme
                                .secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.work_outline_rounded,
                size: 17,
                color:
                AppTheme.secondaryTextColor,
              ),
              const SizedBox(width: 6),
              Text(
                '${doctor.experienceYears} years',
                style: const TextStyle(
                  fontSize: 12,
                  color:
                  AppTheme.secondaryTextColor,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color:
                AppTheme.secondaryTextColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  doctor.location,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color:
                    AppTheme.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 13),
          Row(
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 18,
                color:
                AppTheme.secondaryTextColor,
              ),
              const SizedBox(width: 2),
              Text(
                doctor.consultationFee
                    .toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const Text(
                ' / consultation',
                style: TextStyle(
                  fontSize: 12,
                  color:
                  AppTheme.secondaryTextColor,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: onViewDetails,
                style:
                OutlinedButton.styleFrom(
                  minimumSize:
                  const Size(0, 38),
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 12,
                  ),
                ),
                child: const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onBookNow,
                style:
                ElevatedButton.styleFrom(
                  minimumSize:
                  const Size(0, 38),
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 14,
                  ),
                ),
                child: const Text(
                  'Book',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// APPOINTMENT INFO
// ======================================================

class _AppointmentInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AppointmentInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color:
          Colors.white.withOpacity(0.9),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color:
            Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}