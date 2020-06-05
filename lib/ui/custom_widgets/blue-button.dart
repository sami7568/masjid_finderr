import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';

Widget blueButton({String text = "", Function onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: RaisedButton(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      // padding: EdgeInsets.fromLTRB(13, 2, right, bottom),
      padding: EdgeInsets.only(top: 12, bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      color: mainThemeColor,
      onPressed: onPressed,
    ),
  );
}
