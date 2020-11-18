import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/add-masjid-card.dart';
import 'package:masjid_finder/ui/custom_widgets/admin-app-bar.dart';
import 'package:masjid_finder/ui/custom_widgets/grid-tile.dart';
import 'package:masjid_finder/ui/custom_widgets/mosque-listed-tile.dart';
import 'package:masjid_finder/ui/custom_widgets/salam-card.dart';
import 'package:masjid_finder/ui/pages/add-masjid-screen1.dart';
import 'package:masjid_finder/ui/pages/edit-masjid-profile-screen.dart';
import 'package:masjid_finder/ui/pages/mosque-subscriebrs-list.dart';
import 'package:provider/provider.dart';

import 'custom_notification_page.dart';

class MosqueDashboardScreen extends StatefulWidget {
  @override
  _MosqueDashboardScreenState createState() => _MosqueDashboardScreenState();
}

class _MosqueDashboardScreenState extends State<MosqueDashboardScreen> {
  var contents;

  @override
  void initState() {
    contents = _centeredProgressBar();
    _getMasjidData();
    super.initState();
  }

  _getMasjidData() async {
    print('@getMasjidData');
    final Masjid masjidData = await FirestoreHelper()
        .getMasjid(Provider.of<AuthProvider>(context, listen: false).user.uid);
    if (masjidData != null) {
      Provider.of<MasjidProvider>(context, listen: false).masjid = masjidData;
      if (masjidData.isJamiaMasjid) {
        contents = _jamiaMosqueListedContents();
      } else {
        contents = _mosqueListedContents();
      }
    } else {
      contents = _mosqueNotListedContents();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          //AppBar
          AdminAppBar(),

          //Salam Card
          SalamCard(),

          contents,
        ],
      )),
    );
  }

  _centeredProgressBar() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _mosqueNotListedContents() {
    return AddMasjidCard(
      onBtnPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMasjidScreen1(),
          ),
        );
      },
    );
  }

  _mosqueListedContents() {
    return Column(
      children: <Widget>[
        ///first and second tile
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              MosqueListedTile(
                icon: "timing-icon",
                text: "Add prayer timings and other details.",
                buttonText: "Masjid Profile",
                onButtonPressed: () {
                  print('goto profile screen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMasjidProfileScreen(),
                    ),
                  );
                },
              ),
              Spacer(),
              MosqueListedTile(
                icon: "followers-icon",
                text: "View people who follow your masjid.",
                buttonText: "View Subscribers",
                onButtonPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MosqueSubscribersList()));
                },
              ),
//              MosqueListedTile(
//                icon: "masjid-icon",
//                text: "Synchronise time with a Jamia Masjid.",
//                buttonText: "Follow Masjid",
//                onButtonPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => FollowAMosqueScreen(),
//                    ),
//                  );
//                },
//              ),
            ],
          ),
        ),

        ///third tile
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              MyGridTile(
                text: "Connect to Digital Clock",
                buttonText: "Connect",
                onButtonPressed: () async {
                  if (await DeviceApps.isAppInstalled(
                      'pk.com.systemsintegration.panelconfigure')) {
                    DeviceApps.openApp(
                        'pk.com.systemsintegration.panelconfigure');
                  } else {
                    print('App not found');
                  }
                },
              ),
              Spacer(),
              CustomNotificationTile(
                text: "Custom Notifications to Subscribers",
                buttonText: "Send",
                onButtonPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomNotificationPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _jamiaMosqueListedContents() {
    return Column(
      children: <Widget>[
        ///first and second tile
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              MosqueListedTile(
                icon: "timing-icon",
                text: "Add prayer timings and other details.",
                buttonText: "Masjid Profile",
                onButtonPressed: () {
                  print('goto profile screen');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMasjidProfileScreen(),
                    ),
                  );
                },
              ),
              Spacer(),
              MosqueListedTile(
                icon: "followers-icon",
                text: "View people who follow your masjid.",
                buttonText: "View Subscribers",
                onButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MosqueSubscribersList()),
                  );
                },
              ),

//              MosqueListedTile(
//                icon: "masjid-icon",
//                text: "Synchronise time with a Jamia Masjid.",
//                buttonText: "Follow Masjid",
//                onButtonPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => FollowAMosqueScreen(),
//                    ),
//                  );
//                },
//              ),
            ],
          ),
        ),

        ///third tile
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
//              MosqueListedTile(
//                icon: "followers-icon",
//                text: "View people who follow your masjid.",
//                buttonText: "View Subscribers",
//                onButtonPressed: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => MosqueSubscribersList()));
//                },
//              ),
//
              MyGridTile(
                text: "Connect to Digital Clock",
                buttonText: "Connect",
                onButtonPressed: () async {
                  if (await DeviceApps.isAppInstalled(
                      'pk.com.systemsintegration.panelconfigure')) {
                    DeviceApps.openApp(
                        'pk.com.systemsintegration.panelconfigure');
                  } else {
                    print('App not found');
                  }
                },
              ),
              Spacer(),
              CustomNotificationTile(
                text: "Custom Notifications to Subscribers",
                buttonText: "Send",
                onButtonPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomNotificationPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
