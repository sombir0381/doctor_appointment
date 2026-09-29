class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final String time;
  final String consultationType;
  final String? reason;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.consultationType,
    this.reason,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
}