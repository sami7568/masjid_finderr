import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/admin-app-bar.dart';

import '../custom_widgets/mosque-list-item.dart';

class FollowAMosqueScreen extends StatefulWidget {
  @override
  _FollowAMosqueScreenState createState() => _FollowAMosqueScreenState();
}

class _FollowAMosqueScreenState extends State<FollowAMosqueScreen> {
  List<Masjid> jamiaMasjidList;
  bool hasData = false;
  bool gotData = false;

  @override
  void initState() {
    _getJamiaMasjidList();
    super.initState();
  }

  _getJamiaMasjidList() async {
    jamiaMasjidList = await FirestoreHelper().getJamiaMasjidList();
    if (jamiaMasjidList.length > 0) {
      hasData = true;
    }
    gotData = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AdminAppBar(),
            //Text
            Container(
              margin: EdgeInsets.all(24),
              child: Text(
                "Follow a Jamia Masjid to synchronise your prayer timings with theirs.",
                style: subHeadingLightTextStyle,
              ),
            ),

            gotData
                ? hasData
                    ? _jamiaMasjidList()
                    : Text(
                        "Couldn't find any Jamia Masjid",
                        style: subHeadingLightTextStyle,
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
      ),
    );
  }

  _jamiaMasjidList() {
    return ListView(
      shrinkWrap: true,
      children: jamiaMasjidList.map((Masjid masjid)  {
        return MosqueListItem(
          info: masjid,
          follow: true,
          // name: "Spin Jumat",
          // address: 'Univesity Road',
//        follow: true,
          onFollowPressed: _followJamiaMasjid,
        );
      }).toList(),
    );
  }

  _followJamiaMasjid()
  {

  }
}
