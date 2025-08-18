
class StudentsSolutionGetResponseBodyModel{
  final String id;
  final String photo;

  const StudentsSolutionGetResponseBodyModel({
    required this.id,
    required this.photo,
  });

  factory StudentsSolutionGetResponseBodyModel.fromJson(Map<String, dynamic> json) {
    return StudentsSolutionGetResponseBodyModel(
      id: json['id'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
    };
  }

}
