import 'package:dio/dio.dart';

class TeacherUpdateSkillBody {
  final String userId;
  final List<String> subject;

  TeacherUpdateSkillBody({required this.userId, required this.subject});

  FormData toFormData() {
    return FormData.fromMap({
      'userId': userId,
      'subject': subject,
    });
  }
}
