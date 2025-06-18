class PasswordRequest {
  final String activePassword;
  final String newPassword;
  final String confirmPassword;

  PasswordRequest({
    required this.activePassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'activePassword': activePassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}

class PasswordResponse {
  final String? confirmPasswordError;
  final String? currentPasswordError;

  PasswordResponse({
    this.confirmPasswordError,
    this.currentPasswordError,
  });

  factory PasswordResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResponse(
      confirmPasswordError: json['confirmPasswordError'],
      currentPasswordError: json['currentPasswordError'],
    );
  }
}
