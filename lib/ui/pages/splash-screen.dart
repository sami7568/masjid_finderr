import 'package:flutter/material.dart';
import 'package:masjid_finder/services/my-geolocator.dart';
import 'dart:async';

import 'package:masjid_finder/ui/pages/location-access.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    MyGeolocator().checkPermission();
    super.initState();
    Timer(
      Duration(milliseconds: 1500),
      () => Navigator.of(context).pushReplacement(
            FadeRoute(
              page: LocationAccess(),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF00A2E4),
          ),
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              color: Color(0xFF00AFEF),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/static_assets/white-logo.png"),
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
    path.moveTo(size.width, 40);
    path.quadraticBezierTo(0, size.height / 3, size.width / 5, size.height);
    path.lineTo(size.width / 5, size.height);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

//Animation Route for SplashScreen
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}
