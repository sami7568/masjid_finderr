import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/services/firestore-helper.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CustomNotificationPage extends StatefulWidget {
  @override
  _CustomNotificationPageState createState() => _CustomNotificationPageState();
}

class _CustomNotificationPageState extends State<CustomNotificationPage> {
  String notificationText = '';
  bool showModalProgressHud = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showModalProgressHud,
      child: Scaffold(
          appBar: AppBar(title: Text('Custom Notifications')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    minLines: 4,
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your message here..'),
                    onChanged: (val) {
                      notificationText = val;
                    },
                  ),
                ),
                SizedBox(height: 20),
                CustomBlueRoundedButton(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Text(
                      'Send Notification',
                      style: roundedBlueBtnTS,
                    ),
                  ),
                  onPressed: () {
                    if (notificationText == null ||
                        notificationText.trim().length < 1) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Error',
                              style: TextStyle(color: Colors.black),
                            ),
                            content: Text('Please enter a valid message first'),
                          );
                        },
                      );
                      return;
                    }
                    setState(() {
                      showModalProgressHud = true;
                    });
                    FirestoreHelper().addCustomNotification(notificationText);
                    setState(() {
                      showModalProgressHud = false;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )),
    );
  }
}
