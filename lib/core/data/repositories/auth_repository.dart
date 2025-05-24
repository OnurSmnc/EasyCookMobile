import 'package:easycook/core/data/models/login/login_request.dart';
import 'package:easycook/core/data/models/login/login_response.dart';
import 'package:easycook/core/data/models/refreshToken/refreshToken_request.dart';
import 'package:easycook/core/data/models/refreshToken/refreshToken_response.dart';
import 'package:easycook/core/data/models/register/register_request.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class AuthRepository {
  final ApiService _api = ApiService();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _api.post(
        ApiConstats.login,
        request.toJson(),
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> register(RegisterRequest request) async {
    try {
      final response = await _api.post(
        ApiConstats.register,
        request.toJson(),
      );

      return "success"; // Genellikle register işlemi bir yanıt döndürmez, sadece başarılı olması yeterlidir.
    } catch (e) {
      rethrow;
    }
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _api.post(
        ApiConstats.refreshToken,
        request.toJson(),
      );

      return RefreshTokenResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
