import 'package:easycook/core/data/models/user/password/password_request.dart';
import 'package:easycook/core/data/models/user/userInfo/get_user_info.dart';
import 'package:easycook/core/data/models/user/userInfo/update_userInfo_request.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class UserRepository {
  final ApiService _api = ApiService();

  Future<String> changePassword(PasswordRequest request) async {
    try {
      final response = await _api.put(
        ApiConstats.changePassword,
        request.toJson(),
      );

      return "success"; // Genellikle register işlemi bir yanıt döndürmez, sadece başarılı olması yeterlidir.
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateUserProfile(UpdateUserInfo request) async {
    try {
      final response = await _api.put(
        ApiConstats.updateUserInfo,
        request.toJson(),
      );

      return "success"; // Genellikle profil güncelleme işlemi bir yanıt döndürmez, sadece başarılı olması yeterlidir.
    } catch (e) {
      rethrow;
    }
  }

  Future<UserInfo> getUserInfo() async {
    try {
      final response = await _api.get(ApiConstats.getUserInfo);
      if (response is Map<String, dynamic>) {
        // Cast the response to a Map<String, dynamic>
        final Map<String, dynamic> userData = response;
        print('User info data: $userData');

        // Parse the single user object from the map
        return UserInfo.fromJson(userData);
      } else {
        // If the API returns something unexpected (e.g., a list or null), throw an error
        print(
            'UserRepository - getUserInfo error: API did not return a single user object. Response type: ${response.runtimeType}');
        throw Exception('Invalid API response format for user information.');
      }
    } catch (e) {
      print('UserRepository - getUserInfo failed: $e');
      // Re-throw the error to be handled by the calling widget/bloc,
      // or return a default/empty UserInfo if your UserInfo model supports it.
      // For example:
      // return UserInfo(userId: '', userName: '', lastName: '', fullName: '', email: ''); // If UserInfo has a default constructor
      throw Exception(
          'Failed to fetch user information.'); // Re-throw a more specific error
    }
  }
  // This class will handle
}
