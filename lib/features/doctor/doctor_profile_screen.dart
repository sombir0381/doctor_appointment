import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/doctor.dart';
import '../../services/doctor_profile_service.dart';
import 'doctor_edit_profile_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({
    super.key,
  });

  @override
  State<DoctorProfileScreen> createState() =>
      _DoctorProfileScreenState();
}

class _DoctorProfileScreenState
    extends State<DoctorProfileScreen> {
  Doctor doctor = DoctorProfileService.getCurrentDoctor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            onPressed: _openEditProfile,
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _buildProfileHeader(),

            const SizedBox(height: 20),

            _buildProfessionalInformation(),

            const SizedBox(height: 16),

            _buildClinicInformation(),

            const SizedBox(height: 16),

            _buildConsultationInformation(),

            const SizedBox(height: 16),

            _buildAboutSection(),

            const SizedBox(height: 16),

            _buildRatingSection(),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _openEditProfile,
                icon: const Icon(
                  Icons.edit_rounded,
                ),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildProfileAvatar(
                size: 100,
                iconSize: 55,
              ),

              if (doctor.verified)
                Positioned(
                  right: 2,
                  bottom: 5,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  doctor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (doctor.verified) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ],
            ],
          ),

          const SizedBox(height: 5),

          Text(
            doctor.specialty,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: Colors.green,
                  size: 15,
                ),
                SizedBox(width: 5),
                Text(
                  'Verified Doctor',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar({
    required double size,
    required double iconSize,
  }) {
    if (doctor.profileImage != null &&
        doctor.profileImage!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          doctor.profileImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return _buildDefaultAvatar(
              size: size,
              iconSize: iconSize,
            );
          },
        ),
      );
    }

    return _buildDefaultAvatar(
      size: size,
      iconSize: iconSize,
    );
  }

  Widget _buildDefaultAvatar({
    required double size,
    required double iconSize,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.12),
          width: 3,
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        size: iconSize,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildProfessionalInformation() {
    return _sectionCard(
      title: 'Professional Information',
      icon: Icons.medical_services_outlined,
      children: [
        _profileRow(
          icon: Icons.local_hospital_outlined,
          title: 'Specialty',
          value: doctor.specialty,
        ),
        _profileRow(
          icon: Icons.school_outlined,
          title: 'Qualification',
          value: doctor.qualification,
        ),
        _profileRow(
          icon: Icons.work_outline_rounded,
          title: 'Experience',
          value: '${doctor.experienceYears} Years',
        ),
      ],
    );
  }

  Widget _buildClinicInformation() {
    return _sectionCard(
      title: 'Clinic Information',
      icon: Icons.location_on_outlined,
      children: [
        _profileRow(
          icon: Icons.business_outlined,
          title: 'Clinic',
          value: doctor.clinicName,
        ),
        _profileRow(
          icon: Icons.location_on_outlined,
          title: 'Location',
          value: doctor.location,
        ),
      ],
    );
  }

  Widget _buildConsultationInformation() {
    return _sectionCard(
      title: 'Consultation',
      icon: Icons.video_call_outlined,
      children: [
        _profileRow(
          icon: Icons.currency_rupee_rounded,
          title: 'Consultation Fee',
          value: '₹${doctor.consultationFee.toStringAsFixed(0)}',
        ),

        const SizedBox(height: 12),

        const Text(
          'Consultation Modes',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 9),

        if (doctor.consultationModes.isEmpty)
          Text(
            'No consultation mode selected.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.secondaryTextColor,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: doctor.consultationModes.map(
                  (mode) {
                final bool isVideo = mode
                    .toLowerCase()
                    .contains('video');

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor
                        .withOpacity(0.07),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVideo
                            ? Icons.videocam_outlined
                            : Icons.local_hospital_outlined,
                        size: 15,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        mode,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _sectionCard(
      title: 'About',
      icon: Icons.info_outline_rounded,
      children: [
        Text(
          doctor.about,
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: AppTheme.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return _sectionCard(
      title: 'Patient Reviews',
      icon: Icons.star_outline_rounded,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.orange,
                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${doctor.reviewCount} patient reviews',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                    AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),

            const Spacer(),

            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor
                      .withOpacity(0.08),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 19,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  Widget _profileRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 13,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppTheme.primaryColor,
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 105,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.secondaryTextColor,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const DoctorEditProfileScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      doctor = DoctorProfileService.getCurrentDoctor();
    });
  }

  Future<void> _refreshProfile() async {
    setState(() {
      doctor = DoctorProfileService.getCurrentDoctor();
    });
  }
}