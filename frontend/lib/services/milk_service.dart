  import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'api_config.dart';

class MilkService {
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<List<dynamic>> getMilkRecords() async {
    try {
      final token = AuthService.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/milk"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print("MILK ERROR: $e");
      return [];
    }
  }
}