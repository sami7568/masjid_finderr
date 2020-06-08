import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Fcm {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static BuildContext _context;

  initConfigure({@required BuildContext context}) {
    _context = context;

//    if (Platform.isIOS) _iosPermission();

    _fcm.requestNotificationPermissions();
    _fcm.autoInitEnabled();

    _fcm.configure(
      onMessage: _onMessage,
      onResume: _onResume,
      onLaunch: _onLaunch,
      onBackgroundMessage: _backgroundMessageHandler,
    );
  }

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) {
    print('@backgroundMessageHandler');
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    print('@onMessage: ${message.toString()}');
    print('title: ${message['notification']['title']}');
    print('body: ${message['notification']['body']}');
    print('masjidId: ${message['data']['masjidId']}');
    final title = message['notification']['title'];
    final body = message['notification']['body'];
    final masjidId = message['data']['masjidId'];
    _showDialog(title: title, body: body);
//    showDialog(
//      context: context,
//      builder: (_) => AlertDialog(
//        title: title,
//        content: Text(body),
//      ),
////      child: TimeChangeAlertDialog(
////        title: title,
////        body: body,
////        masjidId: masjidId,
////      ),
//    );
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) async {
    print('@onLaunch');
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) async {
    print('@onResume');
  }

  static _showDialog({title, body}) {
    //you can use data map also to know what must show in MyDialog
    showDialog(
        context: _context,
        builder: (_) => AlertDialog(
              title: title,
              content: Text(body),
            ));
  }
}
