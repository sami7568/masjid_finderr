import 'package:flutter/material.dart';

class AddMasjidCard extends StatelessWidget {
  final onBtnPressed;

  AddMasjidCard({@required this.onBtnPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                //List Icon
                Container(
                  margin: EdgeInsets.only(right: 22),
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/static_assets/list-icon.png"),
                    ),
                  ),
                ),

                ///List text
                Container(
                  child: Expanded(
                    child: Text(
                      "List your masjid on the Masjid Finder app, for others to follow.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          //Add Masjid Button
          Container(
            margin: EdgeInsets.only(top: 23),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              color: Color(0xFF00A8E5),
              child: Text(
                "Add Masjid",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
              onPressed: onBtnPressed,
            ),
          )
        ],
      ),
    );
  }
}
