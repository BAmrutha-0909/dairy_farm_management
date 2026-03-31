import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AnimalService {

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ADD
  static Future<void> addAnimal(Map data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("${ApiConfig.baseUrl}/animals"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(data),
  );

  print("ADD STATUS: ${res.statusCode}");
  print("ADD BODY: ${res.body}");
}

  // GET
  static Future<List<dynamic>> getAnimals() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  final res = await http.get(
    Uri.parse("${ApiConfig.baseUrl}/animals"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  print("GET STATUS: ${res.statusCode}");
  print("GET BODY: ${res.body}");

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }

  return [];
}
  // UPDATE
  static Future<void> updateAnimal(String id, Map data) async {
    final token = await _getToken();

    await http.put(
      Uri.parse("${ApiConfig.baseUrl}/animals/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
  }
}