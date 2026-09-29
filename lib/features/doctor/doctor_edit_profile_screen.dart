import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/theme.dart';
import '../../services/doctor_profile_service.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({
    super.key,
  });

  @override
  State<DoctorEditProfileScreen> createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState
    extends State<DoctorEditProfileScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController specialtyController;
  late TextEditingController qualificationController;
  late TextEditingController experienceController;
  late TextEditingController clinicController;
  late TextEditingController locationController;
  late TextEditingController feeController;
  late TextEditingController aboutController;

  bool clinicVisit = false;
  bool videoConsultation = false;

  String? selectedImagePath;

  @override
  void initState() {
    super.initState();

    final doctor =
    DoctorProfileService.getCurrentDoctor();

    selectedImagePath = doctor.profileImage;

    nameController =
        TextEditingController(text: doctor.name);

    specialtyController =
        TextEditingController(text: doctor.specialty);

    qualificationController =
        TextEditingController(
          text: doctor.qualification,
        );

    experienceController =
        TextEditingController(
          text: doctor.experienceYears.toString(),
        );

    clinicController =
        TextEditingController(
          text: doctor.clinicName,
        );

    locationController =
        TextEditingController(
          text: doctor.location,
        );

    feeController =
        TextEditingController(
          text: doctor.consultationFee.toStringAsFixed(0),
        );

    aboutController =
        TextEditingController(
          text: doctor.about,
        );

    clinicVisit =
        doctor.consultationModes.contains('Clinic');

    videoConsultation =
        doctor.consultationModes.contains(
          'Video Consultation',
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    specialtyController.dispose();
    qualificationController.dispose();
    experienceController.dispose();
    clinicController.dispose();
    locationController.dispose();
    feeController.dispose();
    aboutController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _buildProfileImage(),

            const SizedBox(height: 24),

            _buildSectionTitle(
              'Personal Information',
              Icons.person_outline_rounded,
            ),

            const SizedBox(height: 12),

            _buildTextField(
              controller: nameController,
              label: 'Doctor Name',
              hint: 'Enter doctor name',
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: specialtyController,
              label: 'Specialty',
              hint: 'e.g. Cardiologist',
              icon: Icons.medical_services_outlined,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: qualificationController,
              label: 'Qualification',
              hint: 'e.g. MBBS, MD',
              icon: Icons.school_outlined,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: experienceController,
              label: 'Experience',
              hint: 'Enter years of experience',
              icon: Icons.work_outline_rounded,
              keyboardType: TextInputType.number,
              suffixText: 'Years',
              validator: _validateExperience,
            ),

            const SizedBox(height: 26),

            _buildSectionTitle(
              'Clinic Information',
              Icons.local_hospital_outlined,
            ),

            const SizedBox(height: 12),

            _buildTextField(
              controller: clinicController,
              label: 'Clinic Name',
              hint: 'Enter clinic name',
              icon: Icons.business_outlined,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: locationController,
              label: 'Location',
              hint: 'Enter clinic location',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 26),

            _buildSectionTitle(
              'Consultation',
              Icons.video_call_outlined,
            ),

            const SizedBox(height: 12),

            _buildTextField(
              controller: feeController,
              label: 'Consultation Fee',
              hint: 'Enter consultation fee',
              icon: Icons.currency_rupee_rounded,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixText: '₹ ',
              validator: _validateFee,
            ),

            const SizedBox(height: 18),

            _buildConsultationModes(),

            const SizedBox(height: 26),

            _buildSectionTitle(
              'About Doctor',
              Icons.info_outline_rounded,
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: aboutController,
              maxLines: 5,
              maxLength: 300,
              decoration: const InputDecoration(
                hintText:
                'Write something about the doctor...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    bottom: 72,
                  ),
                  child: Icon(
                    Icons.description_outlined,
                  ),
                ),
                alignLabelWithHint: true,
                labelText: 'About',
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter about information';
                }

                if (value.trim().length < 20) {
                  return 'About should contain at least 20 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final bool hasImage =
        selectedImagePath != null &&
            selectedImagePath!.isNotEmpty &&
            File(selectedImagePath!).existsSync();

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor
                      .withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor
                        .withOpacity(0.15),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: hasImage
                      ? Image.file(
                    File(selectedImagePath!),
                    width: 105,
                    height: 105,
                    fit: BoxFit.cover,
                  )
                      : const Icon(
                    Icons.person_rounded,
                    size: 58,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),

              Positioned(
                right: 0,
                bottom: 2,
                child: GestureDetector(
                  onTap: _changeProfileImage,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextButton.icon(
            onPressed: _changeProfileImage,
            icon: const Icon(
              Icons.photo_library_outlined,
              size: 18,
            ),
            label: const Text(
              'Change Profile Photo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      IconData icon,
      ) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color:
            AppTheme.primaryColor.withOpacity(0.08),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefixText,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        prefixText: prefixText,
        suffixText: suffixText,
      ),
      validator: validator ??
              (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return '$label is required';
            }

            return null;
          },
    );
  }

  Widget _buildConsultationModes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Consultation Modes',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Clinic Visit',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Patients can visit the clinic',
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            secondary: const Icon(
              Icons.local_hospital_outlined,
              color: AppTheme.primaryColor,
            ),
            value: clinicVisit,
            onChanged: (value) {
              setState(() {
                clinicVisit = value;
              });
            },
          ),

          const Divider(height: 1),

          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Video Consultation',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Patients can consult online',
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            secondary: const Icon(
              Icons.videocam_outlined,
              color: AppTheme.primaryColor,
            ),
            value: videoConsultation,
            onChanged: (value) {
              setState(() {
                videoConsultation = value;
              });
            },
          ),
        ],
      ),
    );
  }

  String? _validateExperience(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Experience is required';
    }

    final int? experience =
    int.tryParse(value.trim());

    if (experience == null) {
      return 'Enter a valid number';
    }

    if (experience < 0 ||
        experience > 60) {
      return 'Experience must be between 0 and 60 years';
    }

    return null;
  }

  String? _validateFee(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Consultation Fee is required';
    }

    final double? fee =
    double.tryParse(value.trim());

    if (fee == null) {
      return 'Enter a valid fee';
    }

    if (fee < 0) {
      return 'Fee cannot be negative';
    }

    return null;
  }

  Future<void> _changeProfileImage() async {
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

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!clinicVisit &&
        !videoConsultation) {
      _showMessage(
        'Please select at least one consultation mode.',
      );
      return;
    }

    final int experienceYears =
    int.parse(
      experienceController.text.trim(),
    );

    final double consultationFee =
    double.parse(
      feeController.text.trim(),
    );

    final List<String> modes = [];

    if (clinicVisit) {
      modes.add('Clinic');
    }

    if (videoConsultation) {
      modes.add('Video Consultation');
    }

    DoctorProfileService.updateDoctor(
      name: nameController.text.trim(),
      specialty:
      specialtyController.text.trim(),
      qualification:
      qualificationController.text.trim(),
      experienceYears: experienceYears,
      clinicName:
      clinicController.text.trim(),
      location:
      locationController.text.trim(),
      consultationFee:
      consultationFee,
      about:
      aboutController.text.trim(),
      consultationModes: modes,
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}