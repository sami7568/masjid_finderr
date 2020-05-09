import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/main.dart';

class CustomTextField extends StatelessWidget {
  final hint;
  final label;
  final onChange;
  final isPassword;
  final bottomPadding;
  final textCapitalization;
  final inputType;
  final controller;

  CustomTextField(
      {this.hint = '',
      this.controller,
      this.inputType = TextInputType.text,
      this.label,
      this.onChange,
      this.isPassword = false,
      this.bottomPadding = 16,
      this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        textCapitalization: textCapitalization,
        obscureText: isPassword,
        style:
            TextStyle(fontSize: 15, color: mainThemeColor, fontFamily: 'Arial'),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: mainThemeColor,
          )),
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 10, color: blueFontLabelColor, fontFamily: 'Arial'),
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 14, color: Color(0x5544C7D9), fontFamily: 'Arial'),
        ),
        onChanged: onChange,
      ),
    );
  }
}
