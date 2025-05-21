class LoginResponse {
  final String token;
  final String refreshToken;
  final DateTime expiration;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.expiration,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiration: DateTime.parse(json['expiration']),
    );
  }
}
