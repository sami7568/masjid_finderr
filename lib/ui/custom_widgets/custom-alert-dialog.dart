import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final iconUrl;
  final title;
  Widget content;
  final actions;

  CustomAlertDialog({this.iconUrl, this.title, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              iconUrl,
              width: 56,
              height: 56,
              fit: BoxFit.contain,
            ),
            content,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: actions),
          ],
        ),
      ),
    );
  }
}
