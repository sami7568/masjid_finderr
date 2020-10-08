import 'package:flutter/material.dart';

class MyGridTile extends StatelessWidget {
  final String icon, text, buttonText;
  final Function onButtonPressed;

  MyGridTile(
      {this.icon, this.text = "", this.buttonText = "", this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ///Icon
          icon != null
              ? Container(
                  width: 56,
                  height: 56,
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(color: Color(0xFFF0F2F7), width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/static_assets/$icon.png"),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Icon(Icons.mobile_screen_share, size: 30,),
              ),

          //Text
          Flexible(
            child: Text(
              // "Add prayer timings and other details.",
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ),

          ///Button
          Container(
            margin: EdgeInsets.only(top: 10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              color: Color(0xFF00A8E5),
              // padding: EdgeInsets.all(8),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
              onPressed: onButtonPressed,
            ),
          )
        ],
      ),
    );
  }
}
