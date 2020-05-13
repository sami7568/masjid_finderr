import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-outlined-button.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/custom_widgets/custom-white-rounded-button.dart';

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
          width: MediaQuery.of(context).size.width,
          color: mainThemeColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Logo'),
              Text(
                'Masjid',
                style: urduLogoTS.copyWith(fontSize: 20, color: Colors.white),
              ),
              Text(
                'Finder',
                style: urduLogoTS.copyWith(fontSize: 20, color: Colors.white),
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
            onPressed: () {},
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
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
