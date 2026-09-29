import 'package:flutter/material.dart';

import '../../app/theme.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 32,
            width: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}