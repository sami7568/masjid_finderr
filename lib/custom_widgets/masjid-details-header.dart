import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/custom_widgets/cusom-black-button.dart';

class MasjidDetailsHeader extends StatelessWidget {
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
              Text('Spin Jumat', style: subHeadingTextStyle),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: orangeColor, width: 2)),
                child: Text(
                  'Jamia Masjid',
                  style: jamiaMasjidTS,
                ),
              ),
            ],
          ),
          CustomBlackButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.notifications, color: Colors.white, size: 17),
                SizedBox(width: 4),
                Text('SUBSCRIBE', style: blackBtnTS),
              ],
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
