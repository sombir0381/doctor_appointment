import 'package:flutter/material.dart';

class AppUtils {
  AppUtils._();

  // =========================================================
  // SHOW SUCCESS MESSAGE
  // =========================================================

  static void showSuccessSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF16A34A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // =========================================================
  // SHOW ERROR MESSAGE
  // =========================================================

  static void showErrorSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFFDC2626),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // =========================================================
  // SHOW INFO MESSAGE
  // =========================================================

  static void showInfoSnackBar(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // =========================================================
  // FORMAT CURRENCY
  // =========================================================

  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  static String formatDate(DateTime date) {
    final String day =
    date.day.toString().padLeft(2, '0');

    final String month =
    date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // =========================================================
  // FORMAT TIME
  // =========================================================

  static String formatTime(String time) {
    return time;
  }

  // =========================================================
  // GET INITIALS
  // =========================================================

  static String getInitials(String name) {
    final String trimmedName =
    name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    final List<String> words =
    trimmedName.split(RegExp(r'\s+'));

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return (
        words.first[0] +
            words.last[0]
    ).toUpperCase();
  }

  // =========================================================
  // APPOINTMENT STATUS COLOR
  // =========================================================

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF16A34A);

      case 'pending':
        return const Color(0xFFF59E0B);

      case 'completed':
        return const Color(0xFF2563EB);

      case 'cancelled':
        return const Color(0xFFDC2626);

      case 'rejected':
        return const Color(0xFFDC2626);

      case 'rescheduled':
        return const Color(0xFF7C3AED);

      default:
        return const Color(0xFF6B7280);
    }
  }

  // =========================================================
  // APPOINTMENT STATUS BACKGROUND
  // =========================================================

  static Color getStatusBackgroundColor(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFEAF8EF);

      case 'pending':
        return const Color(0xFFFFF7E6);

      case 'completed':
        return const Color(0xFFEAF2FF);

      case 'cancelled':
        return const Color(0xFFFFEEEE);

      case 'rejected':
        return const Color(0xFFFFEEEE);

      case 'rescheduled':
        return const Color(0xFFF3EAFE);

      default:
        return const Color(0xFFF3F4F6);
    }
  }

  // =========================================================
  // CAPITALIZE FIRST LETTER
  // =========================================================

  static String capitalize(String text) {
    final String value =
    text.trim();

    if (value.isEmpty) {
      return '';
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }

  // =========================================================
  // GET STATUS TEXT
  // =========================================================

  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';

      case 'pending':
        return 'Pending';

      case 'completed':
        return 'Completed';

      case 'cancelled':
        return 'Cancelled';

      case 'rejected':
        return 'Rejected';

      case 'rescheduled':
        return 'Rescheduled';

      default:
        return capitalize(status);
    }
  }

  // =========================================================
  // CHECK EMPTY TEXT
  // =========================================================

  static bool isEmpty(String? value) {
    return value == null ||
        value.trim().isEmpty;
  }
}