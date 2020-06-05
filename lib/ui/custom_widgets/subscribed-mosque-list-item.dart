import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';

class SubscribedMosqueListItem extends StatelessWidget {
  final mosqueName;
  final mosqueAddress;

  SubscribedMosqueListItem({this.mosqueName, this.mosqueAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: EdgeInsets.fromLTRB(12, 7, 12, 7),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(8, 45, 31, 80),
              spreadRadius: 0,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Mosque Icon
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 19),
              height: 49,
              width: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/static_assets/mosque-icon.png"),
                ),
              ),
            ),
          ),

          //Mosque Info
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(left: 27),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      mosqueName ?? '',
                      style: mainBodyTextStyle,
                    ),
                  ),
                  Container(
                    child:
                        Text(mosqueAddress ?? '', style: subBodyLightTextStyle),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(width: 10),
        ],
      ),
    );
  }
}
