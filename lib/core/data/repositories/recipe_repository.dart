import 'dart:convert';
import 'dart:io';
import 'package:easycook/core/data/models/recipeapiresponse.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RecipeRepository {
  final ApiService _apiService;

  RecipeRepository(this._apiService);

  Future<RecipeApiResponse> detectIngredientsFromImage(File imageFile) async {
    final uri =
        Uri.parse('${ApiConstats.baseUrl}${ApiConstats.detectIngredients}');

    final extension = imageFile.path.split('.').last.toLowerCase();

    String mimeType;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        mimeType = 'jpeg';
        break;
      case 'png':
        mimeType = 'png';
        break;
      default:
        throw Exception('Desteklenmeyen dosya türü: .$extension');
    }

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(
          _apiService.defaultHeaders.map((key, value) => MapEntry(key, value))
            ..remove('Content-Type'))
      ..files.add(await http.MultipartFile.fromPath(
        'file', // ✅ Sunucunun beklediği form alanı adı
        imageFile.path,
        contentType: MediaType('image', mimeType),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return RecipeApiResponse.fromJson(json.decode(response.body));
    } else {
      print('Hata içeriği: ${response.body}');
      throw Exception('Malzeme tespiti başarısız: ${response.statusCode}');
    }
  }
}
