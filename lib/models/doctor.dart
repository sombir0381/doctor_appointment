class Doctor {
  final String id;
  final String userId;
  final String name;
  final String? profileImage;
  final String specialty;
  final String qualification;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final String clinicName;
  final String location;
  final double consultationFee;
  final String about;
  final List<String> consultationModes;
  final bool verified;

  const Doctor({
    required this.id,
    required this.userId,
    required this.name,
    this.profileImage,
    required this.specialty,
    required this.qualification,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.clinicName,
    required this.location,
    required this.consultationFee,
    required this.about,
    required this.consultationModes,
    required this.verified,
  });
}