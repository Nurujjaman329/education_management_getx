class AllBanglaVersionClassResponseModel {
  final String id;
  final String className;

  AllBanglaVersionClassResponseModel({
    required this.id,
    required this.className,
  });

  factory AllBanglaVersionClassResponseModel.fromJson(Map<String, dynamic> json) {
    return AllBanglaVersionClassResponseModel(
      id: json['id'] ?? '',
      className: json['className'] ?? '',
    );
  }
}