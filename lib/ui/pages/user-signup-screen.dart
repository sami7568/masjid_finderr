import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';
import 'package:masjid_finder/models/user-model.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-rounded-textfield.dart';
import 'package:masjid_finder/ui/pages/location-access.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserSignUpScreen extends StatefulWidget {
  @override
  _UserSignUpScreenState createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  bool isInProgress = false;
  User user = User();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isInProgress,
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
                ),
              ),
            ),
          ),
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
          CustomRoundedTextField(
            hint: 'FirstName LastName',
            label: 'User Name',
            onChange: (val) {
              user.fullName = val;
            },
          ),
          CustomRoundedTextField(
            hint: 'userName@email.com',
            label: 'Email',
            onChange: (val) {
              user.email = val;
            },
          ),
          CustomRoundedTextField(
            hint: '*********',
            label: 'Password',
            isPassword: true,
            onChange: (val) {
              user.password = val;
            },
          ),
//          CustomRoundedTextField(
//            hint: '*********',
//            label: 'Cofirm Password',
//            controller: passwordController,
//            isPassword: true,
//          ),
          SizedBox(height: 40),
          Consumer<AuthProvider>(builder: (context, authProvider, child) {
            return CustomBlueRoundedButton(
              child: Text(
                'SIGN UP',
                style: roundedBlueBtnTS,
              ),
              onPressed: () async {
                setState(() {
                  isInProgress = true;
                });
                await authProvider.createAccount(user: user);
                setState(() {
                  isInProgress = false;
                });
                if (authProvider.status == AuthResultStatus.successful) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LocationAccess()),
                      (r) => false);
                } else {
                  final errorMsg =
                      AuthExceptionHandler.generateExceptionMessage(
                          authProvider.status);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Login Failed',
                          style: TextStyle(color: Colors.black),
                        ),
                        content: Text(errorMsg),
                      );
                    },
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
