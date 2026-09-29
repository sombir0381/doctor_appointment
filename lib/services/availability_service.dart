import '../models/availability.dart';

class AvailabilityService {
  static final List<Availability> _availabilityList = [
    Availability(
      id: 'availability_001',
      doctorId: 'doctor_001',
      dayOfWeek: 'Monday',
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),
    Availability(
      id: 'availability_002',
      doctorId: 'doctor_001',
      dayOfWeek: 'Tuesday',
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),
    Availability(
      id: 'availability_003',
      doctorId: 'doctor_001',
      dayOfWeek: 'Wednesday',
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),
    Availability(
      id: 'availability_004',
      doctorId: 'doctor_001',
      dayOfWeek: 'Thursday',
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),
    Availability(
      id: 'availability_005',
      doctorId: 'doctor_001',
      dayOfWeek: 'Friday',
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),
    Availability(
      id: 'availability_006',
      doctorId: 'doctor_001',
      dayOfWeek: 'Saturday',
      startTime: '10:00 AM',
      endTime: '02:00 PM',
      slotDuration: 30,
      isAvailable: false,
    ),
    Availability(
      id: 'availability_007',
      doctorId: 'doctor_001',
      dayOfWeek: 'Sunday',
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: false,
    ),
  ];

  // =========================================================
  // GET ALL AVAILABILITY FOR DOCTOR
  // =========================================================

  static List<Availability> getDoctorAvailability(
      String doctorId,
      ) {
    return _availabilityList
        .where(
          (availability) =>
      availability.doctorId == doctorId,
    )
        .toList();
  }

  // =========================================================
  // GET AVAILABILITY FOR SPECIFIC DAY
  // =========================================================

  static Availability? getAvailabilityForDay({
    required String doctorId,
    required String dayOfWeek,
  }) {
    for (final Availability availability
    in _availabilityList) {
      if (availability.doctorId == doctorId &&
          availability.dayOfWeek.toLowerCase() ==
              dayOfWeek.toLowerCase()) {
        return availability;
      }
    }

    return null;
  }

  // =========================================================
  // SAVE AVAILABILITY
  // =========================================================

  static void saveAvailability(
      Availability availability,
      ) {
    final int index =
    _availabilityList.indexWhere(
          (item) => item.id == availability.id,
    );

    if (index == -1) {
      _availabilityList.add(
        availability,
      );
    } else {
      _availabilityList[index] =
          availability;
    }
  }

  // =========================================================
  // ADD AVAILABILITY
  // =========================================================

  static void addAvailability(
      Availability availability,
      ) {
    saveAvailability(
      availability,
    );
  }

  // =========================================================
  // SAVE OR UPDATE BY DOCTOR + DAY
  // =========================================================

  static void saveOrUpdateAvailability(
      Availability availability,
      ) {
    final int index =
    _availabilityList.indexWhere(
          (item) =>
      item.doctorId ==
          availability.doctorId &&
          item.dayOfWeek.toLowerCase() ==
              availability.dayOfWeek
                  .toLowerCase(),
    );

    if (index == -1) {
      _availabilityList.add(
        availability,
      );
    } else {
      _availabilityList[index] =
          availability;
    }
  }

  // =========================================================
  // UPDATE AVAILABILITY
  //
  // This method matches the
  // DoctorAvailabilityScreen exactly.
  // =========================================================

  static bool updateAvailability({
    required String availabilityId,
    required String startTime,
    required String endTime,
    required int slotDuration,
    required bool isAvailable,
  }) {
    final int index =
    _availabilityList.indexWhere(
          (availability) =>
      availability.id ==
          availabilityId,
    );

    if (index == -1) {
      return false;
    }

    final Availability oldAvailability =
    _availabilityList[index];

    _availabilityList[index] =
        Availability(
          id: oldAvailability.id,
          doctorId: oldAvailability.doctorId,
          dayOfWeek: oldAvailability.dayOfWeek,
          date: oldAvailability.date,
          startTime: startTime,
          endTime: endTime,
          slotDuration: slotDuration,
          isAvailable: isAvailable,
        );

    return true;
  }

  // =========================================================
  // GET AVAILABLE TIME SLOTS
  // =========================================================

  static List<String> getAvailableTimeSlots({
    required String doctorId,
    required DateTime date,
  }) {
    final String dayOfWeek =
    _getDayName(date.weekday);

    final Availability? availability =
    getAvailabilityForDay(
      doctorId: doctorId,
      dayOfWeek: dayOfWeek,
    );

    if (availability == null ||
        !availability.isAvailable) {
      return [];
    }

    final int startMinutes =
    _timeToMinutes(
      availability.startTime,
    );

    final int endMinutes =
    _timeToMinutes(
      availability.endTime,
    );

    final List<String> slots = [];

    int currentMinutes =
        startMinutes;

    while (
    currentMinutes +
        availability.slotDuration <=
        endMinutes) {
      slots.add(
        _minutesToTime(
          currentMinutes,
        ),
      );

      currentMinutes +=
          availability.slotDuration;
    }

    return slots;
  }

  // =========================================================
  // DAY NAME
  // =========================================================

  static String _getDayName(
      int weekday,
      ) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';

      case DateTime.tuesday:
        return 'Tuesday';

      case DateTime.wednesday:
        return 'Wednesday';

      case DateTime.thursday:
        return 'Thursday';

      case DateTime.friday:
        return 'Friday';

      case DateTime.saturday:
        return 'Saturday';

      case DateTime.sunday:
        return 'Sunday';

      default:
        return 'Monday';
    }
  }

  // =========================================================
  // TIME TO MINUTES
  // =========================================================

  static int _timeToMinutes(
      String time,
      ) {
    final List<String> parts =
    time.trim().split(' ');

    if (parts.length != 2) {
      return 0;
    }

    final List<String> hourMinute =
    parts[0].split(':');

    if (hourMinute.length != 2) {
      return 0;
    }

    int hour =
        int.tryParse(hourMinute[0]) ?? 0;

    final int minute =
        int.tryParse(hourMinute[1]) ?? 0;

    final String period =
    parts[1].toUpperCase();

    if (period == 'PM' &&
        hour != 12) {
      hour += 12;
    }

    if (period == 'AM' &&
        hour == 12) {
      hour = 0;
    }

    return (hour * 60) + minute;
  }

  // =========================================================
  // MINUTES TO TIME
  // =========================================================

  static String _minutesToTime(
      int totalMinutes,
      ) {
    int hour =
        totalMinutes ~/ 60;

    final int minute =
        totalMinutes % 60;

    final String period =
    hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')} '
        '$period';
  }
}