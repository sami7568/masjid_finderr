import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/majid-provider.dart';
import 'package:provider/provider.dart';
import 'package:masjid_finder/ui/pages/splash-screen.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MasjidProvider(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: backgroundColor,
          scaffoldBackgroundColor: backgroundColor),
      home: SplashScreen(),
    );
  }
}
