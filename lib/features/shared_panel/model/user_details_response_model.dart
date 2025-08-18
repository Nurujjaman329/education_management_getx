class UserDetailsResponseModel {
  final String name;
  final String mobileNo;
  final String email;
  final String password;
  final DateTime? dob;
  final String school;
  final String image;
  final String classNames;
  final String subjectNames;

  UserDetailsResponseModel({
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.password,
    required this.dob,
    required this.school,
    required this.image,
    required this.classNames,
    required this.subjectNames,
  });

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponseModel(
      name: json['name']?? '',
      mobileNo: json['mobileNo']?? '',
      email: json['email']?? '',
      password: json['password']?? '',
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      school: json['school']?? '',
      image: json['image']?? '',
      classNames: json['classNames']?? '',
      subjectNames: json['subjectNames']?? '',
    );
  }
}
