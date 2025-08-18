

import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/student_panel/view/widget/problem_card.dart';
import 'package:edex_365_getx/features/teacher_panel/controller/teacher_problem_controller.dart';
import 'package:edex_365_getx/features/teacher_panel/view/teacher_all_problem_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherProblemList extends StatelessWidget {
  const TeacherProblemList({super.key});

@override
Widget build(BuildContext context) {
  final controller = Get.find<TeacherProblemController>();
  final theme = Theme.of(context);

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    appBar: const CustomCurvedAppBar(
      title: "All Problem",
      showBackButton: true,
    ),
    body: Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(
              color: theme.colorScheme.error,
              fontSize: 16,
            ),
          ),
        );
      }

      if (controller.totalProblems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment,
                size: 48,
                color: theme.disabledColor,
              ),
              const SizedBox(height: 16),
              Text(
                "No problems found",
                style: TextStyle(
                  color: theme.disabledColor,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.totalProblems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final problem = controller.totalProblems[index];
          return ProblemCard(
            problem: problem,
            onTap: () {
              Get.to(
                () => TeacherAllProblemDetailsView(problem: problem),
                transition: Transition.leftToRight,
                duration: const Duration(milliseconds: 400),
              );
            },
          );
        },
      );
    }),
  );
}
}