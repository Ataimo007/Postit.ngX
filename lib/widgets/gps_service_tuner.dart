import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> tuneGps(BuildContext context, Geolocator locator) async {
  bool gpsServiceOn = await showModalBottomSheet<bool>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return GpsServiceTuner(locator);
      },
      context: context);
  return gpsServiceOn == null ? false : gpsServiceOn;
}

class GpsServiceTuner extends StatefulWidget {
  final Geolocator locator;
  GpsServiceTuner(this.locator, {Key key}) : super(key: key);

  @override
  _GpsServiceTunerState createState() {
    return _GpsServiceTunerState(locator);
  }
}

class _GpsServiceTunerState extends State<GpsServiceTuner> {
  bool isGpsOn = false;
  final Geolocator locator;

  _GpsServiceTunerState(this.locator);

  @override
  void initState() {
    super.initState();
    _checkGpsStateContinually();
  }

  _checkGpsStateContinually() {
    locator.isLocationServiceEnabled().then((value) {
      if (mounted) {
        setState(() {
          isGpsOn = value;
        });
        if (!value) _checkGpsStateContinually();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 40, left: 30, right: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Please put on your GPS service so we could obtain your location",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.green.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "GPS Service",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Switch(
                    value: isGpsOn,
                    onChanged: (value) {
                      final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                      );
                      intent.launch();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                color: Colors.red,
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Navigator.of(this.context).pop(isGpsOn);
                },
              ),
              SizedBox(
                width: 20,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                color: Colors.green,
                disabledColor: Colors.green.withOpacity(0.3),
                disabledTextColor: Colors.white.withOpacity(0.1),
                child: Text(
                  "DONE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: isGpsOn
                    ? () async {
                        Navigator.of(this.context).pop(isGpsOn);
                      }
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
