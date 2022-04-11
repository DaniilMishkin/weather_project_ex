import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_project_ex/models/weather_provider.dart';
import 'package:weather_project_ex/models/weather_response.dart';
import 'package:weather_project_ex/screens/weather_screen.dart';
import 'package:weather_project_ex/utilities/constants.dart';
import '../services/weather.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getLocationData();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controller.value = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getLocationData() async {
    WeatherResponse weatherData = await WeatherModel().getLocation(context);
    String locationName = await WeatherModel().getLocationName();
    weatherData.locationName = locationName;
    Provider.of<WeatherData>(context, listen: false).changeData(weatherData);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LocationScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = (MediaQuery.of(context).size.width);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kTransparent,
    ));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor[0], endColor[0]],
          ),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/loading.json',
            width: (screenWidth - ((screenWidth / 100) * 30)),
            height: 200,
            repeat: false,
            animate: true,
            controller: _controller,
            onLoaded: (animations) {
              _controller
                ..duration = (animations.duration * 0.7)
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}
