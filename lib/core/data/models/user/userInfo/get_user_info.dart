class UserInfo {
  final String UserId;
  final String UserName;
  final String Email;
  final String fullName;
  final String lastName;

  UserInfo({
    required this.UserId,
    required this.UserName,
    required this.Email,
    required this.fullName,
    required this.lastName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      UserId: json['userId'] ?? '',
      UserName: json['userName'] ?? '',
      Email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': UserId,
      'userName': UserName,
      'lastName': lastName,
      'fullName': fullName,
      'email': Email,
    };
  }
}
