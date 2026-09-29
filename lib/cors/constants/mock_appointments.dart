import '../../models/appointment.dart';

class MockAppointments {
  static final List<Appointment> appointments = [
    // ============================================================
    // PATIENT 001 - PENDING
    // ============================================================

    Appointment(
      id: 'appointment_001',
      patientId: 'patient_001',
      doctorId: 'doctor_001',
      date: DateTime(2026, 10, 5),
      time: '10:00 AM',
      consultationType: 'Clinic',
      reason: 'Regular heart health consultation',
      status: 'pending',
      createdAt: DateTime(2026, 9, 27),
    ),

    // ============================================================
    // PATIENT 001 - CONFIRMED
    // ============================================================

    Appointment(
      id: 'appointment_002',
      patientId: 'patient_001',
      doctorId: 'doctor_002',
      date: DateTime(2026, 10, 7),
      time: '11:00 AM',
      consultationType: 'Video',
      reason: 'Skin consultation',
      status: 'confirmed',
      createdAt: DateTime(2026, 9, 25),
    ),

    // ============================================================
    // PATIENT 001 - COMPLETED
    // ============================================================

    Appointment(
      id: 'appointment_003',
      patientId: 'patient_001',
      doctorId: 'doctor_003',
      date: DateTime(2026, 9, 15),
      time: '10:30 AM',
      consultationType: 'Clinic',
      reason: 'Child health consultation',
      status: 'completed',
      createdAt: DateTime(2026, 9, 10),
      updatedAt: DateTime(2026, 9, 15),
    ),

    // ============================================================
    // PATIENT 001 - CANCELLED
    // ============================================================

    Appointment(
      id: 'appointment_004',
      patientId: 'patient_001',
      doctorId: 'doctor_004',
      date: DateTime(2026, 9, 20),
      time: '04:00 PM',
      consultationType: 'Clinic',
      reason: 'Back pain consultation',
      status: 'cancelled',
      createdAt: DateTime(2026, 9, 12),
      updatedAt: DateTime(2026, 9, 18),
    ),

    // ============================================================
    // PATIENT 001 - RESCHEDULED
    // ============================================================

    Appointment(
      id: 'appointment_005',
      patientId: 'patient_001',
      doctorId: 'doctor_005',
      date: DateTime(2026, 10, 10),
      time: '05:00 PM',
      consultationType: 'Video',
      reason: 'General consultation',
      status: 'rescheduled',
      createdAt: DateTime(2026, 9, 20),
      updatedAt: DateTime(2026, 9, 26),
    ),

    // ============================================================
    // PATIENT 002 - PENDING
    // ============================================================

    Appointment(
      id: 'appointment_006',
      patientId: 'patient_002',
      doctorId: 'doctor_001',
      date: DateTime(2026, 10, 6),
      time: '11:00 AM',
      consultationType: 'Video',
      reason: 'Cardiology follow-up',
      status: 'pending',
      createdAt: DateTime(2026, 9, 27),
    ),

    // ============================================================
    // PATIENT 002 - CONFIRMED
    // ============================================================

    Appointment(
      id: 'appointment_007',
      patientId: 'patient_002',
      doctorId: 'doctor_006',
      date: DateTime(2026, 10, 8),
      time: '10:30 AM',
      consultationType: 'Clinic',
      reason: 'Neurology consultation',
      status: 'confirmed',
      createdAt: DateTime(2026, 9, 24),
      updatedAt: DateTime(2026, 9, 25),
    ),

    // ============================================================
    // PATIENT 003 - COMPLETED
    // ============================================================

    Appointment(
      id: 'appointment_008',
      patientId: 'patient_003',
      doctorId: 'doctor_007',
      date: DateTime(2026, 9, 12),
      time: '09:30 AM',
      consultationType: 'Clinic',
      reason: 'General health checkup',
      status: 'completed',
      createdAt: DateTime(2026, 9, 5),
      updatedAt: DateTime(2026, 9, 12),
    ),

    // ============================================================
    // PATIENT 003 - REJECTED
    // ============================================================

    Appointment(
      id: 'appointment_009',
      patientId: 'patient_003',
      doctorId: 'doctor_008',
      date: DateTime(2026, 9, 28),
      time: '04:00 PM',
      consultationType: 'Clinic',
      reason: 'ENT consultation',
      status: 'rejected',
      createdAt: DateTime(2026, 9, 22),
      updatedAt: DateTime(2026, 9, 24),
    ),
  ];
}