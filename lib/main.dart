import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/pages/prompt-screen.dart';
import 'package:masjid_finder/pages/show-on-maps-screen.dart';
import 'package:masjid_finder/pages/splash-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: backgroundColor,
          scaffoldBackgroundColor: backgroundColor),
      home: PromptScreen(),
    );
  }
}
