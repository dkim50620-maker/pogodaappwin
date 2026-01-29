import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/weather_card.dart';
import '../widgets/add_city_modal.dart';
import '../screens/cities_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Map<String, String>> _cities = [
    {'name': 'Montreal', 'temp': '10°'},
    {'name': 'Toronto', 'temp': '12°'},
    {'name': 'Tokyo', 'temp': '15°'},
  ];

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
              final selected = _cities[index];
              // добавление выбранного города на главную
              setState(() {
                // логика добавления выбранного города на главную
              });
              _currentIndex = 0;
            },
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: _showAddCityModal,
        backgroundColor: AppColors.fab,
        child: const Icon(Icons.add),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background, // здесь фон
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_city), label: 'Cities'),
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
            width: 220,  // увеличил размер
            height: 220,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _cities
                .map((city) => WeatherCard(time: city['name']!, temp: city['temp']!))
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
      backgroundColor: AppColors.background, // фон модалки
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => AddCityModal(onAdd: (name, temp) {
        setState(() {
          _cities.add({'name': name, 'temp': temp});
        });
      }),
    );
  }
}
