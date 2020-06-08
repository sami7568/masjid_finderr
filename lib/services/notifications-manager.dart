import 'package:flutter/material.dart';

class NotificationManger {

  static BuildContext _context;



  static init({@required BuildContext context}) {
    _context = context;

  }

  //this method used when notification come and app is closed or in background and
  // user click on it, i will left it empty for you
//  static handleDataMsg(Map<String, dynamic> data){
//
//  }
//
//  //this our method called when notification come and app is foreground
//  static handleNotificationMsg(Map<String, dynamic> message) {
//    debugPrint("from mangger  $message");
//
//    final dynamic data = message['data'];
//    //as ex we have some data json for every notification to know how to handle that
//    //let say showDialog here so fire some action
//    if (data.containsKey('showDialog')) {
//      // Handle data message with dialog
//      _showDialog(data);
//    }
//  }
//
//
//
//
//  static _showDialog({@required Map<String, dynamic> data}) {
//
//
//    //you can use data map also to know what must show in MyDialog
//    showDialog(context: _context,builder: (_) =>MyDialog());
//
//
//  }

}
