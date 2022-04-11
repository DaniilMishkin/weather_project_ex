import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_project_ex/components/last_update_view.dart';
import 'package:weather_project_ex/utilities/constants.dart';

class CurrentWeatherView extends StatelessWidget {
  const CurrentWeatherView({
    Key? key,
    required this.icon,
    required this.description,
    required this.temp,
    required this.screenWidth,
    required this.lastUpdate,
  }) : super(key: key);

  final String icon;
  final String description;
  final String temp;
  final double screenWidth;
  final DateTime lastUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/$icon',
          width: (screenWidth - ((screenWidth / 100) * 40)),
          height: 200,
        ),
        Text(
          description,
          style: kLargeTitleTextStyle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '°',
              style: kTemperatureAlphaTextStyle,
            ),
            Text(
              temp,
              style: kTemperatureTextStyle,
            ),
            const Text(
              '°',
              style: kTemperatureTextStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        LastUpdateView(lastUpdate: lastUpdate),
        const SizedBox(
          height: 12.0,
        ),
      ],
    );
  }
}
