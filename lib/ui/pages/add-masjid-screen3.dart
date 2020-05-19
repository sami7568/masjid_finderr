import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/logo.dart';
import 'package:masjid_finder/ui/pages/masjid-details-screen.dart';
import 'package:provider/provider.dart';

class AddMasjidScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _body(),
        ),
      ),
      backgroundColor: greyBgColor,
    );
  }

  _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _header(),
        _stepNo(),
        SizedBox(height: 10),
        _prayerTimings(),
        _doneBtn(),
      ],
    );
  }

  _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.subject,
            color: mainThemeColor,
          ),
          Logo(color: Colors.black),
        ],
      ),
    );
  }

  _stepNo() {
    return Consumer<MasjidProvider>(
        builder: (context, masjidProvider, child) => Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'List your masjid',
                    style: subHeadingTextStyle.copyWith(color: mainThemeColor),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Step 3 of 3',
                    style: TextStyle(
                        color: Color(0xFF707070),
                        fontFamily: 'Poppins',
                        fontSize: 11),
                  ),
                ],
              ),
            ));
  }

  _prayerTimings() {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          namazTile(
              namazType: 'Fajar',
              iconUrl: 'assets/static_assets/fajar.png',
              time: masjidProvider.masjid.prayerTime.fajar ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Zuhar',
              iconUrl: 'assets/static_assets/zuhar.png',
              time: masjidProvider.masjid.prayerTime.zuhar ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Asar',
              iconUrl: 'assets/static_assets/asar.png',
              time: masjidProvider.masjid.prayerTime.asar ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Maghrib',
              iconUrl: 'assets/static_assets/maghrib.png',
              time: masjidProvider.masjid.prayerTime.maghrib ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Isha',
              iconUrl: 'assets/static_assets/isha.png',
              time: masjidProvider.masjid.prayerTime.isha ?? 'Add Time',
              context: context),
          namazTile(
              namazType: 'Jummah',
              iconUrl: 'assets/static_assets/jummah.png',
              time: masjidProvider.masjid.prayerTime.jummah ?? 'Add Time',
              context: context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  namazTile({iconUrl, namazType, time, context}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                iconUrl,
                width: 30,
                height: 16,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 15),
              Text(namazType, style: namazTypeTS),
            ],
          ),
          Row(children: <Widget>[
            Consumer<MasjidProvider>(
              builder: (context, masjidProvider, child) => IconButton(
                icon: Icon(Icons.mode_edit, color: Colors.black),
                onPressed: () async {
                  TimeOfDay time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 12, minute: 00));
//                  print(time.format(context));
                  if (time != null) {
                    final strTime = time.format(context);
                    switch (namazType) {
                      case 'Fajar':
                        masjidProvider.setFajarTime(strTime);
                        break;
                      case 'Zuhar':
                        masjidProvider.setZuharTime(strTime);
                        break;
                      case 'Asar':
                        masjidProvider.setAsarTime(strTime);
                        break;
                      case 'Maghrib':
                        masjidProvider.setMaghribTime(strTime);
                        break;
                      case 'Isha':
                        masjidProvider.setIshaTime(strTime);
                        break;
                      case 'Jummah':
                        masjidProvider.setJummahTime(strTime);
                        break;
                    }
                  }
                },
              ),
            ),
            SizedBox(width: 4),
            Text(
              time,
              style: namazTimeTS,
            )
          ]),
        ],
      ),
    );
  }

  _doneBtn() {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RaisedButton(
          color: masjidProvider.locationAdded ? mainThemeColor : Colors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Done',
              style: blackBtnTS,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            final uid =
                Provider.of<AuthProvider>(context, listen: false).user.uid;
            masjidProvider.createMasjidInDb(uid);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MasjidDetailsScreen()));
//            if (masjidProvider.locationAdded) {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => AddMasjidScreen3(),
//                ),
//              );
//            }
          },
        ),
      ),
    );
  }
}
