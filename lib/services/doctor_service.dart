import '../cors/constants/mock_data.dart';
import '../models/doctor.dart';

class DoctorService {
  // =========================================================
  // GET ALL DOCTORS
  // =========================================================

  static List<Doctor> getDoctors() {
    return MockData.doctors;
  }

  // =========================================================
  // GET DOCTOR BY ID
  // =========================================================

  static Doctor? getDoctorById(
      String doctorId,
      ) {
    for (final doctor in MockData.doctors) {
      if (doctor.id == doctorId) {
        return doctor;
      }
    }

    return null;
  }

  // =========================================================
  // SEARCH DOCTORS
  // =========================================================

  static List<Doctor> searchDoctors(
      String query,
      ) {
    final String searchQuery =
    query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return MockData.doctors;
    }

    return MockData.doctors.where(
          (doctor) {
        return doctor.name
            .toLowerCase()
            .contains(searchQuery) ||
            doctor.specialty
                .toLowerCase()
                .contains(searchQuery) ||
            doctor.clinicName
                .toLowerCase()
                .contains(searchQuery) ||
            doctor.location
                .toLowerCase()
                .contains(searchQuery);
      },
    ).toList();
  }

  // =========================================================
  // FILTER BY SPECIALTY
  // =========================================================

  static List<Doctor> getDoctorsBySpecialty(
      String specialty,
      ) {
    return MockData.doctors.where(
          (doctor) {
        return doctor.specialty
            .toLowerCase()
            .contains(
          specialty.toLowerCase(),
        );
      },
    ).toList();
  }

  // =========================================================
  // GET VERIFIED DOCTORS
  // =========================================================

  static List<Doctor> getVerifiedDoctors() {
    return MockData.doctors.where(
          (doctor) => doctor.verified,
    ).toList();
  }
}