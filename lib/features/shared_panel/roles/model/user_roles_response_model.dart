class UserRolesResponseModel {
  final String id;
  final String name;

  UserRolesResponseModel({required this.id, required this.name});

  factory UserRolesResponseModel.fromJson(Map<String, dynamic> json) {
    return UserRolesResponseModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
