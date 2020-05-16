import 'package:flutter/material.dart';

class AssetLogo extends StatelessWidget {
  final imgUrl;

  AssetLogo(this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imgUrl,
          width: 120,
          height: 140,
          fit: BoxFit.contain,
        )
      ],
    );
  }
}
