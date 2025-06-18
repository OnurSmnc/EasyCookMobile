import 'package:easycook/core/data/models/allergenics/allergenic_request.dart';
import 'package:easycook/core/data/models/allergenics/allergenic_response.dart';
import 'package:easycook/core/data/models/allergenics/remove_allergenic_request.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';

class AllergyRepository {
  final ApiService _api = ApiService();

  Future<List<AllergenicResponse>> addAlleryRequest(
      AllergyRequest request) async {
    try {
      final response = await _api.post(
        ApiConstats.addAllergy,
        request.toJson(),
      );
      if (response is List) {
        return response
            .map<AllergenicResponse>(
                (e) => AllergenicResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Beklenmeyen API cevabı: $response');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RemoveAllergenicRespone> removeAllergy(
      RemevoAllergyRequest request) async {
    try {
      final response = await _api.post(
        ApiConstats.deleteAllergy,
        request.toJson(),
      );

      return RemoveAllergenicRespone.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
