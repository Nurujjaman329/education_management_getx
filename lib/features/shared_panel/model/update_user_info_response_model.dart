import 'dart:io';
import 'package:dio/dio.dart';

class UpdateUserInfoResponseModel {
  final String message;
  final UpdateDetailsResponseBody updateDetails;

  UpdateUserInfoResponseModel({
    required this.message,
    required this.updateDetails,
  });

  factory UpdateUserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserInfoResponseModel(
      message: json['message'],
      updateDetails: UpdateDetailsResponseBody.fromJson(json['updateDetails']),
    );
  }
}


class UpdateDetailsResponseBody {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime? dob;
  final String school;
  final File? image;

  UpdateDetailsResponseBody({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.dob,
    required this.school,
    required this.image,
  });

  // 👇 Add this method to convert the model to FormData
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "dob": dob?.toIso8601String(),
      "school": school,
      if (image != null)
        "image": await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        ),
    });
  }

  factory UpdateDetailsResponseBody.fromJson(Map<String, dynamic> json) {
    return UpdateDetailsResponseBody(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: "", // avoid returning password from backend
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      school: json['school'],
      image: null, // image is handled locally
    );
  }
}
