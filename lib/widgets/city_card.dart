import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CityCard extends StatelessWidget {
  final String city;
  final String temp;

  const CityCard({super.key, required this.city, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(city, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(temp, style: const TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }
}
