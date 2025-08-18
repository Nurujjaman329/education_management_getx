import 'package:edex_365_getx/features/student_panel/model/student_problem_list_response_model.dart';
import 'package:edex_365_getx/features/teacher_panel/model/teacher_problem_get_model.dart';
import 'package:flutter/material.dart';

class ProblemCard extends StatelessWidget {
  final dynamic problem; // Accepts either student or teacher problem model
  final void Function()? onTap;

  const ProblemCard({
    super.key,
    required this.problem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Normalize fields so UI code doesn't care about the original model type
    final String subject = problem is StudentProblemListResponseModel
        ? problem.subject
        : (problem as TeacherProblemGetModel).subject;

    final String topic = problem is StudentProblemListResponseModel
        ? problem.topic
        : (problem as TeacherProblemGetModel).topic;

    final String photo = problem is StudentProblemListResponseModel
        ? problem.photo
        : (problem as TeacherProblemGetModel).photo;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  photo,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      color: theme.colorScheme.surface,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: theme.colorScheme.surface,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: theme.disabledColor,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    topic,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
