import 'package:flutter/material.dart';
import '../widgets/city_card.dart';

class CitiesScreen extends StatelessWidget {
  final List<Map<String, String>> cities;
  final Function(int) onSelect;

  const CitiesScreen({super.key, required this.cities, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return GestureDetector(
          onTap: () => onSelect(index),
          child: CityCard(city: city['name']!, temp: city['temp']!),
        );
      },
    );
  }
}
