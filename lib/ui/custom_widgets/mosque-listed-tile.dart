import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';

class MosqueListedTile extends StatelessWidget {
  final String icon, text, buttonText;
  final Function onButtonPressed;

  MosqueListedTile(
      {this.icon, this.text = "", this.buttonText = "", this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ///Icon
          icon != null
              ? Container(
                  width: 56,
                  height: 56,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/static_assets/$icon.png"),
                    ),
                  ),
                )
              : Container(),

          //Text
          Flexible(
            child: Text(
              // "Add prayer timings and other details.",
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ),

          ///Button
          Container(
            margin: EdgeInsets.only(top: 17),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              color: Color(0xFF00A8E5),
              child: Text(
                // "Masjid Profile",
                buttonText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
              onPressed: onButtonPressed,
            ),
          )
        ],
      ),
    );
  }
}

class CustomNotificationTile extends StatelessWidget {
  final String icon, text, buttonText;
  final Function onButtonPressed;

  CustomNotificationTile(
      {this.icon, this.text = "", this.buttonText = "", this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ///Icon
          Icon(
            Icons.notifications_none,
            color: mainThemeColor,
            size: 40,
          ),

          //Text
          Flexible(
            child: Text(
              // "Add prayer timings and other details.",
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ),

          ///Button
          Container(
            margin: EdgeInsets.only(top: 17),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              color: Color(0xFF00A8E5),
              child: Text(
                // "Masjid Profile",
                buttonText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
              onPressed: onButtonPressed,
            ),
          )
        ],
      ),
    );
  }
}
