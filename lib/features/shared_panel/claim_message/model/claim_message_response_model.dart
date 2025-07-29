class ClaimMessageResponseModel {
  final String imageUrl;
  final String text;
  final String message;
  final DateTime? getDate;

  ClaimMessageResponseModel({
    required this.imageUrl,
    required this.text,
    required this.message,
    required this.getDate,
  });

  factory ClaimMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return ClaimMessageResponseModel(
      imageUrl: json['imageUrl'] ?? '',
      text: json['text'] ?? '',
      message: json['message'] ?? '',
      getDate: json['getDate'] != null ? DateTime.tryParse(json['getDate']) : null,
    );
  }
}
