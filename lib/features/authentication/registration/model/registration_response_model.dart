class RegistrationResponseModel {
  final String message;
  final SignUpDetails? signupDetails;

  RegistrationResponseModel({required this.message, this.signupDetails});

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      message: json['message'] ?? '',
      signupDetails: json['signupDetails'] != null
          ? SignUpDetails.fromJson(json['signupDetails'])
          : null,
    );
  }
}

class SignUpDetails {
  final String id;
  final String name;
  final String mobileNo;
  final String image;
  final String email;
  final String password;
  final DateTime? dob;
  final String otp;
  final String cv;
  final String academicImage;
  final List<String>? subject;
  final List<String>? role;

  SignUpDetails({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.image,
    required this.email,
    required this.password,
    this.dob,
    required this.otp,
    required this.cv,
    required this.academicImage,
    this.subject,
    this.role,
  });

  factory SignUpDetails.fromJson(Map<String, dynamic> json) {
    return SignUpDetails(
      id: json['id'],
      name: json['name'],
      mobileNo: json['mobileNo'],
      image: json['image'],
      email: json['email'],
      password: json['password'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      otp: json['otp'],
      cv: json['cv'],
      academicImage: json['academicImage'],
      subject: (json['subject'] as List?)?.map((e) => e.toString()).toList(),
      role: (json['role'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
