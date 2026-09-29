import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  // ============================================================
  // SETTINGS VALUES
  // ============================================================

  bool get notificationsEnabled =>
      SettingsService.notificationsEnabled;

  bool get appointmentReminder =>
      SettingsService.appointmentReminder;

  String get selectedLanguage =>
      SettingsService.selectedLanguage;

  // ============================================================
  // LANGUAGE DIALOG
  // ============================================================

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Select Language',
            style: TextStyle(
              fontWeight:
              FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'English',
                groupValue:
                selectedLanguage,
                title: const Text(
                  'English',
                ),
                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  SettingsService
                      .setLanguage(
                    value,
                  );

                  setState(() {});

                  Navigator.pop(
                    dialogContext,
                  );
                },
              ),

              RadioListTile<String>(
                value: 'Hindi',
                groupValue:
                selectedLanguage,
                title: const Text(
                  'Hindi',
                ),
                onChanged:
                    (value) {
                  if (value == null) {
                    return;
                  }

                  SettingsService
                      .setLanguage(
                    value,
                  );

                  setState(() {});

                  Navigator.pop(
                    dialogContext,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void showAboutDialogBox() {
    showAboutDialog(
      context: context,
      applicationName:
      'DoctorEase',
      applicationVersion:
      '1.0.0',
      applicationLegalese:
      'Doctor appointment application',
      children: const [
        SizedBox(
          height: 15,
        ),
        Text(
          'DoctorEase helps patients discover doctors '
              'and manage their appointments.',
        ),
      ],
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  void showPrivacyMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Privacy settings will be connected with the backend later.',
        ),
      ),
    );
  }

  // ============================================================
  // TERMS
  // ============================================================

  void showTermsMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Terms & Conditions will be added later.',
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight:
              FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logout will be connected with authentication.',
                    ),
                  ),
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
                foregroundColor:
                Colors.white,
              ),
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );
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
          'Settings',
          style: TextStyle(
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding:
        const EdgeInsets.all(20),
        children: [
          // =====================================================
          // NOTIFICATIONS
          // =====================================================

          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          _settingsCard(
            children: [
              SwitchListTile(
                contentPadding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 16,
                ),
                secondary: const Icon(
                  Icons
                      .notifications_outlined,
                ),
                title: const Text(
                  'Notifications',
                ),
                subtitle:
                const Text(
                  'Receive appointment notifications',
                ),
                value:
                notificationsEnabled,
                onChanged:
                    (value) {
                  setState(() {
                    SettingsService
                        .setNotificationsEnabled(
                      value,
                    );

                    if (!value) {
                      SettingsService
                          .setAppointmentReminder(
                        false,
                      );
                    }
                  });
                },
              ),

              const Divider(
                height: 1,
              ),

              SwitchListTile(
                contentPadding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 16,
                ),
                secondary: const Icon(
                  Icons.alarm_outlined,
                ),
                title: const Text(
                  'Appointment Reminder',
                ),
                subtitle:
                const Text(
                  'Get reminders before appointments',
                ),
                value:
                appointmentReminder,
                onChanged:
                notificationsEnabled
                    ? (value) {
                  setState(() {
                    SettingsService
                        .setAppointmentReminder(
                      value,
                    );
                  });
                }
                    : null,
              ),
            ],
          ),

          const SizedBox(
            height: 25,
          ),

          // =====================================================
          // PREFERENCES
          // =====================================================

          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          _settingsCard(
            children: [
              ListTile(
                leading: const Icon(
                  Icons
                      .language_outlined,
                ),
                title: const Text(
                  'Language',
                ),
                subtitle: Text(
                  selectedLanguage,
                ),
                trailing:
                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap:
                showLanguageDialog,
              ),

              const Divider(
                height: 1,
              ),

              ListTile(
                leading: const Icon(
                  Icons
                      .lock_outline_rounded,
                ),
                title: const Text(
                  'Privacy',
                ),
                subtitle:
                const Text(
                  'Manage your privacy settings',
                ),
                trailing:
                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap:
                showPrivacyMessage,
              ),
            ],
          ),

          const SizedBox(
            height: 25,
          ),

          // =====================================================
          // ABOUT
          // =====================================================

          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          _settingsCard(
            children: [
              ListTile(
                leading: const Icon(
                  Icons
                      .info_outline_rounded,
                ),
                title: const Text(
                  'About DoctorEase',
                ),
                trailing:
                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap:
                showAboutDialogBox,
              ),

              const Divider(
                height: 1,
              ),

              ListTile(
                leading: const Icon(
                  Icons
                      .description_outlined,
                ),
                title: const Text(
                  'Terms & Conditions',
                ),
                trailing:
                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap:
                showTermsMessage,
              ),
            ],
          ),

          const SizedBox(
            height: 25,
          ),

          // =====================================================
          // LOGOUT
          // =====================================================

          Container(
            decoration:
            BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              onTap:
              showLogoutDialog,
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          Center(
            child: Text(
              'DoctorEase v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme
                    .secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}