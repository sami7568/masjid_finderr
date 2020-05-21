import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/admin-app-bar.dart';
import 'package:masjid_finder/ui/custom_widgets/masjid-details-header.dart';
import 'package:masjid_finder/ui/custom_widgets/subscriber-list-item.dart';
import 'package:provider/provider.dart';

class MosqueSubscribersList extends StatefulWidget {
  @override
  _MosqueSubscribersListState createState() => _MosqueSubscribersListState();
}

class _MosqueSubscribersListState extends State<MosqueSubscribersList> {
  List<DocumentSnapshot> subscribers;
  bool gotData = false;
  bool hasData = false;

  @override
  void initState() {
    _getSubscribersData();
    super.initState();
  }

  _getSubscribersData() async {

    if (Provider.of<MasjidProvider>(context).masjid.subscribers == null ||
        Provider.of<MasjidProvider>(context).masjid.subscribers == 0) {
      gotData = true;
      setState(() {});
      return;
    }

    subscribers = await FirestoreHelper().getSubscribers(
        Provider.of<AuthProvider>(context, listen: false).user.uid);
    gotData = true;
    if (subscribers.length > 0) hasData = true;
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

            //Header
            Consumer<MasjidProvider>(
              builder: (context, masjidProvider, child) => MasjidDetailsHeader(
                name: masjidProvider.masjid.name,
                subscribersCount: masjidProvider.masjid.subscribers,
                isJamiaMasjid: masjidProvider.masjid.isJamiaMasjid,
              ),
            ),

            //Text
            Container(
              margin: EdgeInsets.only(top: 13, bottom: 36),
              child: Center(
                child: Text(
                  "${Provider.of<MasjidProvider>(context).masjid.name} has been subscribed by the following users.",
                  style: mainBodyTextStyle,
                ),
              ),
            ),

            gotData
                ? hasData
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return SubscriberListItem(
                            subscriberData: subscribers[index],
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No subscriber",
                          style: mainBodyTextStyle,
                        ),
                      )
                : Center(child: CircularProgressIndicator()),
            //Subscriber  List
          ],
        ),
      ),
    );
  }
}
