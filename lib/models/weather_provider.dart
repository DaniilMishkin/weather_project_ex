import 'package:flutter/cupertino.dart';
import 'package:weather_project_ex/models/weather_response.dart';

class WeatherData extends ChangeNotifier {
  WeatherResponse? weatherData;

  void changeData(dynamic newData) {
    weatherData = newData;
    notifyListeners();
  }
}
