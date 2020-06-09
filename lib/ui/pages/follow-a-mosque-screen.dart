import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/admin-app-bar.dart';
import 'package:masjid_finder/ui/custom_widgets/already-following-alert-dialog.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/mosque-list-item.dart';

class FollowAMosqueScreen extends StatefulWidget {
  @override
  _FollowAMosqueScreenState createState() => _FollowAMosqueScreenState();
}

class _FollowAMosqueScreenState extends State<FollowAMosqueScreen> {
  List<Masjid> jamiaMasjidList;
  bool hasData = false;
  bool gotData = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
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
      children: jamiaMasjidList.map((Masjid masjid) {
        return MosqueListItem(
          info: masjid,
          follow: true,
          // name: "Spin Jumat",
          // address: 'Univesity Road',
//        follow: true,
          onFollowPressed: () {
            print(
                'Following status: ${Provider.of<MasjidProvider>(context, listen: false).masjid.isFollowing}');
            if (Provider.of<MasjidProvider>(context, listen: false)
                    .masjid
                    .isFollowing ==
                false)
              _followJamiaMasjid(masjid.firestoreId, masjid.name);
            else
              _showAlreadyFollowingAlert();
          },
        );
      }).toList(),
    );
  }

  _followJamiaMasjid(jamiaMasjidId, jamiaMasjidName) {
    final firestoreHelper = FirestoreHelper();
    firestoreHelper.followJamiaMasjid(
      jamiaMasjidId: jamiaMasjidId,
      followerMasjidId: Provider.of<MasjidProvider>(context, listen: false)
          .masjid
          .firestoreId,
      followerMasjidName:
          Provider.of<MasjidProvider>(context, listen: false).masjid.name,
    );

    /// Update isFollowing flag, so that it can't follow any other mosque.
    Provider.of<MasjidProvider>(context, listen: false).masjid.isFollowing =
        true;

    /// Update isFollowing flag for the current masjid in the firestore as well.
    firestoreHelper.setIsFollowing(
        docId: Provider.of<MasjidProvider>(context, listen: false)
            .masjid
            .firestoreId);

    _showSnackBar(content: 'You have started following $jamiaMasjidName');
  }

  _showAlreadyFollowingAlert() {
    showDialog(
      context: context,
      child: AlreadyFollowingAlert(
        title: 'Single Follower Alert',
        body: 'You can follow a single mosque only and you are already following one.',
      ),
    );
  }

  _showSnackBar({content}) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('$content'),
      ),
    );
  }
}
