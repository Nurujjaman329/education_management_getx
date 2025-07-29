class StudentProblemListResponseModel {
  final String id;
  final String subject;
  final String topic;
  final String sClass;
  final String description;
  final String photo;
  final DateTime? getDateby;

  StudentProblemListResponseModel({
    required this.id,
    required this.subject,
    required this.topic,
    required this.sClass,
    required this.description,
    required this.photo,
    required this.getDateby,
  });

  factory StudentProblemListResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentProblemListResponseModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      sClass: json['sClass'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      getDateby: json['getDateby'] != null
          ? DateTime.tryParse(json['getDateby'])
          : null,
    );
  }
}
