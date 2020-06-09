import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-outlined-button.dart';

class AlreadyFollowingAlert extends StatelessWidget {
  final title;
  final body;

  AlreadyFollowingAlert({this.title, this.body}) {
    print('@AlreadyFollowingAlerDialog');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        width: 180,
        height: 150,
//        child: showProgress
//            ? Center(child: CircularProgressIndicator())
//            :
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: subHeadingTextStyle),
            SizedBox(height: 20),
            Flexible(
              child: Text(body,
                  textAlign: TextAlign.center,
                  style:
                      mainBodyTextStyle.copyWith(color: alertDialogeBodyColor)),
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: [
//                CustomBlackButton(
//                  child: Text(
//                    'SKIP',
//                    style: blackBtnTS,
//                    textAlign: TextAlign.center,
//                  ),
//                  onPressed: () {
//                    Navigator.pop(context);
//                    Navigator.pop(context);
//                  },
//                ),
//                CustomBlackOutlinedButton(
//                  child: Text('CHECK TIMINGS',
//                      style: blackBtnTS.copyWith(color: Colors.black),
//                      textAlign: TextAlign.center),
//                  onPressed: () async {
//                    Navigator.pop(context);
//                  },
//                ),
//              ],
//            ),
          ],
        ),
      ),
    );
  }
}
