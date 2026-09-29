import '../models/appointment.dart';

class AppointmentService {
  static final List<Appointment> appointments = [];

  // ============================================================
  // ADD APPOINTMENT
  // ============================================================

  static void addAppointment(
      Appointment appointment,
      ) {
    appointments.add(appointment);
  }

  // ============================================================
  // GET PATIENT APPOINTMENTS
  // ============================================================

  static List<Appointment> getPatientAppointments(
      String patientId,
      ) {
    return appointments
        .where(
          (appointment) =>
      appointment.patientId == patientId,
    )
        .toList();
  }

  // ============================================================
  // GET DOCTOR APPOINTMENTS
  // ============================================================

  static List<Appointment> getDoctorAppointments(
      String doctorId,
      ) {
    return appointments
        .where(
          (appointment) =>
      appointment.doctorId == doctorId,
    )
        .toList();
  }

  // ============================================================
  // GET APPOINTMENT BY ID
  // ============================================================

  static Appointment? getAppointmentById(
      String appointmentId,
      ) {
    for (final Appointment appointment in appointments) {
      if (appointment.id == appointmentId) {
        return appointment;
      }
    }

    return null;
  }

  // ============================================================
  // UPDATE APPOINTMENT STATUS
  // ============================================================

  static bool updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) {
    final int index = appointments.indexWhere(
          (appointment) =>
      appointment.id == appointmentId,
    );

    if (index == -1) {
      return false;
    }

    final Appointment oldAppointment =
    appointments[index];

    appointments[index] = Appointment(
      id: oldAppointment.id,
      patientId: oldAppointment.patientId,
      doctorId: oldAppointment.doctorId,
      date: oldAppointment.date,
      time: oldAppointment.time,
      consultationType:
      oldAppointment.consultationType,
      reason: oldAppointment.reason,
      status: status,
      createdAt: oldAppointment.createdAt,
      updatedAt: DateTime.now(),
    );

    return true;
  }

  // ============================================================
  // CANCEL APPOINTMENT
  // ============================================================

  static bool cancelAppointment(
      String appointmentId,
      ) {
    return updateAppointmentStatus(
      appointmentId: appointmentId,
      status: 'cancelled',
    );
  }

  // ============================================================
  // RESCHEDULE APPOINTMENT
  // ============================================================

  static bool rescheduleAppointment({
    required String appointmentId,
    required DateTime newDate,
    required String newTime,
  }) {
    final int index = appointments.indexWhere(
          (appointment) =>
      appointment.id == appointmentId,
    );

    if (index == -1) {
      return false;
    }

    final Appointment oldAppointment =
    appointments[index];

    appointments[index] = Appointment(
      id: oldAppointment.id,
      patientId: oldAppointment.patientId,
      doctorId: oldAppointment.doctorId,
      date: newDate,
      time: newTime,
      consultationType:
      oldAppointment.consultationType,
      reason: oldAppointment.reason,
      status: 'rescheduled',
      createdAt: oldAppointment.createdAt,
      updatedAt: DateTime.now(),
    );

    return true;
  }

  // ============================================================
  // CHECK WHETHER SLOT IS BOOKED
  // ============================================================

  static bool isSlotBooked({
    required String doctorId,
    required DateTime date,
    required String time,
    String? excludeAppointmentId,
  }) {
    return appointments.any(
          (appointment) {
        if (excludeAppointmentId != null &&
            appointment.id ==
                excludeAppointmentId) {
          return false;
        }

        final bool sameDoctor =
            appointment.doctorId == doctorId;

        final bool sameDate =
            appointment.date.year == date.year &&
                appointment.date.month ==
                    date.month &&
                appointment.date.day ==
                    date.day;

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
}