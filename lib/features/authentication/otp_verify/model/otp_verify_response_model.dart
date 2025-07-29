class OtpVerifyResponseModel {
  final String message;

  OtpVerifyResponseModel({required this.message});

  factory OtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponseModel(
      message: json['message'] as String,
    );
  }
}
