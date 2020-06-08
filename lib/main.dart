import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/providers/fcm-provider.dart';
import 'package:masjid_finder/providers/masjid-provider.dart';
import 'package:masjid_finder/ui/pages/time-change-masjid-details-screen.dart';
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
  final _navKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fcm = FirebaseMessaging();
  final _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _fcm.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
      onBackgroundMessage: _backgroundMessageHandler,
    );
//    Future.delayed(
//      Duration.zero,
//      () {
//        Fcm().initConfigure(context: context);
//      },
//    );
    super.initState();
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    print('@onMessage');
    _handleMessage(message: message, onMessage: true);
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) async {
    print('@onResume');
    _handleMessage(message: message);
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) async {
    print('@onLaunch');
    _handleMessage(message: message);
  }

  _handleMessage({Map<String, dynamic> message, onMessage = false}) async {
    print('@handleMessage');
    final title = message['notification']['title'];
    final body = message['notification']['body'];
    final masjidId = message['data']['masjidId'];

//    final Masjid masjidData = await FirestoreHelper().getMasjid(masjidId);
//    Provider.of<MasjidProvider>(context, listen: false).masjid = masjidData;
    try {
      _navKey.currentState.push(MaterialPageRoute(
          builder: (context) => TimeChangeMasjidDetailsScreen(
                isAlertRequired: onMessage,
                title: title,
                body: body,
              )));
    } catch (e) {
      print('Exception @_onMessage: $e');
    }
  }

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) {
    print('@backgroundMessageHandler');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      theme: ThemeData(
          backgroundColor: backgroundColor,
          scaffoldBackgroundColor: backgroundColor),
      home: SplashScreen(),
    );
  }
}
