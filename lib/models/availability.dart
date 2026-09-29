class Availability {
  final String id;
  final String doctorId;
  final String dayOfWeek;
  final DateTime? date;
  final String startTime;
  final String endTime;
  final int slotDuration;
  final bool isAvailable;

  const Availability({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    this.date,
    required this.startTime,
    required this.endTime,
    required this.slotDuration,
    required this.isAvailable,
  });
}