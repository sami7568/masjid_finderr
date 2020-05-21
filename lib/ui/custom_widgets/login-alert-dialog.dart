import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-outlined-button.dart';
import 'package:masjid_finder/ui/pages/user-login-screen.dart';
import 'package:masjid_finder/ui/pages/user-signup-screen.dart';

class CustomLoginAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 35),
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('We need you to register first :)',
                style: subHeadingTextStyle),
            Flexible(
              child: Text('\Only registered members can subscribe to a mosque.',
                  style:
                      mainBodyTextStyle.copyWith(color: alertDialogeBodyColor)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CustomBlackButton(
                child: Text(
                  'SIGN UP',
                  style: blackBtnTS,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSignUpScreen(needPop: true)));
                },
              ),
              CustomBlackOutlinedButton(
                child: Text('LOG IN',
                    style: blackBtnTS.copyWith(color: Colors.black),
                    textAlign: TextAlign.center),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserLoginScreen(needPop: true)));
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
