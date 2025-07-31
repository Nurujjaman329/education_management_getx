import 'dart:io';
import 'package:dio/dio.dart';

class ProblemPostBody {
  final List<String>? postTypeId;
  final List<String>? subject;
  final String? topic;
  final List<String>? sClass;
  final String? description;
  final File? photo;
  final String? userId;

  const ProblemPostBody({
    this.postTypeId,
    this.subject,
    this.topic,
    this.sClass,
    this.description,
    this.photo,
    this.userId,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'postTypeId': postTypeId,
      'subject': subject,
      'topic': topic,
      'sClass': sClass,
      'description': description,
      'userId': userId,
      'photo': photo != null ? await MultipartFile.fromFile(photo!.path) : null,
    });
  }
}
