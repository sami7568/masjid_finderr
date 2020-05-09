import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';

class CustomBlueRoundedButton extends StatelessWidget {
  final onPressed;
  final text;

  CustomBlueRoundedButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(text ?? '', style: TextStyle(color: Colors.white),),
      ),
      color: blueFontLabelColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
    );
  }
}
