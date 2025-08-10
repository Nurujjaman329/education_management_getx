class TeacherProblemGetModel {
  final String id;
  final String subject;
  final String topic;
  final String sClass;
  final String description;
  final String photo;
  final DateTime? getDateBy;
  final bool flag;

  TeacherProblemGetModel({
    required this.id,
    required this.subject,
    required this.topic,
    required this.sClass,
    required this.description,
    required this.photo,
    this.getDateBy,
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
      getDateBy: json['getDateby'] != null
          ? DateTime.tryParse(json['getDateby'].toString())
          : null,
      flag: json['flag'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
      "topic": topic,
      "sClass": sClass,
      "description": description,
      "photo": photo,
      "getDateby": getDateBy?.toIso8601String(),
      "flag": flag,
    };
  }
}
