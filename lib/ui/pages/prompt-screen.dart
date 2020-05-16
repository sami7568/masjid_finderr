import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-outlined-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/ui/pages/imam-login-screen.dart';
import 'package:masjid_finder/ui/pages/user-login-screen.dart';

class PromptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBgColor,
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  _body(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 240,
          color: mainThemeColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/static_assets/logo.png',
                width: 120,
                height: 140,
                fit: BoxFit.contain,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 70, 50, 30),
          child: CustomBlueRoundedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text('I am Looking for a mosque',
                  style: roundedBlueBtnTS.copyWith(fontSize: 16)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginScreen(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: CustomBlueOutlinedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text('I am an Imam',
                  style: roundedBlueBtnTS.copyWith(
                      fontSize: 16, color: Colors.black)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImamLoginScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
