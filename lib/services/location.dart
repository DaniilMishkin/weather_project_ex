import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather_project_ex/utilities/constants.dart';

class Location {
  late double latitude;
  late double longitude;

  Future<void> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackMessage(context, false);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackMessage(context, true);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((value) => {
              latitude = value.latitude,
              longitude = value.longitude,
            });
  }

  void showSnackMessage(BuildContext context, bool isForever) {
    var t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        isForever ? t!.locationDeniedForever : t!.locationDenied,
        style: kSubHeadlinePrimaryTextStyle,
      ),
      duration: const Duration(days: 365),
    ));
  }
}
