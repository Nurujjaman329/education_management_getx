import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/authentication/controller/auth_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_problem_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_problem_get_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherAllProblemDetailsView extends StatelessWidget {
  final TeacherProblemGetModel problem;

  const TeacherAllProblemDetailsView({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<TeacherProblemController>();
    final authController = Get.find<AuthController>();
    final userId = authController.userId.value;

    // Normalize problem data
    final String subject = problem.subject;
    final String topic = problem.topic;
    final String description = problem.description;
    final String photo = problem.photo;
    final String date = problem.getDateBy.toString();
    final String postId = problem.id;

    // Check if user already has an accepted problem
    final hasExistingTask = controller.acceptedProblems.isNotEmpty;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomCurvedAppBar(title: "Problem Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem Image
            if (photo.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  photo,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: theme.colorScheme.surface,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: theme.colorScheme.surface,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: theme.disabledColor,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Problem Details
            Text(
              subject,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Topic: $topic',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // Date Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Posted on: $date',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

       Obx(() {
              // Check loading state
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }

              // Check if this specific problem is already accepted
              final isThisProblemAccepted = controller.acceptedProblems.any((p) => p.id == postId);

              return Column(
                children: [
                  if (hasExistingTask && !isThisProblemAccepted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'You already have an accepted problem. Please complete it before accepting a new one.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isThisProblemAccepted || hasExistingTask
                          ? null
                          : () async {
                              try {
                                await controller.acceptProblem(userId, postId);
                                await controller.fetchAcceptedProblems(userId);
                                
                              Get.snackbar(
  "Success", 
  "Problem accepted successfully!",
  snackPosition: SnackPosition.BOTTOM,
  margin: const EdgeInsets.all(10),
  borderRadius: 10,
  backgroundColor: Get.theme.colorScheme.primary,
  colorText: Colors.white,
);

                                Get.back(result: true);
                              }catch (e) {
  if (e.toString().contains("Already Have a Task")) {
    Get.dialog(
      AlertDialog(
        title: const Text("Task Warning"),
        content: const Text("You already have a task assigned."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  } else {
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Colors.white,
    );
  }
}

                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isThisProblemAccepted 
                            ? 'Already Accepted' 
                            : 'Accept Problem',
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void showAlreadyHaveTaskDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Cannot Accept Problem", 
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: const Text(
          "You already have an accepted problem. Please submit the solution for your current problem before accepting a new one.",
        ),
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "OK",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
