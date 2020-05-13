import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-outlined-button.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/custom_widgets/custom-login-textfield.dart';

class UserSignUpScreen extends StatefulWidget {
  @override
  _UserSignUpScreenState createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
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
              color: Color(0xff00AFEF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text(
                      'Sign Up',
                      style: WhiteHeadTS,
                    ),
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
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextField(
            hint: 'FirstName LastName',
            label: 'User Name',
            controller: emailController,
          ),
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
          CustomTextField(
            hint: '*********',
            label: 'Cofirm Password',
            controller: passwordController,
            isPassword: true,
          ),
          SizedBox(height: 40),
          CustomBlueRoundedButton(
            child: Text(
              'SIGN UP',
              style: roundedBlueBtnTS,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
