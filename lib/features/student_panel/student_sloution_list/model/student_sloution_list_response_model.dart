class StudentSloutionListResponseModel {
  final String id;
  final String photo;

  StudentSloutionListResponseModel({
    required this.id,
    required this.photo,
  });

  factory StudentSloutionListResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentSloutionListResponseModel(
      id: json['id'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}
