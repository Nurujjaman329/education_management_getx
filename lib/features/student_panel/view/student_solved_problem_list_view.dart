import 'dart:developer';

import 'package:edex_365_getx/core/config/app_colors.dart';
import 'package:edex_365_getx/core/widgets/custom_curved_appbar.dart';
import 'package:edex_365_getx/features/shared_panel/view/problem_details_view.dart';
import 'package:edex_365_getx/features/student_panel/controller/student_problem_list_controller.dart';
import 'package:edex_365_getx/features/student_panel/view/widget/problem_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentSolvedProblemListView extends StatelessWidget {
  const StudentSolvedProblemListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentProblemListController>();

    return Scaffold(
     appBar: const CustomCurvedAppBar(title: "Solved List",showBackButton: true,),
      body:Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                ),
              ),
            );
          }
 
          if (controller.solvedProblems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No problems found",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

         return ListView.separated(
  padding: const EdgeInsets.all(16),
  itemCount: controller.solvedProblems.length,
  separatorBuilder: (_, __) => const SizedBox(height: 12),
  itemBuilder: (context, index) {
    final problem = controller.solvedProblems[index];
    return ProblemCard(
      problem: problem,
      onTap: () {
           log("SubID --------------------- ${problem.id}");
        Get.to(
       
          () => ProblemDetailsView(problemId: problem.id),
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
