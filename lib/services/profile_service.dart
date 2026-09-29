import '../models/user.dart';

class ProfileService {
  static User _currentUser = User(
    id: 'patient_001',
    role: 'patient',
    name: 'Sombir',
    email: 'sombir@example.com',
    phone: '+91 98765 43210',
    profileImage: null,
    gender: 'Male',
    dateOfBirth: DateTime(2000, 1, 1),
    address: 'India',
    createdAt: DateTime.now(),
  );

  static User getCurrentUser() {
    return _currentUser;
  }

  static void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required DateTime? dateOfBirth,
    required String address,
    String? profileImage,
  }) {
    _currentUser = User(
      id: _currentUser.id,
      role: _currentUser.role,
      name: name,
      email: email,
      phone: phone,
      profileImage:
      profileImage ?? _currentUser.profileImage,
      gender: gender,
      dateOfBirth: dateOfBirth,
      address: address,
      createdAt: _currentUser.createdAt,
    );
  }
}