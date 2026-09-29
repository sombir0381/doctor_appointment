class User {
  final String id;
  final String role;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.address,
    required this.createdAt,
  });
}