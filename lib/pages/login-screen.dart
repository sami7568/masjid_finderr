import 'package:flutter/material.dart';
import 'package:masjid_finder/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/custom_widgets/custom-login-textfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                    'Login',
                    style: TextStyle(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomTextField(
                        hint: 'user-name@email.com',
                        label: 'Email',
                        controller: emailController,
                      ),
                      CustomTextField(
                        hint: '*********',
                        label: 'Password',
                        controller: passwordController,
                      ),
                      SizedBox(height: 40),
                      CustomBlueRoundedButton(
                        text: 'LOG IN',
                        onPressed: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Not yet Registered?"),
                          ],
                        ),
                      ),
                      CustomBlueRoundedButton(
                        text: 'SIGN UP',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
