import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/custom_widgets/admin-app-bar.dart';
import 'package:masjid_finder/custom_widgets/masjid-details-header.dart';
import 'package:masjid_finder/custom_widgets/subscriber-list-item.dart';

class MosqueSubscribersList extends StatefulWidget {
  @override
  _MosqueSubscribersListState createState() => _MosqueSubscribersListState();
}

class _MosqueSubscribersListState extends State<MosqueSubscribersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            //AppBar
            AdminAppBar(),

            //Header
            MasjidDetailsHeader(),

            //Text
            Container(
              margin: EdgeInsets.only(top: 13, bottom: 36),
              child: Center(
                child: Text(
                  "Spin Jumaat has been subscribed by the following users.",
                  style: mainBodyTextStyle,
                ),
              ),
            ),

            //Subscriber  List
            SubscriberListItem(),
            SubscriberListItem(),
            SubscriberListItem(),
            SubscriberListItem(),
            SubscriberListItem(),
            SubscriberListItem(),
          ],
        ),
      ),
    );
  }
}
