import 'package:weather_project_ex/models/current_weather.dart';
import 'package:weather_project_ex/models/daily_weather.dart';
import 'package:weather_project_ex/models/hourly_weather.dart';

class WeatherResponse {
  WeatherResponse({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.current,
    required this.hourly,
    required this.daily,
  });
  late final num lat;
  late final num lon;
  late final String timezone;
  late final num timezoneOffset;
  late final CurrentWeather current;
  late final List<HourlyWeather> hourly;
  late final List<DailyWeather> daily;
  late final String locationName;

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    timezone = json['timezone'];
    timezoneOffset = json['timezone_offset'];
    current = CurrentWeather.fromJson(json['current']);
    hourly = List.from(json['hourly'])
        .map((e) => HourlyWeather.fromJson(e))
        .toList();
    daily =
        List.from(json['daily']).map((e) => DailyWeather.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lon'] = lon;
    _data['timezone'] = timezone;
    _data['timezone_offset'] = timezoneOffset;
    _data['current'] = current.toJson();
    _data['hourly'] = hourly.map((e) => e.toJson()).toList();
    _data['daily'] = daily.map((e) => e.toJson()).toList();
    return _data;
  }
}
