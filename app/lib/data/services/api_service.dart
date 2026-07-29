import 'dart:convert';
import 'package:app/core/app_api.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // OBESITAS
  static Future<Map<String, dynamic>> obesitasPredict(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(AppApi.obesitasUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Gagal melakukan prediksi obesitas");
  }

  // DIABETES
  static Future<Map<String, dynamic>> diabetesPredict(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(AppApi.diabetesUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Gagal melakukan prediksi");
  }

  // Heart
  static Future<Map<String, dynamic>> heartAttackPredict(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(AppApi.heartAttackUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Gagal melakukan prediksi");
  }

  // STRESS
  static Future<Map<String, dynamic>> stressPredict(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(AppApi.stressUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Gagal melakukan prediksi");
  }
}