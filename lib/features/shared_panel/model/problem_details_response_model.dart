class ProblemDetailsResponseModel {
  final String id;
  final String subject;
  final String topic;
  final String sClass;
  final String description;
  final String photo;
  final String getDateby;
  final List<ProblemDetailsChatResponseBody> teacherChats;
  final List<ProblemDetailsChatResponseBody> studentChats;

  ProblemDetailsResponseModel({
    required this.id,
    required this.subject,
    required this.topic,
    required this.sClass,
    required this.description,
    required this.photo,
    required this.getDateby,
    required this.teacherChats,
    required this.studentChats,
  });

  factory ProblemDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProblemDetailsResponseModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      sClass: json['sClass'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      getDateby: json['getDateby'] ?? '',
      teacherChats: (json['teacherChats'] as List<dynamic>?)
              ?.map((e) => ProblemDetailsChatResponseBody.fromJson(e))
              .toList() ??
          [],
      studentChats: (json['studentChats'] as List<dynamic>?)
              ?.map((e) => ProblemDetailsChatResponseBody.fromJson(e))
              .toList() ??
          [],
    );
  }
}


class ProblemDetailsChatResponseBody {
  final String message;
  final String getDate;

  ProblemDetailsChatResponseBody({
    required this.message,
    required this.getDate,
  });

  factory ProblemDetailsChatResponseBody.fromJson(Map<String, dynamic> json) {
    return ProblemDetailsChatResponseBody(
      message: json['message'] ?? '',
      getDate: json['getDate'] ?? '',
    );
  }
}

