import 'package:flutter/material.dart';
import 'package:myapp/models/weather_model.dart';
import 'package:myapp/services/weather_services.dart';
import 'package:myapp/widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  Weather? _weather;

  void _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherServices.featchWeather(_controller.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching weather data')),
      );
    }
  }

  /// Dynamically return background gradient based on weather description
  LinearGradient _getGradientFromDescription(String description) {
    final desc = description.toLowerCase();

    if (desc.contains('rain')) {
      return const LinearGradient(
        colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('clear') || desc.contains('sunny')) {
      return const LinearGradient(
        colors: [Color(0xFFFFF200), Color(0xFFFFC300), Color(0xFFFF6F00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (desc.contains('cloud') || desc.contains('overcast')) {
      return const LinearGradient(
        colors: [Color.fromARGB(235, 173, 171, 180), Color.fromARGB(255, 8, 6, 39)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('snow')) {
      return const LinearGradient(
        colors: [Color.fromARGB(255, 190, 213, 248), Color.fromARGB(255, 227, 245, 250)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      // Default gradient for unknown conditions
      return const LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: _weather != null
              ? _getGradientFromDescription(_weather!.description)
              : const LinearGradient(
                  colors: [Color.fromARGB(255, 136, 53, 245), Color.fromARGB(255, 255, 255, 255)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Current Weather',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter your City Name",
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 85, 75, 75)),
                    filled: true,
                    fillColor: const Color.fromARGB(216, 255, 255, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: const Color.fromARGB(255, 35, 7, 83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 24.0),
                  ),
                  child: const Text(
                    'Get Weather',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                if (_weather != null) WeatherCard(weather: _weather!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
