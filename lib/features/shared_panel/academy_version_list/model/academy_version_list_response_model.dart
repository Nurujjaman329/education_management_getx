class AcademyVersionListResponseModel {
  final String id;
  final String postName;

  AcademyVersionListResponseModel({
    required this.id,
    required this.postName,
  });

  factory AcademyVersionListResponseModel.fromJson(Map<String, dynamic> json) {
    return AcademyVersionListResponseModel(
      id: json['id'] ?? '',
      postName: json['postName'] ?? '',
    );
  }
}
