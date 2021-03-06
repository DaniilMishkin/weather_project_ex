import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_project_ex/models/weather_provider.dart';
import 'package:weather_project_ex/models/weather_response.dart';
import 'package:weather_project_ex/screens/search_screen.dart';
import 'package:weather_project_ex/utilities/constants.dart';

class LocationSearchView extends StatelessWidget {
  final WeatherResponse weatherResponse;
  final String cityName;
  final Color startColor;
  final Color endColor;

  const LocationSearchView(
      {Key? key,
      required this.weatherResponse,
      required this.cityName,
      required this.startColor,
      required this.endColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            color: kIconColor,
            size: kIconSize,
          ),
          const SizedBox(
            width: kMargin2x,
          ),
          Text(
            cityName,
            style: kHeadlineTextStyle,
          ),
        ],
      ),
      onTap: () async {
        final weatherData =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SearchView(
            startColor: startColor,
            endColor: endColor,
          );
        }));
        if (weatherData != null) {
          Provider.of<WeatherData>(context, listen: false)
              .changeData(weatherData);
        }
      },
    );
  }
}
