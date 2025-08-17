class TeachersSolutionResponseBodyModel {
  final String photo;

  const TeachersSolutionResponseBodyModel({required this.photo});

  factory TeachersSolutionResponseBodyModel.fromJson(Map<String, dynamic> json) {
    return TeachersSolutionResponseBodyModel(
      photo: json['photo'] ?? '',
    );
  }

  static List<TeachersSolutionResponseBodyModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => TeachersSolutionResponseBodyModel.fromJson(json))
        .toList();
  }
}
