import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/availability.dart';
import '../../services/availability_service.dart';

class DoctorAvailabilityScreen extends StatefulWidget {
  const DoctorAvailabilityScreen({
    super.key,
  });

  @override
  State<DoctorAvailabilityScreen> createState() =>
      _DoctorAvailabilityScreenState();
}

class _DoctorAvailabilityScreenState
    extends State<DoctorAvailabilityScreen> {
  final String doctorId = 'doctor_001';

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late List<Availability> availabilityList;

  @override
  void initState() {
    super.initState();

    _loadAvailability();
  }

  // =========================================================
  // LOAD AVAILABILITY FROM SERVICE
  // =========================================================

  void _loadAvailability() {
    availabilityList =
        AvailabilityService.getDoctorAvailability(
          doctorId,
        );
  }

  // =========================================================
  // GET AVAILABILITY FOR DAY
  // =========================================================

  Availability _getAvailability(String day) {
    final Availability? availability =
    _findAvailability(day);

    if (availability != null) {
      return availability;
    }

    // Safety fallback.
    // Normally every day is already present in the service.
    return Availability(
      id: 'temporary_$day',
      doctorId: doctorId,
      dayOfWeek: day,
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      slotDuration: 30,
      isAvailable: false,
    );
  }

  Availability? _findAvailability(
      String day,
      ) {
    for (final availability in availabilityList) {
      if (availability.dayOfWeek.toLowerCase() ==
          day.toLowerCase()) {
        return availability;
      }
    }

    return null;
  }

  // =========================================================
  // TOGGLE AVAILABILITY
  // =========================================================

  void _toggleAvailability(
      Availability availability,
      bool value,
      ) {
    final bool success =
    AvailabilityService.updateAvailability(
      availabilityId: availability.id,
      startTime: availability.startTime,
      endTime: availability.endTime,
      slotDuration: availability.slotDuration,
      isAvailable: value,
    );

    if (!success) {
      _showMessage(
        'Unable to update availability.',
      );
      return;
    }

    setState(() {
      _loadAvailability();
    });

    _showMessage(
      value
          ? '${availability.dayOfWeek} availability enabled.'
          : '${availability.dayOfWeek} availability disabled.',
    );
  }

  // =========================================================
  // EDIT AVAILABILITY
  // =========================================================

  Future<void> _editAvailability(
      Availability availability,
      ) async {
    final TimeOfDay? initialStart =
    _parseTime(
      availability.startTime,
    );

    final TimeOfDay? initialEnd =
    _parseTime(
      availability.endTime,
    );

    final Map<String, dynamic>? result =
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return _AvailabilityDialog(
          day: availability.dayOfWeek,
          initialStartTime: initialStart,
          initialEndTime: initialEnd,
          initialDuration:
          availability.slotDuration,
        );
      },
    );

    if (result == null) {
      return;
    }

    final TimeOfDay newStart =
    result['startTime'] as TimeOfDay;

    final TimeOfDay newEnd =
    result['endTime'] as TimeOfDay;

    final int newDuration =
    result['duration'] as int;

    if (!_isValidTimeRange(
      newStart,
      newEnd,
    )) {
      _showMessage(
        'End time must be after start time.',
      );
      return;
    }

    final bool success =
    AvailabilityService.updateAvailability(
      availabilityId: availability.id,
      startTime: _formatTime(newStart),
      endTime: _formatTime(newEnd),
      slotDuration: newDuration,
      isAvailable: availability.isAvailable,
    );

    if (!success) {
      _showMessage(
        'Unable to update availability.',
      );
      return;
    }

    setState(() {
      _loadAvailability();
    });

    _showMessage(
      '${availability.dayOfWeek} availability updated.',
    );
  }

  // =========================================================
  // ADD AVAILABILITY
  // =========================================================

  Future<void> _addAvailability() async {
    final Map<String, dynamic>? result =
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return _AddAvailabilityDialog(
          days: days,
        );
      },
    );

    if (result == null) {
      return;
    }

    final String day =
    result['day'] as String;

    final TimeOfDay startTime =
    result['startTime'] as TimeOfDay;

    final TimeOfDay endTime =
    result['endTime'] as TimeOfDay;

    final int duration =
    result['duration'] as int;

    if (!_isValidTimeRange(
      startTime,
      endTime,
    )) {
      _showMessage(
        'End time must be after start time.',
      );
      return;
    }

    final Availability? existing =
    _findAvailability(day);

    final Availability newAvailability =
    Availability(
      id: existing?.id ??
          DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
      doctorId: doctorId,
      dayOfWeek: day,
      startTime: _formatTime(startTime),
      endTime: _formatTime(endTime),
      slotDuration: duration,
      isAvailable: true,
    );

    // Save into shared service.
    AvailabilityService.addAvailability(
      newAvailability,
    );

    setState(() {
      _loadAvailability();
    });

    _showMessage(
      '$day availability saved.',
    );
  }

  // =========================================================
  // SELECT START / END TIME
  // =========================================================

  Future<void> _selectTime({
    required Availability availability,
    required bool isStart,
  }) async {
    final TimeOfDay initialTime =
        _parseTime(
          isStart
              ? availability.startTime
              : availability.endTime,
        ) ??
            const TimeOfDay(
              hour: 9,
              minute: 0,
            );

    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked == null) {
      return;
    }

    final TimeOfDay? currentStart =
    _parseTime(
      availability.startTime,
    );

    final TimeOfDay? currentEnd =
    _parseTime(
      availability.endTime,
    );

    if (currentStart == null ||
        currentEnd == null) {
      return;
    }

    final TimeOfDay newStart =
    isStart ? picked : currentStart;

    final TimeOfDay newEnd =
    isStart ? currentEnd : picked;

    if (!_isValidTimeRange(
      newStart,
      newEnd,
    )) {
      _showMessage(
        'End time must be after start time.',
      );
      return;
    }

    final bool success =
    AvailabilityService.updateAvailability(
      availabilityId: availability.id,
      startTime: _formatTime(newStart),
      endTime: _formatTime(newEnd),
      slotDuration: availability.slotDuration,
      isAvailable: availability.isAvailable,
    );

    if (!success) {
      _showMessage(
        'Unable to update time.',
      );
      return;
    }

    setState(() {
      _loadAvailability();
    });

    _showMessage(
      '${availability.dayOfWeek} time updated.',
    );
  }

  // =========================================================
  // SELECT SLOT DURATION
  // =========================================================

  Future<void> _selectDuration(
      Availability availability,
      ) async {
    const List<int> durations = [
      15,
      20,
      30,
      45,
      60,
    ];

    final int? selected =
    await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Slot Duration',
          ),
          children: durations.map(
                (duration) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                    context,
                    duration,
                  );
                },
                child: Text(
                  '$duration minutes',
                ),
              );
            },
          ).toList(),
        );
      },
    );

    if (selected == null) {
      return;
    }

    final bool success =
    AvailabilityService.updateAvailability(
      availabilityId: availability.id,
      startTime: availability.startTime,
      endTime: availability.endTime,
      slotDuration: selected,
      isAvailable: availability.isAvailable,
    );

    if (!success) {
      _showMessage(
        'Unable to update slot duration.',
      );
      return;
    }

    setState(() {
      _loadAvailability();
    });

    _showMessage(
      '${availability.dayOfWeek} slot duration updated.',
    );
  }

  // =========================================================
  // VALIDATE TIME
  // =========================================================

  bool _isValidTimeRange(
      TimeOfDay start,
      TimeOfDay end,
      ) {
    final int startMinutes =
        start.hour * 60 + start.minute;

    final int endMinutes =
        end.hour * 60 + end.minute;

    return endMinutes > startMinutes;
  }

  // =========================================================
  // BUILD DAY CARD
  // =========================================================

  Widget _buildDayCard(
      String day,
      ) {
    final Availability availability =
    _getAvailability(day);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 13,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: availability.isAvailable
              ? AppTheme.primaryColor
              .withOpacity(0.12)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                  availability.isAvailable
                      ? AppTheme.primaryColor
                      .withOpacity(0.08)
                      : Colors.grey
                      .withOpacity(0.08),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color:
                  availability.isAvailable
                      ? AppTheme.primaryColor
                      : Colors.grey,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      availability.isAvailable
                          ? '${availability.startTime} - ${availability.endTime}'
                          : 'Not available',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                        availability.isAvailable
                            ? AppTheme
                            .secondaryTextColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Switch.adaptive(
                value:
                availability.isAvailable,
                onChanged: (value) {
                  _toggleAvailability(
                    availability,
                    value,
                  );
                },
              ),
            ],
          ),

          if (availability.isAvailable) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _settingItem(
                    icon:
                    Icons.login_rounded,
                    title: 'Start',
                    value:
                    availability.startTime,
                    onTap: () {
                      _selectTime(
                        availability:
                        availability,
                        isStart: true,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _settingItem(
                    icon:
                    Icons.logout_rounded,
                    title: 'End',
                    value:
                    availability.endTime,
                    onTap: () {
                      _selectTime(
                        availability:
                        availability,
                        isStart: false,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _settingItem(
                    icon:
                    Icons.timer_outlined,
                    title: 'Slot',
                    value:
                    '${availability.slotDuration} min',
                    onTap: () {
                      _selectDuration(
                        availability,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _editAvailability(
                    availability,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Edit Schedule',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // SETTING ITEM
  // =========================================================

  Widget _settingItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(13),
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius:
          BorderRadius.circular(13),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color:
                AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // INFO CARD
  // =========================================================

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        8,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor
            .withOpacity(0.07),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primaryColor
              .withOpacity(0.10),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppTheme.primaryColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Set your working hours and consultation slot duration. Patients will see available slots based on this schedule.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppTheme.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PARSE TIME
  // =========================================================

  TimeOfDay? _parseTime(
      String value,
      ) {
    try {
      final List<String> parts =
      value.split(' ');

      final String timePart =
      parts[0];

      final String period =
      parts.length > 1
          ? parts[1].toUpperCase()
          : 'AM';

      final List<String> time =
      timePart.split(':');

      int hour =
      int.parse(time[0]);

      final int minute =
      int.parse(time[1]);

      if (period == 'PM' &&
          hour != 12) {
        hour += 12;
      }

      if (period == 'AM' &&
          hour == 12) {
        hour = 0;
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    } catch (_) {
      return null;
    }
  }

  // =========================================================
  // FORMAT TIME
  // =========================================================

  String _formatTime(
      TimeOfDay time,
      ) {
    final int hour =
    time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final String minute =
    time.minute
        .toString()
        .padLeft(2, '0');

    final String period =
    time.period == DayPeriod.am
        ? 'AM'
        : 'PM';

    return '$hour:$minute $period';
  }

  // =========================================================
  // MESSAGE
  // =========================================================

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

      appBar: AppBar(
        title: const Text(
          'Availability',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Add Schedule',
            onPressed: _addAvailability,
            icon: const Icon(
              Icons.add_rounded,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          _buildInfoCard(),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                30,
              ),
              itemCount: days.length,
              itemBuilder:
                  (context, index) {
                return _buildDayCard(
                  days[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ADD AVAILABILITY DIALOG
// ============================================================

class _AddAvailabilityDialog
    extends StatefulWidget {
  final List<String> days;

  const _AddAvailabilityDialog({
    required this.days,
  });

  @override
  State<_AddAvailabilityDialog> createState() =>
      _AddAvailabilityDialogState();
}

class _AddAvailabilityDialogState
    extends State<_AddAvailabilityDialog> {
  late String selectedDay;

  TimeOfDay startTime =
  const TimeOfDay(
    hour: 9,
    minute: 0,
  );

  TimeOfDay endTime =
  const TimeOfDay(
    hour: 17,
    minute: 0,
  );

  int duration = 30;

  @override
  void initState() {
    super.initState();

    selectedDay =
        widget.days.first;
  }

  Future<void> _pickStartTime() async {
    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return AlertDialog(
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
      ),

      title: const Text(
        'Add Availability',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Day',
              style: TextStyle(
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 7),

            DropdownButtonFormField<String>(
              initialValue:
              selectedDay,
              decoration:
              const InputDecoration(),
              items:
              widget.days.map(
                    (day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDay =
                        value;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            _timeButton(
              title: 'Start Time',
              time: startTime,
              onTap:
              _pickStartTime,
            ),

            const SizedBox(height: 10),

            _timeButton(
              title: 'End Time',
              time: endTime,
              onTap:
              _pickEndTime,
            ),

            const SizedBox(height: 15),

            const Text(
              'Slot Duration',
              style: TextStyle(
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 7),

            DropdownButtonFormField<int>(
              initialValue:
              duration,
              items: const [
                DropdownMenuItem(
                  value: 15,
                  child:
                  Text('15 minutes'),
                ),
                DropdownMenuItem(
                  value: 20,
                  child:
                  Text('20 minutes'),
                ),
                DropdownMenuItem(
                  value: 30,
                  child:
                  Text('30 minutes'),
                ),
                DropdownMenuItem(
                  value: 45,
                  child:
                  Text('45 minutes'),
                ),
                DropdownMenuItem(
                  value: 60,
                  child:
                  Text('60 minutes'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    duration = value;
                  });
                }
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child:
          const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              {
                'day': selectedDay,
                'startTime':
                startTime,
                'endTime':
                endTime,
                'duration':
                duration,
              },
            );
          },
          child:
          const Text('Save'),
        ),
      ],
    );
  }

  Widget _timeButton({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        padding:
        const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color:
          AppTheme.backgroundColor,
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color:
              AppTheme.primaryColor,
              size: 20,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(title),
            ),

            Text(
              time.format(context),
              style: const TextStyle(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EDIT AVAILABILITY DIALOG
// ============================================================

class _AvailabilityDialog
    extends StatefulWidget {
  final String day;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final int initialDuration;

  const _AvailabilityDialog({
    required this.day,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.initialDuration,
  });

  @override
  State<_AvailabilityDialog> createState() =>
      _AvailabilityDialogState();
}

class _AvailabilityDialogState
    extends State<_AvailabilityDialog> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late int duration;

  @override
  void initState() {
    super.initState();

    startTime =
        widget.initialStartTime ??
            const TimeOfDay(
              hour: 9,
              minute: 0,
            );

    endTime =
        widget.initialEndTime ??
            const TimeOfDay(
              hour: 17,
              minute: 0,
            );

    duration =
        widget.initialDuration;
  }

  Future<void> _pickStart() async {
    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _pickEnd() async {
    final TimeOfDay? picked =
    await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return AlertDialog(
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
      ),

      title: Text(
        'Edit ${widget.day}',
        style: const TextStyle(
          fontWeight:
          FontWeight.w700,
        ),
      ),

      content: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          _timeButton(
            title: 'Start Time',
            time: startTime,
            onTap: _pickStart,
          ),

          const SizedBox(height: 10),

          _timeButton(
            title: 'End Time',
            time: endTime,
            onTap: _pickEnd,
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<int>(
            initialValue:
            duration,
            decoration:
            const InputDecoration(
              labelText:
              'Slot Duration',
            ),
            items: const [
              DropdownMenuItem(
                value: 15,
                child:
                Text('15 minutes'),
              ),
              DropdownMenuItem(
                value: 20,
                child:
                Text('20 minutes'),
              ),
              DropdownMenuItem(
                value: 30,
                child:
                Text('30 minutes'),
              ),
              DropdownMenuItem(
                value: 45,
                child:
                Text('45 minutes'),
              ),
              DropdownMenuItem(
                value: 60,
                child:
                Text('60 minutes'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  duration =
                      value;
                });
              }
            },
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child:
          const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              {
                'startTime':
                startTime,
                'endTime':
                endTime,
                'duration':
                duration,
              },
            );
          },
          child:
          const Text('Save'),
        ),
      ],
    );
  }

  Widget _timeButton({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        padding:
        const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color:
          AppTheme.backgroundColor,
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color:
              AppTheme.primaryColor,
              size: 20,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(title),
            ),

            Text(
              time.format(context),
              style: const TextStyle(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}