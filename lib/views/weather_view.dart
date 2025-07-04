import 'package:flutter/material.dart';
import 'package:couteau_app/services/api_service.dart';
import 'package:couteau_app/utils/string_extensions.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String _weatherInfo = 'Cargando clima para Santo Domingo...';
  bool _isLoading = true;
  String _weatherIconUrl = '';

  static const String _apiKey = '786c1a0bea2475fa5b14d51ce7c4d9e0';
  static const String _city = 'Santo Domingo';
  static const String _countryCode = 'DO';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    if (_apiKey.isEmpty || _apiKey == 'YOUR_OPENWEATHERMAP_API_KEY') {
      if (mounted) {
        setState(() {
          _weatherInfo =
              'Error: Por favor, inserta tu clave de API de OpenWeatherMap en weather_view.dart';
          _isLoading = false;
        });
      }
      return;
    }

    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city,$_countryCode&appid=$_apiKey&units=metric&lang=es';

    try {
      final data = await ApiService.fetchData(url);

      if (!mounted) return;

      final String weatherDescription =
          (data['weather'][0]['description'] as String);
      final double temperature = (data['main']['temp'] as num).toDouble();
      final double feelsLike = (data['main']['feels_like'] as num).toDouble();
      final int humidity = data['main']['humidity'] as int;
      final String iconCode = (data['weather'][0]['icon'] as String);

      setState(() {
        _weatherInfo = 'Clima en $_city hoy:\n'
            '${weatherDescription.capitalizeFirstOfEachWord()}\n'
            'Temperatura: ${temperature.toStringAsFixed(1)}°C\n'
            'Sensación térmica: ${feelsLike.toStringAsFixed(1)}°C\n'
            'Humedad: $humidity%';
        _weatherIconUrl =
            'https://openweathermap.org/img/wn/$iconCode@2x.png';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherInfo =
              'Error al obtener el clima: $e. Verifica tu clave API o conexión.';
          _isLoading = false;
          _weatherIconUrl = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                if (_weatherIconUrl.isNotEmpty)
                  Image.network(
                    _weatherIconUrl,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100),
                  ),
                const SizedBox(height: 20),
                Text(
                  _weatherInfo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _fetchWeather,
                child: const Text('Actualizar Clima'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
