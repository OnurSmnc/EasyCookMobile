class UpdateUserInfo {
  final String Email;
  final String FirstName;
  final String lastName;

  UpdateUserInfo({
    required this.FirstName,
    required this.Email,
    required this.lastName,
  });

  factory UpdateUserInfo.fromJson(Map<String, dynamic> json) {
    return UpdateUserInfo(
      FirstName: json['firstName'] ?? '',
      Email: json['email'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': FirstName,
      'lastName': lastName,
      'email': Email,
    };
  }
}
