import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/subscribed-mosque-list-item.dart';
import 'package:masjid_finder/ui/pages/masjid-details-screen.dart';
import 'package:masjid_finder/ui/pages/show-mosques-on-map-screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class MySubscriptionsScreen extends StatefulWidget {
  @override
  _MySubscriptionsScreenState createState() => _MySubscriptionsScreenState();
}

class _MySubscriptionsScreenState extends State<MySubscriptionsScreen> {
  bool gotData = false, noData = false;
  List<DocumentSnapshot> _mosquesList = [];
  Position currentLocation;
  bool showProgressHud = false;

  @override
  void initState() {
    _getSubscriptionsList();
    super.initState();
  }

  _getSubscriptionsList() async {
    final uid = Provider.of<AuthProvider>(context, listen: false).user.uid;
    _mosquesList = await FirestoreHelper().getSubscribedMosques(uid: uid);
    if (_mosquesList.length == 0) noData = true;
    gotData = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgressHud,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //First tabbar
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      print("Icon Pressed");
                    },
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text("Masjid Finder"),
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 20,
                  )
                ],
              ),

              //Assalam o Alaikum
              Container(
                margin: EdgeInsets.only(left: 34, top: 24, bottom: 32),
                child: Text(
                  "Assalam o alykum :)",
                  style: mainHeadingTextStyle,
                ),
              ),

              gotData
                  ? Container(
                      margin: EdgeInsets.fromLTRB(34, 8, 34, 0),
                      child: Text(
                        noData
                            ? "We couldn't find any mosque in you list."
                            : "We found the following mosques in your subscriptions list.",
                        style: subHeadingLightTextStyle,
                      ),
                    )
                  : Container(),

              gotData
                  ? Column(
                      children: _mosquesList.map<Widget>((masjidInfoSnapshot) {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              showProgressHud = true;
                            });
                            final Masjid masjidData = await FirestoreHelper()
                                .getMasjid(masjidInfoSnapshot['masjidId']);
                            Provider.of<MasjidProvider>(context, listen: false)
                                .masjid = masjidData;
                            setState(() {
                              showProgressHud = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MasjidDetailsScreen(),
                              ),
                            );
                          },
                          child: SubscribedMosqueListItem(
                            mosqueName: masjidInfoSnapshot['mosqueName'],
                            mosqueAddress: masjidInfoSnapshot['mosqueAddress'],
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
            ],
          ),
        ),
      ),
    );
  }
}
