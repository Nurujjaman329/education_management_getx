class TeacherSolutionResponseModel {
  final String photo;

  TeacherSolutionResponseModel({required this.photo});

   factory TeacherSolutionResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherSolutionResponseModel(
      photo: json['photo'] ?? '',
    );
}
}
