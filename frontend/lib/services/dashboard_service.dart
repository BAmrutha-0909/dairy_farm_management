import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'api_config.dart';

class DashboardService {
  static String get baseUrl => ApiConfig.baseUrl;

  // 🔴 GET ANIMALS
  static Future<List<dynamic>> getAnimals() async {
    final token = AuthService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/animals"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }

  // 🔴 GET MILK
  static Future<List<dynamic>> getMilkLogs() async {
    final token = AuthService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/milk"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }
}