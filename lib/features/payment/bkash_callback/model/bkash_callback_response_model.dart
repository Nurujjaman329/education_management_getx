class BkashCallbackResponseModel {
  final bool success;
  final String message;

  BkashCallbackResponseModel({
    required this.success,
    required this.message,
  });

  factory BkashCallbackResponseModel.fromJson(Map<String, dynamic> json) {
    return BkashCallbackResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
