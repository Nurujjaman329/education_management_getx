import 'dart:io';

class SignUpDetailsBody {
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

  SignUpDetailsBody({
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.password,
    required this.subject,
    required this.role,
    this.image,
    this.cv,
    this.academicImage,
    this.dob,
  });
}
