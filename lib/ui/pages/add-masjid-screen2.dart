import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/models/masjid-model.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-squre-textfield.dart';
import 'package:masjid_finder/ui/custom_widgets/logo.dart';
import 'package:masjid_finder/ui/pages/add-masjid-screen3.dart';
import 'package:masjid_finder/ui/pages/pin-mosque-on-map-screen.dart';
import 'package:provider/provider.dart';

class AddMasjidScreen2 extends StatefulWidget {
  @override
  _AddMasjidScreen2State createState() => _AddMasjidScreen2State();
}

class _AddMasjidScreen2State extends State<AddMasjidScreen2> {
  bool locationAdded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
//        decoration: BoxDecoration(image: DecorationImage(image: )),
            color: greyBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _header(),
                _form(),
                SizedBox(height: 25),
                _continueBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header() {
    return Container(
      margin: EdgeInsets.only(top: 22, bottom: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.subject, color: Colors.black),
          Logo(color: Colors.black),
        ],
      ),
    );
  }

  _form() {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'List your masjid',
              style: subHeadingTextStyle.copyWith(color: mainThemeColor),
            ),
            SizedBox(height: 12),
            Text(
              'Step 2 of 3',
              style: TextStyle(
                  color: Color(0xFF707070),
                  fontFamily: 'Poppins',
                  fontSize: 11),
            ),
            SizedBox(height: 32),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomSquareTextField(
                    hint: '3.9769755',
                    label: 'Latitude',
                    inputType: TextInputType.number,
                    onChange: (val) {
                      masjidProvider.masjid.position.latitude =
                          double.parse(val);
                      print(masjidProvider.masjid.position.latitude);
                    },
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: CustomSquareTextField(
                    hint: '71.2852823',
                    label: 'Longitude',
                    inputType: TextInputType.number,
                    onChange: (val) {
                      masjidProvider.masjid.position.longitude =
                          double.parse(val);
                      print(masjidProvider.masjid.position.longitude);
                    },
                  ),
                ),
              ],
            ),
            RaisedButton(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Add Location',
                    style: blackBtnTS.copyWith(color: Colors.white),
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () {
                if (masjidProvider.masjid.position.latitude != null &&
                    masjidProvider.masjid.position.longitude != null) {
                  masjidProvider.setLocationAddedFlat();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 13),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Divider(
                    color: mainThemeColor,
                    thickness: 1.1,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 14, color: darkGreyColor),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    color: mainThemeColor,
                    thickness: 1.1,
                  )),
                ],
              ),
            ),
            Text(
              'Pin your mosque on the map',
              style: subHeadingTextStyle.copyWith(color: darkGreyColor),
            ),
            SizedBox(height: 25),
            RaisedButton(
              color: mainThemeColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Open Map',
                    style: blackBtnTS,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PinMosqueOnMapScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _continueBtn() {
    return Consumer<MasjidProvider>(
      builder: (context, masjidProvider, child) => RaisedButton(
        color: masjidProvider.locationAdded ? mainThemeColor : Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            'Continue',
            style: blackBtnTS,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          if (masjidProvider.locationAdded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMasjidScreen3(),
              ),
            );
          }
        },
      ),
    );
  }
}
