import 'dart:io';
import 'package:easycook/core/service/api_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2Mjk2NDBmMC0xNjZkLTRhMjYtYWZhNi1kNTYwZGI0OWE1MDkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjM5ODY2OTQ1LWJlZDMtNGQwMy00ZjlhLTA4ZGQ3NmE3Zjk4YiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6ImRlbmVtZTJAZ21haWwuY29tIiwiZXhwIjoxNzQ1MjYzMzExLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAifQ.vA2LcHzjiIFL91bjDP24utUr21J3DIYbGsdviLdYV7U'
    },
  });

  // Yeni eklenen: Resim veya dosya yükleme fonksiyonu
  Future<dynamic> uploadFile(String endpoint, File file,
      {String fieldName = 'file'}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');

      final request = http.MultipartRequest('POST', uri);

      // Header'lar (Content-Type burada multipart olduğu için elle yazma!)
      request.headers.addAll(
          defaultHeaders.map((key, value) => MapEntry(key, value))
            ..remove('Content-Type'));

      String? mimeType =
          lookupMimeType(file.path); // Dosya uzantısına göre mime type bulur
      if (mimeType == null) {
        throw ApiException('Desteklenmeyen dosya türü');
      }

      final mediaType = MediaType.parse(mimeType);

      // Dosya ekleme
      request.files.add(await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: MediaType('image', 'jpeg'),
        filename: basename(file.path),
      ));

      // İsteği gönder
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
        headers: {...defaultHeaders, ...?headers},
      );
      return _processResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  Future<dynamic> post(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      // Veriyi JSON'a dönüştürmeden önce kontrol et
      var bodyData = data;
      if (data is String) {
        bodyData = {'data': data}; // String'i JSON objesi içine al
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...defaultHeaders, ...?headers},
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
        headers: {...defaultHeaders, ...?headers},
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
        headers: {...defaultHeaders, ...?headers},
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
        throw UnauthorizedException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
      default:
        throw ServerException('${response.statusCode}: ${response.body}');
    }
  }
}
