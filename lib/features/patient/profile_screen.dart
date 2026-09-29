import 'dart:io';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/user.dart';
import '../../services/profile_service.dart';
import '../../services/notification_service.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  void _refreshProfile() {
    setState(() {
      user = ProfileService.getCurrentUser();
    });
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );

    _refreshProfile();
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not provided';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildProfileImage() {
    final String? imagePath = user?.profileImage;

    if (imagePath != null &&
        imagePath.isNotEmpty &&
        File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 48,
        backgroundColor: AppTheme.primaryColor.withOpacity(0.10),
        backgroundImage: FileImage(
          File(imagePath),
        ),
      );
    }

    return CircleAvatar(
      radius: 48,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.10),
      child: const Icon(
        Icons.person_rounded,
        size: 52,
        color: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = user ??
        ProfileService.getCurrentUser();

    final int unreadCount =
    NotificationService.getUnreadCount(
      currentUser.id,
    );

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
            onPressed: _openEditProfile,
            icon: const Icon(
              Icons.edit_outlined,
            ),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshProfile();
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: _buildProfileImage(),
            ),

            const SizedBox(height: 14),

            Center(
              child: Text(
                currentUser.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textColor,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: Text(
                currentUser.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _openEditProfile,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'Edit Profile',
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.person_outline_rounded,
              title: 'Name',
              value: currentUser.name,
            ),

            _buildInfoCard(
              icon: Icons.email_outlined,
              title: 'Email',
              value: currentUser.email,
            ),

            _buildInfoCard(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: currentUser.phone,
            ),

            _buildInfoCard(
              icon: Icons.wc_outlined,
              title: 'Gender',
              value: currentUser.gender ?? 'Not provided',
            ),

            _buildInfoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Date of Birth',
              value: _formatDate(
                currentUser.dateOfBirth,
              ),
            ),

            _buildInfoCard(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: currentUser.address?.isNotEmpty == true
                  ? currentUser.address!
                  : 'Not provided',
            ),

            const SizedBox(height: 20),

            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  unreadCount > 0
                      ? '$unreadCount unread notifications'
                      : 'No unread notifications',
                ),
                trailing: unreadCount > 0
                    ? CircleAvatar(
                  radius: 12,
                  backgroundColor:
                  AppTheme.primaryColor,
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
                    : const Icon(
                  Icons.chevron_right_rounded,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const NotificationsScreen(),
                    ),
                  );

                  _refreshProfile();
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'App preferences and account settings',
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const SettingsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logout will be connected with authentication.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout_rounded,
              ),
              label: const Text(
                'Logout',
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.secondaryTextColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}