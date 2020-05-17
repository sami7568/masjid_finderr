import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/services/geolocator-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/location-access-card.dart';
import 'package:masjid_finder/ui/pages/mosques-result.dart';

class LocationAccess extends StatefulWidget {
  @override
  _LocationAccessState createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {
  var gpsStatus;

  @override
  void initState() {
    GeoLocatorHelper().isGpsEnabled().then((status) {
      if (status == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MosquesResult(),
          ),
        );
      } else {
        gpsStatus = true;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gpsStatus == null
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : _body(),
    );
  }

  _body() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              color: mainThemeColor,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  width: 118,
                  height: 144,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/static_assets/white-logo.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: backgroundColor,
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///Lcation Access Card
            Container(
              margin: EdgeInsets.only(top: 187),
              child: Center(
                child: LocationAccessCard(),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(24, 27, 24, 0),
              child: blackButton(
                text: "TURN ON LOCATION",
                onPressed: () async {
                  await GeoLocatorHelper().enableGps();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MosquesResult(),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
