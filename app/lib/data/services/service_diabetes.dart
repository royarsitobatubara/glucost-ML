import 'package:app/data/services/api_service.dart';

class DiabetesService {
  static Future<Map<String, dynamic>> predict(Map<String, dynamic> data) {
    return ApiService.diabetesPredict(data);
  }
}