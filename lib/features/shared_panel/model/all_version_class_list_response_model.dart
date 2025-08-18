class AllVersionClassListResponseModel {
  final String id;
  final String className;

  AllVersionClassListResponseModel({
    required this.id,
    required this.className,
  });

  factory AllVersionClassListResponseModel.fromJson(Map<String, dynamic> json) {
    return AllVersionClassListResponseModel(
      id: json['id'] ?? '',
      className: json['className'] ?? '',
    );
  }
}