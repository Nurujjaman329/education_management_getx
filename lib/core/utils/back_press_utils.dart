import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:flutter/material.dart';

class BackPressHandler {
  static DateTime? _lastPressed;

  /// Returns `true` if the app should exit, otherwise shows a snackbar.
  static Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final canExit = _lastPressed == null || now.difference(_lastPressed!) > const Duration(seconds: 2);

    if (canExit) {
      _lastPressed = now;

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        
        const SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );

      return false; // Do not exit yet
    }

    return true; // Exit app
  }
}
