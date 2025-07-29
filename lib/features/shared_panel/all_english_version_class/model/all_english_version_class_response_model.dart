class AllEnglishVersionClassResponseModel {
  final String id;
  final String className;

  AllEnglishVersionClassResponseModel({
    required this.id,
    required this.className,
  });

  factory AllEnglishVersionClassResponseModel.fromJson(Map<String, dynamic> json) {
    return AllEnglishVersionClassResponseModel(
      id: json['id'] ?? '',
      className: json['className'] ?? '',
    );
  }
}