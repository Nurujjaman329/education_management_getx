import 'dart:io';
import 'package:dio/dio.dart';

class TeachersSolutionBody{
  final String teacherId;
  final List<File> photos;

  const TeachersSolutionBody({
    required this.teacherId,
    required this.photos,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();
    formData.fields.add(MapEntry('teacherId', teacherId));

    for (File photo in photos) {
      formData.files.add(
        MapEntry(
          'photos',
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
        ),
      );
    }
    return formData;
  }

  factory TeachersSolutionBody.empty() {
    return const TeachersSolutionBody(
      teacherId: '',
      photos: [],
    );
  }
}
