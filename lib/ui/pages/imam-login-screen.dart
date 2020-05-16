import 'package:flutter/material.dart';
import 'package:masjid_finder/constants/colors.dart';
import 'package:masjid_finder/constants/text-styles.dart';
import 'package:masjid_finder/enums/auth-result-status.dart';
import 'package:masjid_finder/providers/auth-provider.dart';
import 'package:masjid_finder/services/auth-exception-handler.dart';
import 'package:masjid_finder/ui/custom_widgets/asset-logo.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-blue-rounded-button.dart';
import 'package:masjid_finder/ui/custom_widgets/custom-rounded-textfield.dart';
import 'package:masjid_finder/ui/pages/imam-signup-screen.dart';
import 'package:masjid_finder/ui/pages/mosque-not-listed.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ImamLoginScreen extends StatefulWidget {
  @override
  _ImamLoginScreenState createState() => _ImamLoginScreenState();
}

class _ImamLoginScreenState extends State<ImamLoginScreen> {
  bool isInProgress = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isInProgress,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ChangeNotifierProvider(
              create: (context) => AuthProvider(),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 50),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: greyBgColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AssetLogo('assets/static_assets/blue-logo.png'),
                    _signInForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signInForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomRoundedTextField(
            hint: 'userName@email.com',
            label: 'Email',
            onChange: (val) {
              email = val;
            },
          ),
          CustomRoundedTextField(
            hint: '*********',
            label: 'Password',
            isPassword: true,
            onChange: (val) {
              password = val;
            },
          ),
          SizedBox(height: 20),
          Consumer<AuthProvider>(builder: (context, authProvider, child) {
            return CustomBlueRoundedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'LOG IN',
                  style: roundedBlueBtnTS,
                ),
              ),
              onPressed: () async {
                setState(() {
                  isInProgress = true;
                });
                await authProvider.login(
                    email: email, pass: password, isImam: true);
                setState(() {
                  isInProgress = false;
                });
                if (authProvider.status == AuthResultStatus.successful) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MosqueNotListed()),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImamSignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
