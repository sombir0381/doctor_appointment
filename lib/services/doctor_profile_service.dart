import '../models/doctor.dart';

class DoctorProfileService {
  static Doctor _currentDoctor = const Doctor(
    id: 'doctor_001',
    userId: 'doctor_user_001',
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
    'Experienced cardiologist providing comprehensive heart care, '
        'preventive consultation and personalized treatment plans.',
    consultationModes: [
      'Clinic',
      'Video Consultation',
    ],
    verified: true,
  );

  static Doctor getCurrentDoctor() {
    return _currentDoctor;
  }

  static void updateDoctor({
    required String name,
    required String specialty,
    required String qualification,
    required int experienceYears,
    required String clinicName,
    required String location,
    required double consultationFee,
    required String about,
    required List<String> consultationModes,
    String? profileImage,
  }) {
    _currentDoctor = Doctor(
      id: _currentDoctor.id,
      userId: _currentDoctor.userId,
      name: name,
      profileImage:
      profileImage ?? _currentDoctor.profileImage,
      specialty: specialty,
      qualification: qualification,
      experienceYears: experienceYears,
      rating: _currentDoctor.rating,
      reviewCount: _currentDoctor.reviewCount,
      clinicName: clinicName,
      location: location,
      consultationFee: consultationFee,
      about: about,
      consultationModes: consultationModes,
      verified: _currentDoctor.verified,
    );
  }
}