import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:weather_project_ex/components/daily_weather_view.dart';
import 'package:weather_project_ex/components/hourly_weather_view.dart';
import 'package:weather_project_ex/components/location_search_view.dart';
import 'package:weather_project_ex/components/current_weather_view.dart';
import 'package:weather_project_ex/components/add_info_view.dart';
import 'package:weather_project_ex/models/weather_provider.dart';
import 'package:weather_project_ex/models/weather_response.dart';
import 'package:weather_project_ex/services/weather.dart';
import 'package:weather_project_ex/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late WeatherResponse weatherRes;
  late String temperature, weatherDesc, date;
  late int weatherId;
  late bool isNight;
  late String locationName;
  late DateTime lastUpdate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    weatherRes = Provider.of<WeatherData>(context).weatherData!;
    updateUI(weatherRes);
  }

  void updateUI(WeatherResponse weatherRes) {
    setState(() {
      if (weatherRes == null) {
        temperature = '0';
        weatherId = 1000;
        weatherDesc = 'Unable to get weather data';
        return;
      }

      temperature = weatherRes.current.temp.round().toStringAsFixed(0);
      date = weather.timeStampToDate(weatherRes.current.dt.toInt());
      weatherId = weatherRes.current.weather.first.id.toInt();
      locationName = weatherRes.locationName;
      lastUpdate = DateTime.now();

      isNight = weather.isNight(
        weatherRes.current.dt,
        weatherRes.current.sunrise,
        weatherRes.current.sunset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = (MediaQuery.of(context).size.width);
    double screenHeight = (MediaQuery.of(context).size.height);
    var t = AppLocalizations.of(context);
    List<Color> colors = weather.getBackgroundColors(weatherId, isNight);

    return Scaffold(
      backgroundColor: colors[1],
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 4.0,
                    ),
                    LocationSearchView(
                      weatherResponse: weatherRes,
                      cityName: locationName,
                      startColor: colors[0],
                      endColor: colors[1],
                    ),
                    myMarginVertical(),
                    CurrentWeatherView(
                      icon: weather.getWeatherAnimation(weatherId, isNight),
                      description: weather.getWeatherDesc(weatherId, t!),
                      temp: temperature,
                      screenWidth: screenWidth,
                      lastUpdate: lastUpdate,
                    ),
                    myMarginVertical(),
                    HourlyWeatherView(weatherRes: weatherRes, weather: weather),
                    myMarginVertical(),
                    DailyWeatherView(daily: weatherRes.daily),
                    myMarginVertical(),
                    myDivider(),
                    WeatherInfoView(
                      windSpeed: weatherRes.current.windSpeed
                          .round()
                          .toStringAsFixed(0),
                      humidity: weatherRes.current.humidity
                          .round()
                          .toStringAsFixed(0),
                      realFeel: weatherRes.current.feelsLike
                          .round()
                          .toStringAsFixed(0),
                    ),
                    myMarginVertical(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
