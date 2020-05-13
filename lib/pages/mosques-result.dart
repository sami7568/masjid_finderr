import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/pages/mosque-list-item.dart';
import 'package:masjid_finder/widget.dart/black-button.dart';


class MosquesResult extends StatefulWidget {
  @override
  _MosquesResultState createState() => _MosquesResultState();
}

class _MosquesResultState extends State<MosquesResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //First tabbar
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    print("Icon Pressed");
                  },
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text("Masjid Finder"),
                  ),
                ),
                Container(
                  width: 45,
                  height: 20,
                )
              ],
            ),

            //Assalam o Alaikum
            Container(
              margin: EdgeInsets.only(left: 34, top: 24, bottom: 32),
              child: Text(
                "Assalam o alykum :)",
                style: mainHeadingTextStyle,
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(34, 8, 34, 0),
              child: Text(
                "We found the following mosques in your surroundings.",
                style: subHeadingLightTextStyle,
              ),
            ),

            mosqueListItem(
                name: "Spin Jumat", address: 'University Road', isJamia: true),
            mosqueListItem(
              name: "KMC Mosque",
              address: 'University of Peshawar',
            ),
            mosqueListItem(
              name: "UET Mosque",
              address: 'UET Peshawar',
            ),
            //Show on map button
            Container(
              margin: EdgeInsets.fromLTRB(12, 32, 12, 12),
              child: blackButton(text: "SHOW ON MAP", onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
