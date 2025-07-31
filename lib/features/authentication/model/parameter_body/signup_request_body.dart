import 'dart:io';

class SignUpRequestBody {
  final String name;
  final String mobileNo;
  final File? image;
  final String email;
  final String password;
  final DateTime? dob;
  final File? cv;
  final File? academicImage;
  final List<String> subject;
  final List<String> role;

  SignUpRequestBody({
    required this.name,
    required this.mobileNo,
    this.image,
    required this.email,
    required this.password,
    this.dob,
    this.cv,
    this.academicImage,
    required this.subject,
    required this.role,
  });
}
