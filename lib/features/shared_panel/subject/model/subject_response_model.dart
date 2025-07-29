class SubjectResponseModel {
  final String id;
  final String subjectName;

  SubjectResponseModel({
    required this.id,
    required this.subjectName,
  });

  factory SubjectResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectResponseModel(
      id: json['id'] ?? '',
      subjectName: json['subjectName'] ?? '',
    );
  }
}
