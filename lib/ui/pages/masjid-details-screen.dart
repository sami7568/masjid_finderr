import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-outlined-button.dart';
import 'package:masjid_finder/ui/custom_widgets/logo.dart';
import 'package:provider/provider.dart';

class MasjidDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _body(context),
        ),
      ),
      backgroundColor: greyBgColor,
    );
  }

  _body(context) {
    return Column(
      children: <Widget>[
        _header(),
        _basicInfo(context),
        _locationInfo(context),
        _prayerTimings(context),
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
          Logo(color: mainThemeColor),
          Container(),
        ],
      ),
    );
  }

  _basicInfo(context) {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Container(
        padding: EdgeInsets.only(left: 24, right: 32),
        height: 100,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(masjidProvider.masjid.name, style: subHeadingTextStyle),
                SizedBox(height: 10),
                masjidProvider.masjid.isJamiaMasjid
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: orangeColor, width: 2)),
                        child: Text(
                          'Jamia Masjid',
                          style: jamiaMasjidTS,
                        ),
                      )
                    : null,
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBlackButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.notifications, color: Colors.white, size: 17),
                      SizedBox(width: 4),
                      Text('SUBSCRIBE', style: blackBtnTS),
                    ],
                  ),
                  onPressed: () {},
                ),
                Text(
                  masjidProvider.masjid.subscribers != null
                      ? '${masjidProvider.masjid.subscribers.toString()} subscribers'
                      : '0 subscribers',
                  style: subBodyTextStyle,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _locationInfo(context) {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 32, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Location', style: subHeadingTextStyle),
                SizedBox(height: 10),
                Text(masjidProvider.masjid.address, style: mainBodyTextStyle)
              ],
            ),
            CustomBlackOutlinedButton(
              child: Text(
                'DIRECTIONS',
                style: blackBtnTS.copyWith(color: Colors.black),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  _prayerTimings(context) {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 15),
            child: Text('Prayer Timings', style: subHeadingTextStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 10, top: 9),
            child: Text('Subscribe to get notified of change in timings'),
          ),
          namazTile(
              namazType: "Fajar", time: masjidProvider.masjid.prayerTime.fajar),
          namazTile(
              namazType: "Zuhar", time: masjidProvider.masjid.prayerTime.zuhar),
          namazTile(
              namazType: "Asar", time: masjidProvider.masjid.prayerTime.asar),
          namazTile(
              namazType: "Maghrib",
              time: masjidProvider.masjid.prayerTime.maghrib),
          namazTile(
              namazType: "Isha", time: masjidProvider.masjid.prayerTime.isha),
          namazTile(
              namazType: "Jummah",
              time: masjidProvider.masjid.prayerTime.jummah),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  namazTile({icon, namazType = '', time = ''}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.wb_sunny, color: timeColor),
              SizedBox(width: 15),
              Text(namazType, style: namazTypeTS),
            ],
          ),
          Text(
            time,
            style: namazTimeTS,
          )
        ],
      ),
    );
  }
}
