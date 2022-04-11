import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_project_ex/models/daily_weather.dart';
import 'package:weather_project_ex/services/weather.dart';
import 'package:weather_project_ex/utilities/constants.dart';

class DailyWeatherView extends StatefulWidget {
  const DailyWeatherView({Key? key, required this.daily}) : super(key: key);
  final List<DailyWeather> daily;

  @override
  _DailyWeatherViewState createState() => _DailyWeatherViewState();
}

class _DailyWeatherViewState extends State<DailyWeatherView> {
  String sevenDaysText = "";

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    WeatherModel weather = WeatherModel();
    setState(() {
      sevenDaysText = t!.sevenDayForecast;
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: kCardBackgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              sevenDaysText,
              style: kSubHeadlineTextStyle,
            ),
          ),
          DailyItem(
            weather: weather,
            daily: widget.daily,
            dayName: t!.today,
            index: 0,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (context, index) {
              return DailyItem(
                  weather: weather,
                  daily: widget.daily,
                  dayName: weather.timestampToDay(
                      widget.daily[index + 1].dt.toInt(), t),
                  index: index + 1);
            },
          ),
          const SizedBox(
            height: kMargin2x,
          ),
        ],
      ),
    );
  }
}

class DailyItem extends StatelessWidget {
  const DailyItem({
    Key? key,
    required this.weather,
    required this.daily,
    required this.dayName,
    required this.index,
  }) : super(key: key);

  final WeatherModel weather;
  final List<DailyWeather> daily;
  final String dayName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              dayName,
              style: kHeadlineTextStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Lottie.asset(
                'assets/${weather.getWeatherAnimation(daily[index].weather.first.id.toInt(), false)}',
                width: kDailyIconSize,
                height: kDailyIconSize,
                animate: false),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${daily[index].temp.max.round().toStringAsFixed(0)}°',
                    style: kHeadlineTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${daily[index].temp.min.round().toStringAsFixed(0)}°',
                    style: kHeadlineTertiaryTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
