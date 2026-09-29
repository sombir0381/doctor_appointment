import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({
    super.key,
  });

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState
    extends State<DoctorAppointmentsScreen> {
  // Mock logged-in doctor.
  // Backend connect hone par actual doctor ID
  // authentication/session se aayegi.
  final String doctorId = 'doctor_001';

  int selectedFilter = 0;

  final List<String> filters = [
    'All',
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
  ];

  List<Appointment> get doctorAppointments {
    return AppointmentService.appointments
        .where(
          (appointment) =>
      appointment.doctorId == doctorId,
    )
        .toList();
  }

  List<Appointment> get filteredAppointments {
    final List<Appointment> appointments =
        doctorAppointments;

    switch (selectedFilter) {
      case 1:
        return appointments
            .where(
              (appointment) =>
          appointment.status == 'pending',
        )
            .toList();

      case 2:
        return appointments
            .where(
              (appointment) =>
          appointment.status == 'confirmed',
        )
            .toList();

      case 3:
        return appointments
            .where(
              (appointment) =>
          appointment.status == 'completed',
        )
            .toList();

      case 4:
        return appointments
            .where(
              (appointment) =>
          appointment.status == 'cancelled' ||
              appointment.status == 'rejected',
        )
            .toList();

      default:
        return appointments;
    }
  }

  int get pendingCount {
    return doctorAppointments
        .where(
          (appointment) =>
      appointment.status == 'pending',
    )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final List<Appointment> appointments =
        filteredAppointments;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            _buildSummaryHeader(),

            const SizedBox(height: 10),

            _buildFilterBar(),

            const SizedBox(height: 8),

            Expanded(
              child: appointments.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                physics:
                const AlwaysScrollableScrollPhysics(),
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  30,
                ),
                itemCount:
                appointments.length,
                separatorBuilder:
                    (context, index) {
                  return const SizedBox(
                    height: 14,
                  );
                },
                itemBuilder:
                    (context, index) {
                  return _buildAppointmentCard(
                    appointments[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        0,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor
                  .withOpacity(0.08),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appointment Requests',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$pendingCount pending request${pendingCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          if (pendingCount > 0)
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.orange
                    .withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                '$pendingCount Pending',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final bool isSelected =
              selectedFilter == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = index;
              });
            },
            child: AnimatedContainer(
              duration:
              const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : Colors.white,
                borderRadius:
                BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.grey.shade200,
                ),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppTheme.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      Appointment appointment,
      ) {
    final Color statusColor =
    _statusColor(appointment.status);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor
                      .withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color:
                  AppTheme.primaryColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      _patientName(
                        appointment.patientId,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Patient ID: ${appointment.patientId}',
                      style: TextStyle(
                        fontSize: 11,
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

          const SizedBox(height: 16),

          const Divider(height: 1),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _infoItem(
                  icon:
                  Icons.calendar_today_outlined,
                  title: 'Date',
                  value:
                  _formatDate(appointment.date),
                ),
              ),

              Expanded(
                child: _infoItem(
                  icon:
                  Icons.access_time_rounded,
                  title: 'Time',
                  value:
                  appointment.time,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _infoItem(
            icon:
            Icons.medical_services_outlined,
            title: 'Consultation',
            value:
            appointment.consultationType,
          ),

          if (appointment.reason != null &&
              appointment.reason!
                  .trim()
                  .isNotEmpty) ...[
            const SizedBox(height: 14),

            _infoItem(
              icon:
              Icons.notes_rounded,
              title: 'Reason',
              value:
              appointment.reason!,
            ),
          ],

          if (appointment.status == 'pending') ...[
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showRejectConfirmation(
                        appointment,
                      );
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                    ),
                    label: const Text(
                      'Reject',
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updateStatus(
                        appointment,
                        'confirmed',
                      );
                    },
                    icon: const Icon(
                      Icons.check_rounded,
                      size: 18,
                    ),
                    label: const Text(
                      'Accept',
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.green,
                      foregroundColor:
                      Colors.white,
                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (appointment.status == 'confirmed') ...[
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCompleteConfirmation(
                    appointment,
                  );
                },
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 19,
                ),
                label: const Text(
                  'Mark as Completed',
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppTheme.primaryColor,
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.primaryColor,
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color:
                  AppTheme.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(
      String status,
      Color color,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
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
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String title = 'No Appointments';

    String message =
        'There are no appointments in this category.';

    if (selectedFilter == 1) {
      title = 'No Pending Requests';
      message =
      'New appointment requests will appear here.';
    } else if (selectedFilter == 2) {
      title = 'No Confirmed Appointments';
      message =
      'Accepted appointments will appear here.';
    } else if (selectedFilter == 3) {
      title = 'No Completed Appointments';
      message =
      'Completed appointments will appear here.';
    } else if (selectedFilter == 4) {
      title = 'No Cancelled Appointments';
      message =
      'Rejected or cancelled appointments will appear here.';
    }

    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height:
          MediaQuery.of(context).size.height *
              0.40,
          child: Center(
            child: Padding(
              padding:
              const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration:
                    BoxDecoration(
                      color: AppTheme
                          .primaryColor
                          .withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons
                          .event_available_rounded,
                      color:
                      AppTheme.primaryColor,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    title,
                    style:
                    const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    message,
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  void _updateStatus(
      Appointment appointment,
      String status,
      ) {
    final bool updated =
    AppointmentService.updateAppointmentStatus(
      appointmentId: appointment.id,
      status: status,
    );

    if (!updated) {
      _showMessage(
        'Unable to update appointment.',
      );
      return;
    }

    setState(() {});

    _showMessage(
      status == 'confirmed'
          ? 'Appointment accepted successfully.'
          : 'Appointment updated successfully.',
    );
  }

  void _showRejectConfirmation(
      Appointment appointment,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Reject Appointment?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to reject this appointment request?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                _updateStatus(
                  appointment,
                  'rejected',
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor:
                Colors.white,
              ),
              child: const Text(
                'Reject',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCompleteConfirmation(
      Appointment appointment,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Complete Appointment?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Mark this appointment as completed?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                _updateStatus(
                  appointment,
                  'completed',
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppTheme.primaryColor,
                foregroundColor:
                Colors.white,
              ),
              child: const Text(
                'Complete',
              ),
            ),
          ],
        );
      },
    );
  }

  String _patientName(
      String patientId,
      ) {
    if (patientId == 'patient_001') {
      return 'Sombir';
    }

    return 'Patient';
  }

  String _formatDate(
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatStatus(
      String status,
      ) {
    if (status.isEmpty) {
      return status;
    }

    return status[0].toUpperCase() +
        status.substring(1);
  }

  Color _statusColor(
      String status,
      ) {
    switch (status) {
      case 'pending':
        return Colors.orange;

      case 'confirmed':
        return Colors.green;

      case 'completed':
        return Colors.blue;

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

  void _showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}