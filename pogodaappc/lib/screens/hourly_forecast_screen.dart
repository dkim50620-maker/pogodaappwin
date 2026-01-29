import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../theme/app_colors.dart';

class HourlyForecastScreen extends StatelessWidget {
  final List<HourlyWeather> hourlyData;

  const HourlyForecastScreen({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final data = hourlyData[index];
          return Container(
            width: 70,
            margin: EdgeInsets.only(right: index == hourlyData.length - 1 ? 0 : 15),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.time, style: TextStyle(color: Colors.white70, fontSize: 14)),
                if (data.chance != null) Text(data.chance!, style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12)),
                const SizedBox(height: 8),
                Text(data.temp, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }
}
