import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyView extends StatelessWidget {
  final String mobileNo;

 OtpVerifyView({super.key, required this.mobileNo});

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button and Header
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 20),
                
                // Title Section
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We've sent a 6-digit code to your mobile number",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mobileNo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 40),
                
                // OTP Input Field
                const Text(
                  "Enter OTP Code",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    hintText: "------",
                    hintStyle: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      color: AppColors.disabled,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Resend OTP Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive code? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add resend OTP logic here
                        Get.snackbar(
                          "OTP Resent",
                          "A new OTP has been sent to your mobile",
                        );
                      },
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Verify Button
                Obx(() => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final otp = _otpController.text.trim();
                            if (otp.length != 6) {
                              Get.snackbar(
                                "Error",
                                "Enter a valid 6-digit OTP",
                                colorText: Colors.white,
                                backgroundColor: AppColors.error,
                              );
                              return;
                            }
                            await controller.verifyOtp(
                              controller.userId.toString(),
                              otp,
                            );
                            if (controller.isSuccess.value) {
                              Get.snackbar(
                                "Success",
                                "OTP Verified",
                                colorText: Colors.white,
                                backgroundColor: AppColors.success,
                              );
                              Get.offAllNamed(AppRoutes.login);
                            } else {
                              Get.snackbar(
                                "Error",
                                controller.errorMessage.value,
                                colorText: Colors.white,
                                backgroundColor: AppColors.error,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Verify & Continue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
