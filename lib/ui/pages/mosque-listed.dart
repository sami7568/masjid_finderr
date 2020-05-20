import 'package:flutter/material.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/add-masjid-card.dart';
import 'package:masjid_finder/ui/custom_widgets/admin-app-bar.dart';
import 'package:masjid_finder/ui/custom_widgets/mosque-listed-tile.dart';
import 'package:masjid_finder/ui/custom_widgets/salam-card.dart';
import 'package:masjid_finder/ui/pages/add-masjid-screen1.dart';
import 'package:provider/provider.dart';

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
    final masjidData = await FirestoreHelper()
        .getMasjid(Provider.of<AuthProvider>(context, listen: false).user.uid);
    if (masjidData != null) {
      Provider.of<MasjidProvider>(context, listen: false).masjid =
          Masjid.fromJson(masjidData);
      contents = _mosqueListedContents();
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
                onButtonPressed: () {},
              ),
              Spacer(),
              MosqueListedTile(
                icon: "masjid-icon",
                text: "Synchronise time with a Jamia Masjid.",
                buttonText: "Follow Masjid",
                onButtonPressed: () {},
              ),
            ],
          ),
        ),

        ///third tile
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              MosqueListedTile(
                icon: "followers-icon",
                text: "View people who follow your masjid.",
                buttonText: "View Subscribers",
                onButtonPressed: () {},
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
