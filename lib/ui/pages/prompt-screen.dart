import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/ui/custom_widgets/asset-logo.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-outlined-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/ui/pages/imam-login-screen.dart';
import 'package:masjid_finder/ui/pages/imam-signup-screen.dart';
import 'package:masjid_finder/ui/pages/location-access.dart';
import 'package:masjid_finder/ui/pages/nearby-mosques-screen.dart';
import 'package:provider/provider.dart';

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
          child: AssetLogo('assets/static_assets/white-logo.png'),
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
              Provider.of<AuthProvider>(context, listen: false).setAsUser();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationAccess(),
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
              Provider.of<AuthProvider>(context, listen: false).setAsImam();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImamSignUpScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
