import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = "f65e59d8e80d4c1391652742263001";
  static const String baseUrl = "https://api.weatherapi.com/v1";

  // Метод для получения текущей погоды
  static Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url = Uri.parse("$baseUrl/current.json?key=$apiKey&q=$city&aqi=no&lang=ru");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print("Ошибка при получении погоды: $e");
    }
    return null;
  }

  // Метод для получения прогноза (включая почасовой)
  static Future<Map<String, dynamic>?> fetchForecast(String city) async {
    final url = Uri.parse("$baseUrl/forecast.json?key=$apiKey&q=$city&days=1&aqi=no&alerts=no&lang=ru");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print("Ошибка при получении прогноза: $e");
    }
    return null;
  }
}
