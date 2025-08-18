class TeacherUpdateSkillResponseModel {
  final String message;
  final TeacherUpdateSkill updateDetails;

  TeacherUpdateSkillResponseModel({
    required this.message,
    required this.updateDetails,
  });

factory TeacherUpdateSkillResponseModel.fromJson(Map<String, dynamic> json) {
  return TeacherUpdateSkillResponseModel(
    message: json['message'] ?? '',
    updateDetails: json['updateDetails'] != null
        ? TeacherUpdateSkill.fromJson(json['updateDetails'])
        : TeacherUpdateSkill(subject: []), // Provide a default empty object
  );
}

}

class TeacherUpdateSkill {
  final List<String> subject;

  TeacherUpdateSkill({required this.subject});

  factory TeacherUpdateSkill.fromJson(Map<String, dynamic> json) {
    return TeacherUpdateSkill(
      subject: List<String>.from(json['subject'] ?? []),
    );
  }
}