import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmNotificationsProvider extends ChangeNotifier {
  final context;
  final _fcm = FirebaseMessaging();

  FcmNotificationsProvider(this.context) {
    print('@FcmNotificationsProvider');
    _fcm.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onResume,
      onBackgroundMessage: _backgroundMessageHandler,
    );
  }

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) {
    print('@backgroundMessageHandler');
//    if (message.containsKey('data')) {
//      // Handle data message
//      final dynamic data = message['data'];
//    }
//
//    if (message.containsKey('notification')) {
//      // Handle notification message
//      final dynamic notification = message['notification'];
//    }

    // Or do other work.
  }

  _onMessage(Map<String, dynamic> message) {
    print('@onMessage');
  }

  _onLaunch(Map<String, dynamic> message) {
    print('@onLaunch');
  }

  _onResume(Map<String, dynamic> message) {
    print('@onResume');
  }
}
