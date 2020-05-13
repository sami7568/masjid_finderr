import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-outlined-button.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/custom_widgets/custom-login-textfield.dart';
import 'package:masjid_finder/custom_widgets/logo.dart';
import 'package:masjid_finder/main.dart';

class ImamLoginScreen extends StatefulWidget {
  @override
  _ImamLoginScreenState createState() => _ImamLoginScreenState();
}

class _ImamLoginScreenState extends State<ImamLoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
//        decoration: BoxDecoration(image: DecorationImage(image: )),
              color: greyBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Logo'),
                      Text(
                        'Masjid',
                        style: urduLogoTS.copyWith(fontSize: 20),
                      ),
                      Text(
                        'Finder',
                        style: urduLogoTS.copyWith(fontSize: 20),
                      )
                    ],
                  ),
                  _signUpForm(),
                ],
              )),
        ),
      ),
    );
  }

  _signUpForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextField(
            hint: 'userName@email.com',
            label: 'Email',
            controller: emailController,
          ),
          CustomTextField(
            hint: '*********',
            label: 'Password',
            controller: passwordController,
            isPassword: true,
          ),
          SizedBox(height: 20),
          CustomBlueRoundedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'LOG IN',
                style: roundedBlueBtnTS,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Not registered yet?', style: alreadyHaveAccountTS),
              SizedBox(width: 3),
              GestureDetector(
                child: Text(
                  'Signup',
                  style: alreadyHaveAccountTS.copyWith(
                    fontWeight: FontWeight.bold,
                    color: mainThemeColor,
                  ),
                ),
                onTap: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
