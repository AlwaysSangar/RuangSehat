import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:ruang_sehat/features/articles/data/articles_model.dart';

class ArticlesServices {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String articlesBaseUrl = '$baseUrl/article';

  // helper private
  static Future<dynamic> _getRequest(
    String endpoint,
    {Map<String, String>? queryParameters,}
    ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token tidak ditemukan');

    var urlString = '$articlesBaseUrl$endpoint';
    if (queryParameters != null && queryParameters.isNotEmpty){
      final queryString = Uri(queryParameters: queryParameters).query;
      urlString += '?$queryString';
    }

    final url = Uri.parse(urlString);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Format responses tidak valid');
    }

    if (decoded['success'] != true) {
      if (decoded['errors'] != null &&
          decoded['errors'] is List &&
          decoded['errors'].isNotEmpty) {
        throw Exception(decoded['errors'] [0] ['message']);  
      } else {
        throw Exception(decoded['message'] ?? 'Terjadi kesalahan');
      }
    }

    return decoded['data'];
  }

  static Future<Map<String, dynamic>> gerArticles({
    int page = 1,
    int limit = 10,
  }) async {
    final data = await _getRequest(
      '',
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );
    final List articles = data['articles'] ?? [];
    return {
      'articles': articles.map((e) => ArticlesModel.fromJson(e)).toList(),
      'totalPages': data['totalPages'] ?? 1,
    };
  }

  static Future<List<ArticlesModel>> getMyArticles() async {
    final data = await _getRequest('/user');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticlesModel.fromJson(e)).toList();
  }

  static Future<ArticlesModel> getDetailArticle(String id) async {
    final data = await _getRequest('/$id');
    return ArticlesModel.fromJson(data);
  }

  static Future<http.StreamedResponse> createArtikel(
    File image,
    String title,
    String description,
    String category,
  ) async {
    final uri = Uri.parse('$articlesBaseUrl/create');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest('POST', uri);
    request.headers ['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = DateTime.now().toIso8601String();
    request.fields['category'] = category;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    return await request.send();
  }

  static Future<http.StreamedResponse> updateArtikel(
    String id, {
      File? image,
      String? title,
      String? description,
      String? category,
    }) async {
      final uri = Uri.parse('$articlesBaseUrl/update/$id');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (title != null && title.isNotEmpty) request.fields['title'] = title;
      if (description != null && description.isNotEmpty){
        request.fields['description'] = description;
      }
      if (category != null && category.isNotEmpty){
        request.fields['category'] = category;
      }
      if (image != null){
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      return await request.send();
    }

  static Future<http.Response> deleteArtikel(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var url = Uri.parse('$articlesBaseUrl/delete/$id');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}