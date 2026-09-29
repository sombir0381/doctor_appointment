import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../services/appointment_service.dart';
import '../../services/availability_service.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;
  final Doctor doctor;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState
    extends State<AppointmentDetailsScreen> {
  late String currentStatus;
  late DateTime currentDate;
  late String currentTime;

  @override
  void initState() {
    super.initState();

    currentStatus =
        widget.appointment.status;

    currentDate =
        widget.appointment.date;

    currentTime =
        widget.appointment.time;
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String formatDate(DateTime date) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  String getStatusText() {
    switch (currentStatus.toLowerCase()) {
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

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color getStatusColor() {
    switch (currentStatus.toLowerCase()) {
      case 'confirmed':
        return Colors.green;

      case 'completed':
        return Colors.blue;

      case 'cancelled':
      case 'rejected':
        return Colors.red;

      case 'rescheduled':
        return Colors.orange;

      case 'pending':
      default:
        return Colors.orange;
    }
  }

  // ============================================================
  // CAN CANCEL?
  // ============================================================

  bool get canCancel {
    final String status =
    currentStatus.toLowerCase();

    return status == 'pending' ||
        status == 'confirmed' ||
        status == 'rescheduled';
  }

  // ============================================================
  // CAN RESCHEDULE?
  // ============================================================

  bool get canReschedule {
    final String status =
    currentStatus.toLowerCase();

    return status == 'pending' ||
        status == 'confirmed' ||
        status == 'rescheduled';
  }

  // ============================================================
  // CANCEL APPOINTMENT
  // ============================================================

  Future<void> cancelAppointment() async {
    final bool? shouldCancel =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Cancel Appointment?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Yes, Cancel',
              ),
            ),
          ],
        );
      },
    );

    if (shouldCancel != true) {
      return;
    }

    final bool success =
    AppointmentService.cancelAppointment(
      widget.appointment.id,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      setState(() {
        currentStatus = 'cancelled';
      });

      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Appointment cancelled successfully.',
          ),
          backgroundColor: Colors.green,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to cancel appointment.',
          ),
          backgroundColor: Colors.red,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // RESCHEDULE APPOINTMENT
  // ============================================================

  Future<void> rescheduleAppointment() async {
    final DateTime today =
    DateTime.now();

    DateTime initialDate =
        currentDate;

    if (initialDate.isBefore(
      DateTime(
        today.year,
        today.month,
        today.day,
      ),
    )) {
      initialDate = today;
    }

    // ----------------------------------------------------------
    // SELECT DATE
    // ----------------------------------------------------------

    final DateTime? pickedDate =
    await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: today.add(
        const Duration(days: 30),
      ),
    );

    if (pickedDate == null) {
      return;
    }

    // ----------------------------------------------------------
    // GET DOCTOR AVAILABLE SLOTS
    // ----------------------------------------------------------

    final List<String> availableSlots =
    AvailabilityService
        .getAvailableTimeSlots(
      doctorId: widget.doctor.id,
      date: pickedDate,
    );

    // ----------------------------------------------------------
    // REMOVE ALREADY BOOKED SLOTS
    // ----------------------------------------------------------

    final List<String> freeSlots =
    availableSlots.where(
          (String time) {
        return !AppointmentService.isSlotBooked(
          doctorId: widget.doctor.id,
          date: pickedDate,
          time: time,
          excludeAppointmentId:
          widget.appointment.id,
        );
      },
    ).toList();

    // ----------------------------------------------------------
    // NO SLOTS
    // ----------------------------------------------------------

    if (freeSlots.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'No available slots on this date.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );

      return;
    }

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // SELECT NEW TIME
    // ----------------------------------------------------------

    final String? selectedSlot =
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              22,
              20,
              30,
            ),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration:
                      BoxDecoration(
                        color: AppTheme
                            .primaryColor
                            .withOpacity(
                          0.10,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                      ),
                      child: const Icon(
                        Icons
                            .access_time_rounded,
                        color: AppTheme
                            .primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Expanded(
                      child: Text(
                        'Select New Time',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  formatDate(pickedDate),
                  style: const TextStyle(
                    color: AppTheme
                        .secondaryTextColor,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                  freeSlots.map(
                        (String time) {
                      return InkWell(
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                            time,
                          );
                        },
                        child:
                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration:
                          BoxDecoration(
                            color: Colors
                                .white,
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                            border:
                            Border.all(
                              color: AppTheme
                                  .primaryColor,
                            ),
                          ),
                          child: Text(
                            time,
                            style:
                            const TextStyle(
                              color: AppTheme
                                  .primaryColor,
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedSlot == null) {
      return;
    }

    // ----------------------------------------------------------
    // CHECK SLOT AGAIN
    // ----------------------------------------------------------

    final bool slotAlreadyBooked =
    AppointmentService.isSlotBooked(
      doctorId: widget.doctor.id,
      date: pickedDate,
      time: selectedSlot,
      excludeAppointmentId:
      widget.appointment.id,
    );

    if (slotAlreadyBooked) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'This slot is already booked. Please choose another slot.',
          ),
          backgroundColor: Colors.red,
          behavior:
          SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // CONFIRM RESCHEDULE
    // ----------------------------------------------------------

    final bool? confirm =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Confirm Reschedule',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Move your appointment to '
                '${formatDate(pickedDate)} at $selectedSlot?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Confirm',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    // ----------------------------------------------------------
    // UPDATE APPOINTMENT
    // ----------------------------------------------------------

    final bool success =
    AppointmentService
        .rescheduleAppointment(
      appointmentId:
      widget.appointment.id,
      newDate: pickedDate,
      newTime: selectedSlot,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      setState(() {
        currentDate = pickedDate;
        currentTime = selectedSlot;
        currentStatus = 'rescheduled';
      });

      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Appointment rescheduled successfully.',
          ),
          backgroundColor: Colors.green,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to reschedule appointment.',
          ),
          backgroundColor: Colors.red,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Appointment Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =================================================
              // DOCTOR CARD
              // =================================================

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(18),
                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                  border: Border.all(
                    color:
                    Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.04),
                      blurRadius: 10,
                      offset:
                      const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration:
                      BoxDecoration(
                        color: AppTheme
                            .primaryColor
                            .withOpacity(
                          0.10,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child:
                      const Icon(
                        Icons
                            .person_rounded,
                        size: 40,
                        color: AppTheme
                            .primaryColor,
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.doctor
                                      .name,
                                  style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ),

                              if (widget
                                  .doctor
                                  .verified)
                                const Icon(
                                  Icons
                                      .verified_rounded,
                                  size: 20,
                                  color: AppTheme
                                      .primaryColor,
                                ),
                            ],
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            widget.doctor
                                .specialty,
                            style:
                            const TextStyle(
                              fontSize: 14,
                              color: AppTheme
                                  .secondaryTextColor,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .star_rounded,
                                size: 17,
                                color:
                                Colors.amber,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${widget.doctor.rating} (${widget.doctor.reviewCount})',
                                style:
                                const TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              // =================================================
              // STATUS
              // =================================================

              const Text(
                'Appointment Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration:
                BoxDecoration(
                  color: getStatusColor()
                      .withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color:
                      getStatusColor(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      getStatusText(),
                      style: TextStyle(
                        color:
                        getStatusColor(),
                        fontWeight:
                        FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              // =================================================
              // APPOINTMENT INFORMATION
              // =================================================

              const Text(
                'Appointment Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              _InfoCard(
                icon:
                Icons.calendar_month_rounded,
                title: 'Date',
                value:
                formatDate(currentDate),
              ),

              const SizedBox(
                height: 10,
              ),

              _InfoCard(
                icon:
                Icons.access_time_rounded,
                title: 'Time',
                value: currentTime,
              ),

              const SizedBox(
                height: 10,
              ),

              _InfoCard(
                icon: Icons
                    .medical_services_outlined,
                title: 'Consultation Type',
                value: widget.appointment
                    .consultationType,
              ),

              const SizedBox(
                height: 10,
              ),

              _InfoCard(
                icon: Icons
                    .location_on_outlined,
                title: 'Clinic',
                value:
                widget.doctor.clinicName,
              ),

              const SizedBox(
                height: 10,
              ),

              _InfoCard(
                icon:
                Icons.place_outlined,
                title: 'Location',
                value:
                widget.doctor.location,
              ),

              // =================================================
              // REASON
              // =================================================

              if (widget.appointment.reason !=
                  null &&
                  widget.appointment.reason!
                      .isNotEmpty) ...[
                const SizedBox(
                  height: 22,
                ),

                const Text(
                  'Reason / Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    AppTheme.backgroundColor,
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: Text(
                    widget.appointment
                        .reason!,
                    style:
                    const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                  ),
                ),
              ],

              const SizedBox(
                height: 30,
              ),

              // =================================================
              // RESCHEDULE BUTTON
              // =================================================

              if (canReschedule)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child:
                  OutlinedButton.icon(
                    onPressed:
                    rescheduleAppointment,
                    icon: const Icon(
                      Icons
                          .calendar_month_outlined,
                    ),
                    label: const Text(
                      'Reschedule Appointment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton
                        .styleFrom(
                      foregroundColor:
                      AppTheme
                          .primaryColor,
                      side:
                      const BorderSide(
                        color: AppTheme
                            .primaryColor,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

              if (canReschedule &&
                  canCancel)
                const SizedBox(
                  height: 12,
                ),

              // =================================================
              // CANCEL BUTTON
              // =================================================

              if (canCancel)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    cancelAppointment,
                    icon: const Icon(
                      Icons
                          .cancel_outlined,
                    ),
                    label: const Text(
                      'Cancel Appointment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      Colors.red,
                      foregroundColor:
                      Colors.white,
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

              // =================================================
              // CANCELLED MESSAGE
              // =================================================

              if (currentStatus
                  .toLowerCase() ==
                  'cancelled') ...[
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                  BoxDecoration(
                    color: Colors.red
                        .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                    border: Border.all(
                      color: Colors.red
                          .withOpacity(
                        0.20,
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons
                            .info_outline_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'This appointment has been cancelled.',
                          style: TextStyle(
                            color:
                            Colors.red,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // =================================================
              // COMPLETED MESSAGE
              // =================================================

              if (currentStatus
                  .toLowerCase() ==
                  'completed') ...[
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                  BoxDecoration(
                    color: AppTheme
                        .primaryColor
                        .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons
                            .check_circle_outline,
                        color: AppTheme
                            .primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'This appointment has been completed.',
                          style: TextStyle(
                            color: AppTheme
                                .primaryColor,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INFO CARD
// ============================================================

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
      width: double.infinity,
      padding:
      const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor
                  .withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
              AppTheme.primaryColor,
              size: 21,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                  const TextStyle(
                    fontSize: 12,
                    color: AppTheme
                        .secondaryTextColor,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
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