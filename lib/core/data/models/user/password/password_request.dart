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
