class CityWeather {
  final String name;
  final String temp;
  final String status;
  bool showOnHome;

  CityWeather({
    required this.name,
    required this.temp,
    required this.status,
    this.showOnHome = false,
  });
}
