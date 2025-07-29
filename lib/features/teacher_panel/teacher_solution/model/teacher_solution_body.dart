import 'dart:io';

import 'package:dio/dio.dart';

class TeacherSolutionBody{
  final String teacherId;
  final List<File> photo; // Now supports multiple images

  const TeacherSolutionBody({
    required this.teacherId,
    required this.photo,
  }) : super();

  /// Converts the object to FormData for file upload
  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(MapEntry('teacherId', teacherId));

    // Add each photo as a separate MapEntry with the same key ('photos')
    for (File photo in photo) {
      formData.files.add(MapEntry(
        'photos',
        await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
      ));
    }

    return formData;
  }

  /// A factory constructor to create an empty instance of TeacherSolutionBody
  factory TeacherSolutionBody.empty() {
    return const TeacherSolutionBody(
      teacherId: '',
      photo: [],
    );
  }
}