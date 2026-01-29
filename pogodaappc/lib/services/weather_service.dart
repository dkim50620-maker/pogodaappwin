import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_weather.dart';
import '../models/weather_data.dart';

class WeatherService {
  static const String apiKey = "YOUR_API_KEY"; // вставь свой
  static const String baseUrl = "https://api.openweathermap.org/data/2.5";

  static Future<CityWeather?> fetchWeather(String city) async {
    final url = Uri.parse("$baseUrl/weather?q=$city&units=metric&appid=$apiKey");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CityWeather(
        name: data['name'],
        temp: "${data['main']['temp'].round()}°",
        status: data['weather'][0]['main'],
      );
    }
    return null;
  }

  static Future<List<HourlyWeather>> fetchHourly(String city) async {
    final url = Uri.parse("$baseUrl/forecast?q=$city&units=metric&appid=$apiKey");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['list'];
      return List.generate(5, (index) {
        final item = data[index * 3]; // каждые 3 часа
        return HourlyWeather(
          time: item['dt_txt'].substring(11, 16),
          temp: "${item['main']['temp'].round()}°",
          chance: "${(item['pop'] * 100).round()}%",
        );
      });
    }
    return [];
  }
}
