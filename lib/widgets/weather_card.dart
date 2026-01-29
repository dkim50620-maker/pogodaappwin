import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WeatherCard extends StatelessWidget {
  final String time;
  final String temp;
  final String? chance;

  const WeatherCard({super.key, required this.time, required this.temp, this.chance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: TextStyle(color: Colors.white70, fontSize: 14)),
          if (chance != null) ...[
            const SizedBox(height: 4),
            Text(chance!, style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12)),
          ],
          const SizedBox(height: 4),
          Text(temp, style: const TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }
}
