import 'dart:io';
import 'package:easycook/core/service/api_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class ApiService {
  // ✅ Singleton instance - tek bir kez oluşturulur
  static ApiService? _instance;

  // ✅ Factory constructor - her çağrıldığında aynı instance döner
  factory ApiService({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    String? bearerToken,
  }) {
    // İlk kez çağrıldığında instance oluştur
    if (_instance == null) {
      _instance = ApiService._internal(
        baseUrl: baseUrl ?? 'https://api.example.com',
        defaultHeaders: defaultHeaders ??
            const {
              'Content-Type': 'application/json',
            },
        bearerToken: bearerToken,
      );
    }
    return _instance!;
  }

  // Private constructor
  ApiService._internal({
    required this.baseUrl,
    required this.defaultHeaders,
    String? bearerToken,
  }) : _bearerToken = bearerToken;

  final String baseUrl;
  final Map<String, String> defaultHeaders;

  // ✅ Bu değişken singleton instance'da korunur
  String? _bearerToken;

  // ✅ Token'ı set et - bir kez set edilince kalıcı olur
  void updateAuthorizationHeader(String token) {
    _bearerToken = token;
    print("🔑 Token set edildi: $_bearerToken");
  }

  // Token getter
  String? get bearerToken => _bearerToken;

  // Token temizleme (logout için)
  void clearToken() {
    _bearerToken = null;
    print("🔑 Token temizlendi");
  }

  Map<String, String> _getHeaders([Map<String, String>? extra]) {
    final headers = {...defaultHeaders, ...?extra};
    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
      print("🔑 Authorization header eklendi: Bearer $_bearerToken");
    }
    return headers;
  }

  // Resim veya dosya yükleme fonksiyonu
  Future<dynamic> uploadFile(String endpoint, File file,
      {String fieldName = 'file'}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');

      final request = http.MultipartRequest('POST', uri);

      // ✅ Authorization header otomatik eklenir
      final headers = _getHeaders();
      request.headers.addAll(headers);

      String? mimeType = lookupMimeType(file.path);
      if (mimeType == null) {
        throw ApiException('Desteklenmeyen dosya türü');
      }

      final mediaType = MediaType.parse(mimeType);

      request.files.add(await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: MediaType('image', 'jpeg'),
        filename: basename(file.path),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } catch (e) {
      throw ApiException('File upload failed: $e');
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(headers), // ✅ Token otomatik eklenir
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  Future<dynamic> post(String? endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      var bodyData = data;
      if (data is String) {
        bodyData = {'data': data};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(headers), // ✅ Token otomatik eklenir
        body: json.encode(bodyData),
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e');
    }
  }

  Future<dynamic> put(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(headers), // ✅ Token otomatik eklenir
        body: json.encode(data),
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('PUT request failed: $e');
    }
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(headers), // ✅ Token otomatik eklenir
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('DELETE request failed: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        }
        return null;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        // ✅ 401 hatası durumunda token'ı temizle (session expired)
        print("🚨 401 Unauthorized - Token temizleniyor");
        clearToken();
        throw UnauthorizedException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
      default:
        throw ServerException('${response.statusCode}: ${response.body}');
    }
  }
}
