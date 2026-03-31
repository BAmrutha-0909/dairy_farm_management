import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  static String? _token;
  static String? _email;

  static String get baseUrl => ApiConfig.baseUrl;

  // 🔴 LOGIN
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/auth/login");

      print("LOGIN URL: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data['token'];
        _email = data['email'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", _token!);
        await prefs.setString("email", _email!);

        return data;
      } else {
        return {
          "message": data['message'] ?? "Login failed",
          "status": response.statusCode
        };
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {
        "message": "Server error",
      };
    }
  }

  // 🔴 SIGNUP
  static Future<Map<String, dynamic>?> register(
      String name, String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/auth/register");

      print("REGISTER URL: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return data;
      } else {
        return {
          "message": data['message'] ?? "Register failed",
          "status": response.statusCode
        };
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      return {
        "message": "Server error",
      };
    }
  }

  // 🔴 LOAD SAVED USER
  static Future<bool> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString("token");
    _email = prefs.getString("email");

    return _token != null;
  }

  // 🔴 LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");
    await prefs.remove("email");

    _token = null;
    _email = null;
  }

  static String? getToken() => _token;
  static String? getCurrentUserEmail() => _email;
}