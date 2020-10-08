import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/geolocator-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/blue-button.dart';
import 'package:masjid_finder/ui/pages/masjid-details-screen.dart';
import 'package:masjid_finder/ui/pages/my-subscriptions-screen.dart';
import 'package:masjid_finder/ui/pages/prompt-screen.dart';
import 'package:masjid_finder/ui/pages/show-mosques-on-map-screen.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/mosque-list-item.dart';

class MosquesResult extends StatefulWidget {
  @override
  _MosquesResultState createState() => _MosquesResultState();
}

class _MosquesResultState extends State<MosquesResult> {
  bool gotData = false, noData = false;
  List<Masjid> _mosquesList = [];
  final geoLocatorHelper = GeoLocatorHelper();
  Position currentLocation;

  @override
  void initState() {
    _getNearbyMosquesData();
    super.initState();
  }

  _getNearbyMosquesData() async {
    currentLocation = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        locationPermissionLevel: GeolocationPermission.location);

    print('@getNearbyMosquesData Current Location: $currentLocation');

    ///
    /// If unable to get current Location
    ///
    if (currentLocation == null) {
      print('Current Location is null');
      final status = await geoLocatorHelper.isGpsEnabled();
      if (status) {
        _showPermissionsAlert();
      } else
        await geoLocatorHelper.enableGps();
      currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          locationPermissionLevel: GeolocationPermission.location);
      return;
    }

    ///
    /// If successfully gets current location, perform rest of
    /// operations.
    ///
    final center =
        GeoFirePoint(currentLocation.latitude, currentLocation.longitude);
    final double radius = 2;
    final geoFlutterFire = Geoflutterfire();
    final ref = Firestore.instance.collection('masjid');

    try {
      final stream = geoFlutterFire.collection(collectionRef: ref).within(
          center: center, radius: radius, field: 'position', strictMode: true);
      stream.listen(
        (List<DocumentSnapshot> docsList) {
          print('Masjid count: ${docsList.length}');
          gotData = true;
          if (docsList.length == 0) {
            noData = true;
          } else {
            _mosquesList = docsList.map((masjidData) {
              return Masjid.fromJson(masjidData);
            }).toList();
          }
          setState(() {});
        },
      );
    } catch (e) {
      print('Exception @getNearbyMosqueData: #e');
    }
  }

  _showPermissionsAlert() {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Location Permissions disabled'),
            content: Text(
                'Please turn on Location Permissions in settings>Apps>MasjidFinder>Permissions to access nearby Locations'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Masjid Finder',
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'User App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: mainThemeColor,
              ),
//              Provider.of<AuthProvider>(context).isLogin
//                  ?
              ListTile(
                      title: Text('Logout'),
                      onTap: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromptScreen()),
                            (route) => false);
                      },
                    )
//                  : Container(),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //First tabbar
//            Row(
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.menu),
//                  onPressed: () {
//                    print("Icon Pressed");
//                  },
//                ),
//                Expanded(
//                  flex: 2,
//                  child: Center(
//                    child: Text("Masjid Finder"),
//                  ),
//                ),
//                Container(
//                  width: 45,
//                  height: 20,
//                )
//              ],
//            ),

            //Assalam o Alaikum
            Container(
              margin: EdgeInsets.only(left: 34, top: 24, bottom: 32),
              child: Text(
                "Assalam o alykum :)",
                style: mainHeadingTextStyle,
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(34, 8, 34, 0),
              child: Text(
                "We found the following mosques in your surroundings.",
                style: subHeadingLightTextStyle,
              ),
            ),

            gotData
                ? Column(
                    children: _mosquesList.map<Widget>((masjidInfo) {
                      return GestureDetector(
                        onTap: () {
                          Provider.of<MasjidProvider>(context, listen: false)
                              .masjid = masjidInfo;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MasjidDetailsScreen(),
                            ),
                          );
                        },
                        child: MosqueListItem(
                          info: masjidInfo,
                        ),
                      );
                    }).toList(),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            // MosqueListItem(),

            //Show on map button
            Container(
              margin: EdgeInsets.fromLTRB(12, 32, 12, 12),
              child: blackButton(
                  text: "SHOW ON MAP",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowMosquesOnMapScreen(
                          masjids: _mosquesList,
                        ),
                      ),
                    );
//                Provider.of<AuthProvider>(context, listen: false).logout();
                  }),
            ),
            Provider.of<AuthProvider>(context, listen: false).isLogin
                ? Container(
                    margin: EdgeInsets.fromLTRB(12, 5, 12, 12),
                    child: blueButton(
                        text: "MY SUBSCRIPTIONS",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MySubscriptionsScreen(),
                            ),
                          );
//                Provider.of<AuthProvider>(context, listen: false).logout();
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
