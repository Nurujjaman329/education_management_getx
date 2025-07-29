class LoginResponse {
  final String id;
  final String name;
  final String email;
  final String type;
  final String token;

  LoginResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      type: json['type'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
