import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruang_sehat/features/auth/data/user_model.dart';

class AuthServices {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String authBaseUrl = '$baseUrl/auth';

  //Fungsi Service Register
  static Future<http.Response> register(
    String name,
    String username,
    String password,
  ) async {
    final url = Uri.parse("$authBaseUrl/register");

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "username": username,
        "password": password,
        "appSource": "Kesehatan",
      }),
    );
  }

  //Fungsi Service Login
  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse("$authBaseUrl/login");

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
        "appSource": "Kesehatan",
      }),
    );
  }

  // fungsi service logout
  static Future<http.Response> logout() async {
    final url = Uri.parse('$authBaseUrl/logout');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  // fungsi service get profile
  static Future<UserModel> getProfile() async {
    final url = Uri.parse('$baseUrl/auth/profile');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer $token',
      },
    );

    if (response.statusCode == 200){
      final decoded = jsonDecode(response.body);
      final data = decoded['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Gagal Mengambil profil');
    }
  }
}