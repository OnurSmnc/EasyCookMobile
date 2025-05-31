class RegisterResponse {
  final String userId;
  final String confirmationInfo;

  RegisterResponse({
    required this.userId,
    required this.confirmationInfo,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId'] as String,
      confirmationInfo: json['confirmationInfo'] as String,
    );
  }
}
