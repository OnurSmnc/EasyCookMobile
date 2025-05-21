import 'package:easycook/core/data/models/login/login_request.dart';
import 'package:easycook/core/data/models/login/login_response.dart';
import 'package:easycook/core/data/models/refreshToken/refreshToken_request.dart';
import 'package:easycook/core/data/models/refreshToken/refreshToken_response.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstats.login,
        request.toJson(),
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstats.refreshToken,
        request.toJson(),
      );

      return RefreshTokenResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
