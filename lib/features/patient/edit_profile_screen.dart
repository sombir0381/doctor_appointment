import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme.dart';
import '../../models/user.dart';
import '../../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final ImagePicker _imagePicker =
  ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  late String selectedGender;
  DateTime? selectedDate;

  String? selectedImagePath;

  @override
  void initState() {
    super.initState();

    final User user =
    ProfileService.getCurrentUser();

    nameController = TextEditingController(
      text: user.name,
    );

    emailController = TextEditingController(
      text: user.email,
    );

    phoneController = TextEditingController(
      text: user.phone,
    );

    addressController = TextEditingController(
      text: user.address ?? '',
    );

    selectedGender =
        user.gender ?? 'Male';

    selectedDate = user.dateOfBirth;

    selectedImagePath =
        user.profileImage;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.dispose();
  }

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> _pickImage() async {
    try {
      final XFile? image =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedImagePath = image.path;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to select image.',
      );
    }
  }

  // ============================================================
  // SELECT DATE
  // ============================================================

  Future<void> selectDate() async {
    final DateTime today =
    DateTime.now();

    DateTime initialDate =
        selectedDate ?? DateTime(2000, 1, 1);

    if (initialDate.isAfter(today)) {
      initialDate = today;
    }

    final DateTime? pickedDate =
    await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: today,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String get formattedDate {
    if (selectedDate == null) {
      return 'Select date of birth';
    }

    return '${selectedDate!.day.toString().padLeft(2, '0')} '
        '${_monthName(selectedDate!.month)} '
        '${selectedDate!.year}';
  }

  String _monthName(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  void saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ProfileService.updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      gender: selectedGender,
      dateOfBirth: selectedDate,
      address: addressController.text.trim(),
      profileImage: selectedImagePath,
    );

    _showMessage(
      'Profile updated successfully.',
    );

    Future.delayed(
      const Duration(milliseconds: 500),
          () {
        if (!mounted) {
          return;
        }

        Navigator.pop(context);
      },
    );
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  String? validateEmail(String? value) {
    final String email =
        value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email';
    }

    final RegExp emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // ============================================================
  // PHONE VALIDATION
  // ============================================================

  String? validatePhone(String? value) {
    final String phone =
        value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    final String digitsOnly =
    phone.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =================================================
              // PROFILE IMAGE
              // =================================================

              Center(
                child: Stack(
                  children: [
                    _buildProfileImage(),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color:
                          AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _pickImage,
                          icon: const Icon(
                            Icons
                                .camera_alt_outlined,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    size: 18,
                  ),
                  label: const Text(
                    'Change Profile Photo',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // PERSONAL INFORMATION
              // =================================================

              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: nameController,
                textInputAction:
                TextInputAction.next,
                decoration:
                const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your name';
                  }

                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.next,
                decoration:
                const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
                validator: validateEmail,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType:
                TextInputType.phone,
                textInputAction:
                TextInputAction.next,
                decoration:
                const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                ),
                validator: validatePhone,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration:
                const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(
                    Icons.wc_outlined,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedGender = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: selectDate,
                borderRadius:
                BorderRadius.circular(14),
                child: InputDecorator(
                  decoration:
                  const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(
                      Icons
                          .calendar_today_outlined,
                    ),
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: addressController,
                maxLines: 3,
                textInputAction:
                TextInputAction.done,
                decoration:
                const InputDecoration(
                  labelText: 'Address',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      bottom: 45,
                    ),
                    child: Icon(
                      Icons
                          .location_on_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your address';
                  }

                  if (value.trim().length < 3) {
                    return 'Please enter a valid address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: saveProfile,
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE IMAGE VIEW
  // ============================================================

  Widget _buildProfileImage() {
    if (selectedImagePath != null &&
        selectedImagePath!.isNotEmpty) {
      final File imageFile =
      File(selectedImagePath!);

      return ClipOval(
        child: Image.file(
          imageFile,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return _buildDefaultProfileImage();
          },
        ),
      );
    }

    return _buildDefaultProfileImage();
  }

  Widget _buildDefaultProfileImage() {
    return CircleAvatar(
      radius: 55,
      backgroundColor:
      AppTheme.primaryColor.withOpacity(0.10),
      child: const Icon(
        Icons.person_rounded,
        size: 60,
        color: AppTheme.primaryColor,
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}