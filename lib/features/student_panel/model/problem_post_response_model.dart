class ProblemPostResponseModel {
  final String message;
  final ProblemPostResponseBody? insertedPost;

  ProblemPostResponseModel({
    required this.message,
    this.insertedPost,
  });

  factory ProblemPostResponseModel.fromJson(Map<String, dynamic> json) {
    return ProblemPostResponseModel(
      message: json['message'] ?? '',
      insertedPost: json['insertedPost'] != null
          ? ProblemPostResponseBody.fromJson(json['insertedPost'])
          : null,
    );
  }
}

class ProblemPostResponseBody {
  final List<String>? subject;
  final String? topic;
  final List<String>? sClass;
  final String? description;
  final String? photo;
  final String? userId;

  const ProblemPostResponseBody({
    required this.subject,
    required this.topic,
    required this.sClass,
    required this.description,
    required this.photo,
    required this.userId,
  });

  factory ProblemPostResponseBody.fromJson(dynamic json) {
    return ProblemPostResponseBody(
      subject: (json['subject'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      topic: json['topic'] ?? '',
      sClass: (json['sClass'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
