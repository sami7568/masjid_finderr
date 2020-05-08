import 'package:flutter/material.dart';

import 'package:masjid_finder/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: mainThemeColor,
          ),
          Container(
            margin: EdgeInsets.only(top: 50, left: 50),
            decoration: BoxDecoration(
                color: Color(0x007FC443),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(500),
                  bottomLeft: Radius.circular(500),
                )),
          ),
          // ClipPath(
          //   clipper: MyClipper(),
          //   child: Container(
          //     color: Colors.red,
          //   ),
          // ),
          Center(
            child: Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/static_assets/logo.png"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
