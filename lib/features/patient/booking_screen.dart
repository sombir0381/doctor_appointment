import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/doctor.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';
import '../../services/availability_service.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  String? selectedTime;
  String? selectedConsultationType;

  final TextEditingController reasonController =
  TextEditingController();

  // Available slots for selected date.
  List<String> availableTimeSlots = [];

  @override
  void initState() {
    super.initState();

    if (widget.doctor.consultationModes.isNotEmpty) {
      selectedConsultationType =
          widget.doctor.consultationModes.first;
    }
  }

  // =========================================================
  // LOAD AVAILABLE TIME SLOTS
  // =========================================================

  void loadAvailableTimeSlots() {
    if (selectedDate == null) {
      setState(() {
        availableTimeSlots = [];
        selectedTime = null;
      });
      return;
    }

    final List<String> serviceSlots =
    AvailabilityService.getAvailableTimeSlots(
      doctorId: widget.doctor.id,
      date: selectedDate!,
    );

    // Remove slots which are already booked.
    final List<String> freeSlots =
    serviceSlots.where(
          (time) {
        return !isTimeSlotAlreadyBooked(time);
      },
    ).toList();

    setState(() {
      availableTimeSlots = freeSlots;
      selectedTime = null;
    });
  }

  // =========================================================
  // SELECT DATE
  // =========================================================

  Future<void> selectDate() async {
    final DateTime today = DateTime.now();

    final DateTime? pickedDate =
    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: today,
      lastDate: today.add(
        const Duration(days: 30),
      ),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      selectedDate = pickedDate;
      selectedTime = null;
    });

    loadAvailableTimeSlots();
  }

  // =========================================================
  // CHECK DOUBLE BOOKING
  // =========================================================

  bool isTimeSlotAlreadyBooked(
      String time,
      ) {
    if (selectedDate == null) {
      return false;
    }

    return AppointmentService.appointments.any(
          (appointment) {
        final bool sameDoctor =
            appointment.doctorId ==
                widget.doctor.id;

        final bool sameDate =
            appointment.date.year ==
                selectedDate!.year &&
                appointment.date.month ==
                    selectedDate!.month &&
                appointment.date.day ==
                    selectedDate!.day;

        final bool sameTime =
            appointment.time == time;

        final bool activeAppointment =
            appointment.status != 'cancelled' &&
                appointment.status != 'rejected';

        return sameDoctor &&
            sameDate &&
            sameTime &&
            activeAppointment;
      },
    );
  }

  // =========================================================
  // CHECK IF SELECTED DATE HAS AVAILABILITY
  // =========================================================

  bool hasAvailabilityForSelectedDate() {
    if (selectedDate == null) {
      return false;
    }

    final List<String> slots =
    AvailabilityService.getAvailableTimeSlots(
      doctorId: widget.doctor.id,
      date: selectedDate!,
    );

    return slots.isNotEmpty;
  }

  // =========================================================
  // CONFIRM BOOKING
  // =========================================================

  void confirmBooking() {
    // =======================================================
    // DATE VALIDATION
    // =======================================================

    if (selectedDate == null) {
      showMessage(
        'Please select a date.',
      );
      return;
    }

    // =======================================================
    // AVAILABILITY VALIDATION
    // =======================================================

    final List<String> serviceSlots =
    AvailabilityService.getAvailableTimeSlots(
      doctorId: widget.doctor.id,
      date: selectedDate!,
    );

    if (serviceSlots.isEmpty) {
      showMessage(
        'Doctor is not available on this date.',
      );
      return;
    }

    // =======================================================
    // TIME VALIDATION
    // =======================================================

    if (selectedTime == null) {
      showMessage(
        'Please select a time slot.',
      );
      return;
    }

    // =======================================================
    // MAKE SURE SELECTED SLOT IS ACTUALLY AVAILABLE
    // =======================================================

    if (!serviceSlots.contains(selectedTime)) {
      showMessage(
        'Selected time slot is not available.',
      );
      return;
    }

    // =======================================================
    // DOUBLE BOOKING CHECK
    // =======================================================

    final bool alreadyBooked =
    isTimeSlotAlreadyBooked(
      selectedTime!,
    );

    if (alreadyBooked) {
      showMessage(
        'This time slot is already booked. Please select another time.',
      );

      loadAvailableTimeSlots();
      return;
    }

    // =======================================================
    // CONSULTATION TYPE VALIDATION
    // =======================================================

    if (selectedConsultationType == null) {
      showMessage(
        'Please select consultation type.',
      );
      return;
    }

    // =======================================================
    // REASON VALIDATION
    // =======================================================

    if (reasonController.text.trim().isEmpty) {
      showMessage(
        'Please enter the reason for consultation.',
      );
      return;
    }

    // =======================================================
    // CREATE APPOINTMENT
    // =======================================================

    final Appointment appointment =
    Appointment(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      patientId: 'patient_001',
      doctorId: widget.doctor.id,
      date: selectedDate!,
      time: selectedTime!,
      consultationType:
      selectedConsultationType!,
      reason: reasonController.text.trim(),
      status: 'pending',
      createdAt: DateTime.now(),
    );

    // =======================================================
    // SAVE APPOINTMENT
    // =======================================================

    AppointmentService.addAppointment(
      appointment,
    );

    // =======================================================
    // SHOW SUCCESS DIALOG
    // =======================================================

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Booking Confirmed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Your appointment with ${widget.doctor.name} has been booked successfully.',
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // SHOW MESSAGE
  // =========================================================

  void showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          behavior:
          SnackBarBehavior.floating,
          margin:
          const EdgeInsets.all(16),
        ),
      );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      backgroundColor:
      AppTheme.backgroundColor,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontWeight:
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =================================================
            // DOCTOR INFORMATION
            // =================================================

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(16),
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color:
                  const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration:
                    BoxDecoration(
                      color: AppTheme
                          .primaryColor
                          .withOpacity(
                        0.1,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 34,
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
                        Text(
                          widget.doctor.name,
                          style:
                          const TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight
                                .bold,
                            color: AppTheme
                                .textColor,
                          ),
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
                        Text(
                          '₹${widget.doctor.consultationFee.toStringAsFixed(0)} consultation',
                          style:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight
                                .w600,
                            color: AppTheme
                                .primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            // =================================================
            // SELECT DATE
            // =================================================

            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                AppTheme.textColor,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            GestureDetector(
              onTap: selectDate,
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                  border: Border.all(
                    color: const Color(
                      0xFFE5E7EB,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .calendar_month_outlined,
                      color: AppTheme
                          .primaryColor,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        selectedDate ==
                            null
                            ? 'Choose appointment date'
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        style:
                        TextStyle(
                          fontSize: 15,
                          color: selectedDate ==
                              null
                              ? AppTheme
                              .secondaryTextColor
                              : AppTheme
                              .textColor,
                          fontWeight:
                          selectedDate ==
                              null
                              ? FontWeight
                              .normal
                              : FontWeight
                              .w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            // =================================================
            // SELECT TIME
            // =================================================

            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                AppTheme.textColor,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (selectedDate == null)
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(
                  18,
                ),
                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                  border: Border.all(
                    color: const Color(
                      0xFFE5E7EB,
                    ),
                  ),
                ),
                child: const Text(
                  'Please select a date first.',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    color: AppTheme
                        .secondaryTextColor,
                  ),
                ),
              )
            else if (!hasAvailabilityForSelectedDate())
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(
                  18,
                ),
                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                  border: Border.all(
                    color: const Color(
                      0xFFE5E7EB,
                    ),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons
                          .event_busy_outlined,
                      size: 32,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Doctor is not available on this date.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        color: AppTheme
                            .secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              )
            else if (availableTimeSlots.isEmpty)
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    18,
                  ),
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                    border: Border.all(
                      color: const Color(
                        0xFFE5E7EB,
                      ),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons
                            .event_busy_outlined,
                        size: 32,
                        color: AppTheme
                            .secondaryTextColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'All available slots are booked.',
                        textAlign:
                        TextAlign.center,
                        style: TextStyle(
                          color: AppTheme
                              .secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                  availableTimeSlots.map(
                        (time) {
                      final bool
                      isSelected =
                          selectedTime ==
                              time;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTime =
                                time;
                          });
                        },
                        child:
                        AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds:
                            180,
                          ),
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration:
                          BoxDecoration(
                            color: isSelected
                                ? AppTheme
                                .primaryColor
                                : Colors
                                .white,
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                            border:
                            Border.all(
                              color: isSelected
                                  ? AppTheme
                                  .primaryColor
                                  : const Color(
                                0xFFE5E7EB,
                              ),
                            ),
                          ),
                          child: Text(
                            time,
                            style:
                            TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight
                                  .w600,
                              color: isSelected
                                  ? Colors
                                  .white
                                  : AppTheme
                                  .textColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),

            const SizedBox(
              height: 26,
            ),

            // =================================================
            // CONSULTATION TYPE
            // =================================================

            const Text(
              'Consultation Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                AppTheme.textColor,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (widget.doctor
                .consultationModes
                .isEmpty)
              const Text(
                'No consultation mode available.',
                style: TextStyle(
                  color: AppTheme
                      .secondaryTextColor,
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.doctor
                    .consultationModes
                    .map(
                      (mode) {
                    final bool
                    isSelected =
                        selectedConsultationType ==
                            mode;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedConsultationType =
                              mode;
                        });
                      },
                      child: Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration:
                        BoxDecoration(
                          color: isSelected
                              ? AppTheme
                              .primaryColor
                              : Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            12,
                          ),
                          border:
                          Border.all(
                            color: isSelected
                                ? AppTheme
                                .primaryColor
                                : const Color(
                              0xFFE5E7EB,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            Icon(
                              mode
                                  .toLowerCase()
                                  .contains(
                                'online',
                              )
                                  ? Icons
                                  .video_call_outlined
                                  : Icons
                                  .local_hospital_outlined,
                              size: 18,
                              color: isSelected
                                  ? Colors
                                  .white
                                  : AppTheme
                                  .primaryColor,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              mode,
                              style:
                              TextStyle(
                                fontSize: 14,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color: isSelected
                                    ? Colors
                                    .white
                                    : AppTheme
                                    .textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),

            const SizedBox(
              height: 26,
            ),

            // =================================================
            // REASON
            // =================================================

            const Text(
              'Reason for Consultation',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
                color:
                AppTheme.textColor,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
              reasonController,
              maxLines: 4,
              decoration:
              const InputDecoration(
                hintText:
                'Describe your problem or reason...',
                alignLabelWithHint:
                true,
                prefixIcon: Padding(
                  padding:
                  EdgeInsets.only(
                    bottom: 65,
                  ),
                  child: Icon(
                    Icons
                        .edit_note_outlined,
                    color: AppTheme
                        .primaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // =================================================
            // CONFIRM BUTTON
            // =================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child:
              ElevatedButton.icon(
                onPressed:
                confirmBooking,
                icon: const Icon(
                  Icons
                      .check_circle_outline,
                ),
                label: const Text(
                  'Confirm Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}