import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/fcm-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
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
        ChangeNotifierProvider(
          create: (context) => FcmNotificationsProvider(context),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fcm = FirebaseMessaging();

  @override
  void initState() {
    _fcm.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
      onBackgroundMessage: _backgroundMessageHandler,
    );
    super.initState();
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    print('@onMessage');
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) async {
    print('@onLaunch');
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) async {
    print('@onResume');
  }

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) {
    print('@backgroundMessageHandler');
  }

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
