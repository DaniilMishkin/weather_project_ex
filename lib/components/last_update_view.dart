import 'package:flutter/material.dart';
import 'package:weather_project_ex/utilities/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LastUpdateView extends StatefulWidget {
  final DateTime lastUpdate;

  const LastUpdateView({Key? key, required this.lastUpdate}) : super(key: key);

  @override
  State<LastUpdateView> createState() => _LastUpdateViewState();
}

class _LastUpdateViewState extends State<LastUpdateView> {
  String lastUpdateStr = '';

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    setState(() {
      lastUpdateStr = t!.lastUpdate;
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.timelapse,
          color: kIconColor,
          size: kIconSize,
        ),
        const SizedBox(width: 4.0),
        Text(
          '$lastUpdateStr ${TimeOfDay.fromDateTime(widget.lastUpdate).format(context)}',
          style: kHeadlineTextStyle,
        ),
      ],
    );
  }
}
