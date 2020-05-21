import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';

class SubscriberListItem extends StatelessWidget {
  final subscriberData;

  SubscriberListItem({this.subscriberData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(8, 45, 31, 80),
            // spreadRadius: 5,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          //Icon
          Container(
            margin: EdgeInsets.only(left: 20, right: 16),
            height: 32,
            width: 28,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/static_assets/follower-icon.png"),
              ),
            ),
          ),

          //Subscribers information
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ///Name
              Container(
                child: Text(
                  subscriberData['fullName'] ?? '',
                  style: mainBodyTextStyle,
                ),
              ),
              //Address
              Container(
                child: Text(
                  subscriberData['address'] ?? '',
                  style: subBodyLightTextStyle,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
