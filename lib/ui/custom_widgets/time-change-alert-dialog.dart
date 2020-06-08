import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-button.dart';
import 'package:masjid_finder/ui/custom_widgets/cusom-black-outlined-button.dart';

class TimeChangeAlertDialog extends StatelessWidget {
  final title;
  final body;

  TimeChangeAlertDialog({this.title, this.body}) {
    print('@TimeChangeAlerDialog');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        width: 200,
        height: 200,
//        child: showProgress
//            ? Center(child: CircularProgressIndicator())
//            :
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: subHeadingTextStyle),
            Flexible(
              child: Text(body,
                  style:
                      mainBodyTextStyle.copyWith(color: alertDialogeBodyColor)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              CustomBlackButton(
                child: Text(
                  'SKIP',
                  style: blackBtnTS,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              CustomBlackOutlinedButton(
                child: Text('CHECK TIMINGS',
                    style: blackBtnTS.copyWith(color: Colors.black),
                    textAlign: TextAlign.center),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
