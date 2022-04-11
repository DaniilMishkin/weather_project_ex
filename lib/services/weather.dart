// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:weather_project_ex/models/weather_response.dart';
import 'package:weather_project_ex/services/location.dart';
import 'package:weather_project_ex/services/networking.dart';
import 'package:weather_project_ex/utilities/constants.dart';

num latitude = 0.0;
num longitude = 0.0;
bool isPass = false;
String units = '';

class WeatherModel {
  Future<dynamic> getLocation(BuildContext context) async {
    Location location = Location();
    await location.determinePosition(context);

    var t = AppLocalizations.of(context);
    units = t!.units;

    latitude = location.latitude;
    longitude = location.longitude;

    print(latitude.toString() + " " + longitude.toString());
    return getOneCallWeather();
  }

  Future<dynamic> getOneCallWeather() async {
    isPass = false;
    NetworkResponse networkResponse = NetworkResponse(
        '$ONE_CALL_WEATHER_URL?lat=$latitude&lon=$longitude&exclude=minutely,alert&units=$units&appid=$API_Key');

    WeatherResponse? weatherData = await networkResponse.getOneCallWeather();
    return weatherData;
  }

  Future<String> getLocationName() async {
    NetworkResponse networkResponse = NetworkResponse(
        '$CURRENT_WEATHER_URL?lat=$latitude&lon=$longitude&units=$units&appid=$API_Key');
    dynamic weatherData = await networkResponse.getCurrentWeather();
    if (weatherData.toString().isNotEmpty) {
      return weatherData['name'];
    }
    return "";
  }

  Future<String> locationNameToLongLat(String search) async {
    NetworkResponse networkResponse = NetworkResponse(
        '$CURRENT_WEATHER_URL?q=$search&units=$units&appid=$API_Key');
    dynamic weatherData = await networkResponse.getCurrentWeather();
    if (weatherData.toString().isNotEmpty) {
      latitude = weatherData['coord']['lat'];
      longitude = weatherData['coord']['lon'];
      print(latitude.toString() + " " + longitude.toString());
      return weatherData['name'];
    }
    return "";
  }

  String getWeatherAnimation(int id, bool isNight) {
    if (id >= 200 && id <= 202) {
      return 'weather-storm.json';
    } else if (id >= 210 && id <= 221) {
      return 'weather-thunder.json';
    } else if (id >= 230 && id <= 232) {
      return 'weather-storm.json';
    } else if (id >= 301 && id <= 321) {
      if (isNight) {
        return 'weather-night-rainy.json';
      }
      return 'weather-rainy.json';
    } else if (id >= 500 && id <= 531) {
      if (isNight) {
        return 'weather-night-rainy.json';
      }
      return 'weather-rainy.json';
    } else if (id >= 600 && id <= 622) {
      if (isNight) {
        return 'weather-night-snow.json';
      }
      return 'weather-snow.json';
    } else if (id >= 701 && id <= 781) {
      return 'weather-mist.json';
    } else if (id == 800) {
      if (isNight) {
        return 'weather-night-clear.json';
      }
      return 'weather-sunny.json';
    } else if (id >= 801 && id <= 804) {
      if (isNight) {
        return 'weather-night-cloudy.json';
      }
      return 'weather-cloudy.json';
    } else {
      if (isNight) {
        return 'weather-night-cloudy.json';
      }
      return 'weather-cloudy.json';
    }
  }

  List<Color> getBackgroundColors(int id, bool isNight) {
    if (isNight) {
      return [kNightStartColor, kNightEndColor];
    } else {
      if (id >= 200 && id <= 202) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id >= 210 && id <= 221) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id >= 230 && id <= 232) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id >= 301 && id <= 321) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id >= 500 && id <= 531) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id >= 600 && id <= 622) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id >= 701 && id <= 781) {
        return [kRainyStartColor, kRainyEndColor];
      } else if (id == 800) {
        return [kClearStartColor, kClearEndColor];
      } else if (id >= 801 && id <= 804) {
        return [kCloudyStartColor, kCloudyEndColor];
      } else {
        return [kCloudyStartColor, kCloudyEndColor];
      }
    }
  }

  String getWeatherDesc(int id, AppLocalizations t) {
    if (id >= 200 && id <= 202) {
      return t.thunderstormWithLightRain;
    } else if (id >= 210 && id <= 221) {
      return t.thunderstorm;
    } else if (id >= 230 && id <= 232) {
      return t.thunderstormWithLightRain;
    } else if (id >= 300 && id <= 321) {
      return t.drizzle;
    } else if (id >= 500 && id <= 502) {
      return t.rain;
    } else if (id >= 503 && id <= 531) {
      return t.showerRain;
    } else if (id >= 600 && id <= 622) {
      return t.snow;
    } else if (id >= 701 && id <= 771) {
      return t.mist;
    } else if (id == 781) {
      return t.tornado;
    } else if (id == 800) {
      return t.clear;
    } else if (id == 801) {
      return t.fewClouds;
    } else if (id == 802) {
      return t.scatteredClouds;
    } else if (id == 803) {
      return t.brokenClouds;
    } else if (id == 804) {
      return t.overcastClouds;
    } else {
      return t.fewClouds;
    }
  }

  String timeStampToDate(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd MMM').format(dt);
  }

  String timestampToHour(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:mm').format(dt);
  }

  String timestampToDay(int timestamp, AppLocalizations t) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var dayName = DateFormat().add_EEEE().format(dt);
    if (dayName.toLowerCase() == "monday") {
      return t.monday;
    } else if (dayName.toLowerCase() == "tuesday") {
      return t.tuesday;
    } else if (dayName.toLowerCase() == "wednesday") {
      return t.wednesday;
    } else if (dayName.toLowerCase() == "thursday") {
      return t.thursday;
    } else if (dayName.toLowerCase() == "friday") {
      return t.friday;
    } else if (dayName.toLowerCase() == "saturday") {
      return t.saturday;
    } else if (dayName.toLowerCase() == "sunday") {
      return t.sunday;
    } else {
      return dayName;
    }
  }

  bool isNight(num dt, num sunrise, num sunset) {
    if (dt <= sunrise || dt >= sunset) {
      return true;
    } else {
      return false;
    }
  }

  bool isNightForHourly(num now, num time, num sunrise, num sunset) {
    if (timestampToHour(time.toInt()) == "00:00" &&
        timestampToHour(now.toInt()) != "00:00") {
      isPass = true;
    }

    if (isPass) {
      sunrise += 86400;
      sunset += 86400;
    }

    if (time <= sunrise || time >= sunset) {
      return true;
    } else {
      return false;
    }
  }
}
