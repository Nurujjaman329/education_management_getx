class GetClaimMessageResponseModel{
  final String userType;
  final List<GetClaimMessageChatResponseBody> chats;

  const GetClaimMessageResponseModel({
    required this.userType,
    required this.chats,
  });

  factory GetClaimMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return GetClaimMessageResponseModel(
      userType: json['userType'] ?? '',
      chats: (json['chats'] as List<dynamic>?)
              ?.map((e) => GetClaimMessageChatResponseBody.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

}

class GetClaimMessageChatResponseBody{
  final String imageUrl;
  final String text;
  final String message;
  final DateTime? getDate;

  GetClaimMessageChatResponseBody({
    required this.imageUrl,
    required this.text,
    required this.message,
    required this.getDate,
  });

  factory GetClaimMessageChatResponseBody.fromJson(Map<String, dynamic> json) {
    return GetClaimMessageChatResponseBody(
      imageUrl: json['imageUrl'] ?? '',
      text: json['text'] ?? '',
      message: json['message'] ?? '',
      getDate: json['getDate'] != null ? DateTime.tryParse(json['getDate']) : null,
    );
  }

}


