import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';

class MosqueListItem extends StatelessWidget {
  // final String name, address;
  final bool follow;
  final Function onFollowPressed;
  final Masjid info;

  MosqueListItem(
      {
      //   this.name = '',
      // this.address = '',
      // this.isJamia = false,
      this.info,
      this.follow = false,
      this.onFollowPressed});

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
                      info.name,
                      style: mainBodyTextStyle,
                    ),
                  ),
                  Container(
                    child: Text(info.address, style: subBodyLightTextStyle),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          follow == true
              ? Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CustomBlackButton(
                      child: Text(
                        "FOLLOW",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: Colors.white),
                      ),
                      onPressed: onFollowPressed,
                    ),
                  ),
                )
              : Container(),

          (info.isJamiaMasjid && !follow)
              ? Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/static_assets/isJamia.png"),
                          ),
                        ),
                      ),
                      Container(
                        height: 42,
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
