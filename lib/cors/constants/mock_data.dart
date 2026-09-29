import '../../models/doctor.dart';
import '../../models/availability.dart';

class MockData {
  // ============================================================
  // DOCTORS
  // ============================================================

  static const List<Doctor> doctors = [
    Doctor(
      id: 'doctor_001',
      userId: 'user_doctor_001',
      name: 'Dr. Sarah Khan',
      profileImage: null,
      specialty: 'Cardiologist',
      qualification: 'MBBS, MD Cardiology',
      experienceYears: 12,
      rating: 4.8,
      reviewCount: 128,
      clinicName: 'Heart Care Clinic',
      location: 'Ludhiana, Punjab',
      consultationFee: 800,
      about:
      'Dr. Sarah Khan is an experienced cardiologist specializing in heart health, preventive cardiology and cardiac care.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_002',
      userId: 'user_doctor_002',
      name: 'Dr. Rahul Sharma',
      profileImage: null,
      specialty: 'Dermatologist',
      qualification: 'MBBS, MD Dermatology',
      experienceYears: 9,
      rating: 4.7,
      reviewCount: 96,
      clinicName: 'Skin & Care Clinic',
      location: 'Ludhiana, Punjab',
      consultationFee: 600,
      about:
      'Dr. Rahul Sharma provides treatment for common skin, hair and cosmetic dermatology concerns.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_003',
      userId: 'user_doctor_003',
      name: 'Dr. Priya Mehta',
      profileImage: null,
      specialty: 'Pediatrician',
      qualification: 'MBBS, MD Pediatrics',
      experienceYears: 10,
      rating: 4.9,
      reviewCount: 154,
      clinicName: 'Little Care Hospital',
      location: 'Chandigarh, Punjab',
      consultationFee: 700,
      about:
      'Dr. Priya Mehta specializes in pediatric healthcare and provides medical care for infants, children and teenagers.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_004',
      userId: 'user_doctor_004',
      name: 'Dr. Arjun Verma',
      profileImage: null,
      specialty: 'Orthopedic',
      qualification: 'MBBS, MS Orthopedics',
      experienceYears: 14,
      rating: 4.6,
      reviewCount: 112,
      clinicName: 'Ortho Plus Clinic',
      location: 'Jalandhar, Punjab',
      consultationFee: 900,
      about:
      'Dr. Arjun Verma specializes in bone, joint, muscle and orthopedic conditions with a focus on patient recovery.',
      consultationModes: [
        'Clinic',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_005',
      userId: 'user_doctor_005',
      name: 'Dr. Neha Kapoor',
      profileImage: null,
      specialty: 'Gynecologist',
      qualification: 'MBBS, MS Gynecology',
      experienceYears: 11,
      rating: 4.8,
      reviewCount: 137,
      clinicName: 'Women Care Center',
      location: 'Amritsar, Punjab',
      consultationFee: 750,
      about:
      'Dr. Neha Kapoor provides comprehensive women healthcare, gynecological consultation and preventive care.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_006',
      userId: 'user_doctor_006',
      name: 'Dr. Aman Singh',
      profileImage: null,
      specialty: 'Neurologist',
      qualification: 'MBBS, MD Neurology',
      experienceYears: 15,
      rating: 4.7,
      reviewCount: 104,
      clinicName: 'Neuro Health Clinic',
      location: 'Patiala, Punjab',
      consultationFee: 1000,
      about:
      'Dr. Aman Singh specializes in neurological consultation and management of common neurological conditions.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_007',
      userId: 'user_doctor_007',
      name: 'Dr. Simran Kaur',
      profileImage: null,
      specialty: 'General Physician',
      qualification: 'MBBS, MD Medicine',
      experienceYears: 8,
      rating: 4.5,
      reviewCount: 82,
      clinicName: 'City Health Clinic',
      location: 'Ludhiana, Punjab',
      consultationFee: 500,
      about:
      'Dr. Simran Kaur provides general medical consultation, preventive healthcare and treatment for common illnesses.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),

    Doctor(
      id: 'doctor_008',
      userId: 'user_doctor_008',
      name: 'Dr. Vikram Malhotra',
      profileImage: null,
      specialty: 'ENT Specialist',
      qualification: 'MBBS, MS ENT',
      experienceYears: 13,
      rating: 4.6,
      reviewCount: 91,
      clinicName: 'ENT Care Center',
      location: 'Mohali, Punjab',
      consultationFee: 650,
      about:
      'Dr. Vikram Malhotra specializes in ear, nose and throat conditions and provides both clinic and online consultations.',
      consultationModes: [
        'Clinic',
        'Video',
      ],
      verified: true,
    ),
  ];

  // ============================================================
  // DOCTOR AVAILABILITY
  // ============================================================

  static const List<Availability> availabilities = [
    // Doctor 001
    Availability(
      id: 'availability_001',
      doctorId: 'doctor_001',
      dayOfWeek: 'Monday',
      date: null,
      startTime: '10:00 AM',
      endTime: '02:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_002',
      doctorId: 'doctor_001',
      dayOfWeek: 'Wednesday',
      date: null,
      startTime: '10:00 AM',
      endTime: '02:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_003',
      doctorId: 'doctor_001',
      dayOfWeek: 'Friday',
      date: null,
      startTime: '04:00 PM',
      endTime: '08:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 002
    Availability(
      id: 'availability_004',
      doctorId: 'doctor_002',
      dayOfWeek: 'Tuesday',
      date: null,
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_005',
      doctorId: 'doctor_002',
      dayOfWeek: 'Thursday',
      date: null,
      startTime: '04:00 PM',
      endTime: '07:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 003
    Availability(
      id: 'availability_006',
      doctorId: 'doctor_003',
      dayOfWeek: 'Monday',
      date: null,
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_007',
      doctorId: 'doctor_003',
      dayOfWeek: 'Saturday',
      date: null,
      startTime: '10:00 AM',
      endTime: '03:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 004
    Availability(
      id: 'availability_008',
      doctorId: 'doctor_004',
      dayOfWeek: 'Tuesday',
      date: null,
      startTime: '10:00 AM',
      endTime: '02:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_009',
      doctorId: 'doctor_004',
      dayOfWeek: 'Friday',
      date: null,
      startTime: '03:00 PM',
      endTime: '07:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 005
    Availability(
      id: 'availability_010',
      doctorId: 'doctor_005',
      dayOfWeek: 'Monday',
      date: null,
      startTime: '11:00 AM',
      endTime: '03:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_011',
      doctorId: 'doctor_005',
      dayOfWeek: 'Thursday',
      date: null,
      startTime: '04:00 PM',
      endTime: '08:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 006
    Availability(
      id: 'availability_012',
      doctorId: 'doctor_006',
      dayOfWeek: 'Wednesday',
      date: null,
      startTime: '10:00 AM',
      endTime: '02:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_013',
      doctorId: 'doctor_006',
      dayOfWeek: 'Saturday',
      date: null,
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 007
    Availability(
      id: 'availability_014',
      doctorId: 'doctor_007',
      dayOfWeek: 'Monday',
      date: null,
      startTime: '09:00 AM',
      endTime: '01:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_015',
      doctorId: 'doctor_007',
      dayOfWeek: 'Friday',
      date: null,
      startTime: '04:00 PM',
      endTime: '08:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    // Doctor 008
    Availability(
      id: 'availability_016',
      doctorId: 'doctor_008',
      dayOfWeek: 'Tuesday',
      date: null,
      startTime: '10:00 AM',
      endTime: '02:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),

    Availability(
      id: 'availability_017',
      doctorId: 'doctor_008',
      dayOfWeek: 'Thursday',
      date: null,
      startTime: '03:00 PM',
      endTime: '07:00 PM',
      slotDuration: 30,
      isAvailable: true,
    ),
  ];
}