class TeacherGetSkillResponseModel {
  final String id;
  final List<String> subject;

  TeacherGetSkillResponseModel({required this.id, required this.subject});

  factory TeacherGetSkillResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherGetSkillResponseModel(
      id: json['id'],
      subject: List<String>.from(json['subject']),
    );
  }
}
