class TeacherProblemGetModel {
  final String id;
  final String subject;
  final String topic;
  final String sClass;
  final String description;
  final String photo;
  final DateTime? getDateby;
  final bool flag;

  TeacherProblemGetModel({
    required this.id,
    required this.subject,
    required this.topic,
    required this.sClass,
    required this.description,
    required this.photo,
    this.getDateby,
    required this.flag,
  });

  factory TeacherProblemGetModel.fromJson(Map<String, dynamic> json) {
    return TeacherProblemGetModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      sClass: json['sClass'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      getDateby: json['getDateby'] != null ? DateTime.tryParse(json['getDateby']) : null,
      flag: json['flag'] ?? false,
    );
  }
}
