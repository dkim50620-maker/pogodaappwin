import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../theme/app_colors.dart';

class WeatherSearchScreen extends StatefulWidget {
  const WeatherSearchScreen({super.key});

  @override
  State<WeatherSearchScreen> createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  final _controller = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _error;

  void _search() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _weatherData = null;
    });

    final data = await WeatherService.fetchWeather(_controller.text);

    setState(() {
      _isLoading = false;
      if (data != null) {
        if (data.containsKey('error')) {
          _error = data['error']['message'];
        } else {
          _weatherData = data;
        }
      } else {
        _error = "Не удалось получить данные";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Поиск погоды (WeatherAPI)'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Введите город',
                hintStyle: const TextStyle(color: Colors.white54),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _search,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_weatherData != null) ...[
              Text(
                _weatherData!['location']['name'],
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "${_weatherData!['current']['temp_c']}°C",
                style: const TextStyle(color: Colors.white, fontSize: 64),
              ),
              Text(
                _weatherData!['current']['condition']['text'],
                style: const TextStyle(color: Colors.white70, fontSize: 20),
              ),
              Image.network(
                "https:${_weatherData!['current']['condition']['icon']}",
                scale: 0.5,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
