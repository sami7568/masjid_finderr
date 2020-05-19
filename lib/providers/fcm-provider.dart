import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmNotificationsProvider extends ChangeNotifier {
  final context;
  final _fcm = FirebaseMessaging();

  FcmNotificationsProvider(this.context) {
    _fcm.configure(
      onMessage: _onMessage(),
      onLaunch: _onLaunch(),
      onResume: _onResume(),
    );
  }

  _onMessage() {}

  _onLaunch() {}

  _onResume() {}
}
