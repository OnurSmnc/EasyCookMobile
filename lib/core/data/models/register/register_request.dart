class RegisterRequest {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String fullName;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': fullName,
      };
}
