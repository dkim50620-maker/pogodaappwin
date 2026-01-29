import 'package:flutter/material.dart';
import '../models/city_weather.dart';
import '../theme/app_colors.dart';
import '../services/weather_service.dart';

class ManageCitiesScreen extends StatefulWidget {
  final List<CityWeather>? cities;
  final bool searchOnly;
  final Function(List<CityWeather>)? onCitiesUpdated;

  const ManageCitiesScreen({super.key, this.cities, this.searchOnly = false, this.onCitiesUpdated});

  @override
  State<ManageCitiesScreen> createState() => _ManageCitiesScreenState();
}

class _ManageCitiesScreenState extends State<ManageCitiesScreen> {
  List<CityWeather> cities = [];
  List<CityWeather> filtered = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    cities = widget.cities ?? [];
    filtered = List.from(cities);
  }

  void _search(String query) {
    setState(() {
      filtered = cities.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<void> _addCity(String name) async {
    final weather = await WeatherService.fetchWeather(name);
    if (weather != null) {
      final city = CityWeather(name: weather['name'], temp: weather['temp'], status: weather['status']);
      if (widget.searchOnly) {
        Navigator.of(context).pop(city);
      } else {
        setState(() {
          cities.add(city);
          filtered = List.from(cities);
          widget.onCitiesUpdated?.call(cities);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _search,
            decoration: const InputDecoration(
              hintText: 'Search city',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final city = filtered[index];
                return ListTile(
                  title: Text(city.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${city.temp.toStringAsFixed(0)}° | ${city.status}', style: const TextStyle(color: Colors.white70)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: city.showOnHome,
                        onChanged: (v) {
                          setState(() {
                            city.showOnHome = v ?? true;
                            widget.onCitiesUpdated?.call(cities);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            cities.remove(city);
                            filtered = List.from(cities);
                            widget.onCitiesUpdated?.call(cities);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
