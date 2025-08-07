import 'package:edex_365_getx/core/controllers/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GlobalNetworkStatus extends StatelessWidget {
  final Widget child;

  const GlobalNetworkStatus({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityController = Get.find<ConnectivityController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (!connectivityController.isConnected.value) {
        // Show full-screen no connection UI
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.red,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Please check your internet settings and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

   
      return child;
    });
  }
}

