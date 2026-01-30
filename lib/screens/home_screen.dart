import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/weather_card.dart';
import '../widgets/add_city_modal.dart';
import '../screens/cities_screen.dart';
import '../screens/weather_search_screen.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> _cities = [
    {'name': 'Montreal', 'temp': '...'},
    {'name': 'Toronto', 'temp': '...'},
    {'name': 'Tokyo', 'temp': '...'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchInitialWeather();
  }

  Future<void> _fetchInitialWeather() async {
    for (int i = 0; i < _cities.length; i++) {
      final data = await WeatherService.fetchWeather(_cities[i]['name']!);
      if (data != null && mounted) {
        setState(() {
          _cities[i]['temp'] = "${data['current']['temp_c'].round()}°";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          CitiesScreen(
            cities: _cities,
            onSelect: (index) {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          const WeatherSearchScreen(),
        ],
      ),

      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: _showAddCityModal,
        backgroundColor: AppColors.fab,
        child: const Icon(Icons.add),
      )
          : null,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Cities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Weather Search',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 80, bottom: 50),
      child: Column(
        children: [
          Image.asset(
            'assets/house.png',
            width: 220,
            height: 220,
          ),
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _cities
                .map(
                  (city) => WeatherCard(
                time: city['name']!,
                temp: city['temp']!,
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showAddCityModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => AddCityModal(
        onAdd: (name, temp) {
          setState(() {
            _cities.add({'name': name, 'temp': temp});
          });
          _fetchWeatherForNewCity(name);
        },
      ),
    );
  }

  Future<void> _fetchWeatherForNewCity(String name) async {
    final data = await WeatherService.fetchWeather(name);
    if (data != null && mounted) {
      setState(() {
        final index = _cities.indexWhere((c) => c['name'] == name);
        if (index != -1) {
          _cities[index]['temp'] = "${data['current']['temp_c'].round()}°";
        }
      });
    }
  }
}
