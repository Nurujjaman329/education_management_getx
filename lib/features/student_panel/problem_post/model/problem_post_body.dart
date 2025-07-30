import 'dart:io';
import 'package:dio/dio.dart' as dio;

class ProblemPostBody{
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
  }) : super();

  ProblemPostBody clone() {
    return ProblemPostBody(
      postTypeId: postTypeId,
      subject: subject,
      topic: topic,
      sClass: sClass,
      description: description,
      photo: photo,
      userId: userId,
    );
  }

  static ProblemPostBody empty() {
    return const ProblemPostBody();
  }

  Future<dio.FormData> toFormData() async {
    final Map<String, dynamic> fields = {
      'postTypeId': postTypeId,
      'subject': subject,
      'topic': topic,
      'sClass': sClass,
      'description': description,
      'userId': userId,
    };

    // Convert photo to MultipartFile
    if (photo != null) {
      fields['photo'] = await dio.MultipartFile.fromFile(photo!.path, filename: photo!.path.split('/').last);
    }

    return dio.FormData.fromMap(fields);
  }

  ProblemPostBody copyWith({
  List<String>? postTypeId,
  List<String>? subject,
  String? topic,
  List<String>? sClass,
  String? description,
  File? photo,
  String? userId,
}) {
  return ProblemPostBody(
    postTypeId: postTypeId ?? this.postTypeId,
    subject: subject ?? this.subject,
    topic: topic ?? this.topic,
    sClass: sClass ?? this.sClass,
    description: description ?? this.description,
    photo: photo ?? this.photo,
    userId: userId ?? this.userId,
  );
}


}