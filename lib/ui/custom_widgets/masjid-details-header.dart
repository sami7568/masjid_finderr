import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';

class MasjidDetailsHeader extends StatelessWidget {
  final name;
  final subscribersCount;
  final isJamiaMasjid;

  MasjidDetailsHeader({this.name, this.subscribersCount, this.isJamiaMasjid});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('$name', style: subHeadingTextStyle),
              SizedBox(height: 10),
              isJamiaMasjid
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: orangeColor, width: 2)),
                      child: Text(
                        'Jamia Masjid',
                        style: jamiaMasjidTS,
                      ),
                    )
                  : Container(),
            ],
          ),
          FlatButton(
            child: Text(
              '$subscribersCount' ?? '0' + ' subscribers',
              style: subscribersTS,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: BorderSide(color: subscribersBtnColor)),
            onPressed: () {},
          ),

//          CustomBlackButton(
//            child: Row(
//              children: <Widget>[
//                Icon(Icons.notifications, color: Colors.white, size: 17),
//                SizedBox(width: 4),
//                Text('SUBSCRIBE', style: blackBtnTS),
//              ],
//            ),
//            onPressed: () {},
//          )
        ],
      ),
    );
  }
}
