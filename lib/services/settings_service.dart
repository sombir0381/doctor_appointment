class SettingsService {
  static bool notificationsEnabled = true;

  static bool appointmentReminder = true;

  static String selectedLanguage =
      'English';

  static void setNotificationsEnabled(
      bool value,
      ) {
    notificationsEnabled = value;

    // Future:
    // Save to local storage / backend.
  }

  static void setAppointmentReminder(
      bool value,
      ) {
    appointmentReminder = value;

    // Future:
    // Save to local storage / backend.
  }

  static void setLanguage(
      String value,
      ) {
    selectedLanguage = value;

    // Future:
    // Save to local storage / backend.
  }
}