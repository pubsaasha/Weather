import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true).toLocal();
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(240, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(94, 184, 180, 241),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color.fromARGB(94, 1, 3, 16)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                weather.description.toLowerCase().contains('rain')
                    ? 'assets/rain.json'
                    : weather.description.toLowerCase().contains('clear')
                        ? 'assets/sunny.json'
                        : 'assets/cloudy.json',
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w600,
                      shadows: [
                        const Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Color.fromARGB(61, 0, 0, 0),
                        )
                      ],
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 36,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                weather.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color.fromARGB(179, 0, 0, 0),
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.water_drop_outlined, color: Colors.cyanAccent),
                      const SizedBox(width: 4),
                      Text(
                        'Humidity: ${weather.humidity}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.air, color: Colors.lightBlueAccent),
                      const SizedBox(width: 4),
                      Text(
                        'Wind: ${weather.windSpeed} m/s',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// 🌅 Improved Sunrise & Sunset UI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSunTimeTile(
                    icon: Icons.wb_sunny_outlined,
                    iconColor: Colors.amber,
                    label: 'Sunrise',
                    time: formatTime(weather.sunrise),
                  ),
                  _buildSunTimeTile(
                    icon: Icons.nights_stay_outlined,
                    iconColor: Colors.deepPurpleAccent,
                    label: 'Sunset',
                    time: formatTime(weather.sunset),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ☀️ Reusable sun time widget
  Widget _buildSunTimeTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(17, 0, 0, 0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
              ),
              Text(
                time,
                style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
